package com.spring.med.memo.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.memo.domain.MemoVO;
import com.spring.med.memo.service.MemoService;
import com.spring.med.notice.domain.NoticeVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/memo/*")
public class MemoController {

  @Autowired // Type 에 따라 알아서 Bean 을 주입해준다. 
  private MemoService service;
 
/*
	// 메모장 폼 페이지 요청
	@GetMapping("memowrite")
	public ModelAndView memo(ModelAndView mav, HttpServletRequest request) {

		// 1. DB에서 메모 목록 가져오기
	    List<MemoVO> memoList = service.getMemoList();

	    // 2. JSP로 전달할 데이터 설정
	    mav.addObject("memoList", memoList);


		mav.setViewName("content/memo/memowrite"); 
		// /WEB-INF/views/content/memo/memowrite.jsp 파일을 생성한다.

		return mav;
	}
	
	// 중요메모
	@GetMapping("importantmemo")
	public ModelAndView importantmemo(ModelAndView mav) {


		mav.setViewName("content/memo/importantmemo"); 
		// /WEB-INF/views/content/memo/importantmemo.jsp 파일을 생성한다.

		return mav;
	}
	
	// 삭제메모
	@GetMapping("trash")
	public ModelAndView trash(ModelAndView mav) {


		mav.setViewName("content/memo/trash"); 
		// /WEB-INF/views/content/memo/trash.jsp 파일을 생성한다.

		return mav;
	}
*/
  
  
  // 메모 목록 보기 (무한 스크롤 적용 해야 함)
  @GetMapping("memolist")
  public ModelAndView memo_list(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {

      HttpSession session = request.getSession();
      ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

      String fk_member_userid = loginuser.getMember_userid();

      // 파라미터 맵 생성
      Map<String, String> paraMap = new HashMap<>();
      paraMap.put("fk_member_userid", fk_member_userid);

      // 모든 메모 리스트 조회 (페이징 없이)
      List<MemoVO> memo_list = service.memo_list(paraMap);

      mav.addObject("fk_member_userid", fk_member_userid);
      mav.addObject("memo_list", memo_list);
      mav.addObject("loginuser", loginuser);
      mav.setViewName("content/memo/memolist"); // 목록 페이지로 이동
      
      return mav;
  }


  
  
  // 메모쓰기
  @PostMapping("memowrite")
  public String memoWrite(HttpServletRequest request, ModelAndView mav, @ModelAttribute MemoVO memovo) {
	  
	  // System.out.println("제목: " + memovo.getMemo_title());
      // System.out.println("내용: " + memovo.getMemo_contents());
	  
      HttpSession session = request.getSession();
      ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

      memovo.setFk_member_userid(loginuser.getMember_userid());

      // 메모 저장 실행
      int result = service.insertMemo(memovo);


      return "redirect:/memo/memolist";

  }
  

  
  //메모 수정하기 
  @PutMapping("memoupdate")
  @ResponseBody
  public Map<String, Integer> memoupdate(@RequestBody Map<String, Object> paraMap) {
	  
//	  System.out.println(" /memo/memoupdate 요청 도착!"); // 확인용 로그 추가
//	  System.out.println("받은 데이터 : " + paraMap);
	  
      Map<String, Integer> response = new HashMap<>();
      
      if (paraMap.get("memo_no") == null) {
          response.put("result", 0);
          return response;
      }
      
      int memo_no;
      try {
          memo_no = Integer.parseInt(String.valueOf(paraMap.get("memo_no")));
      } catch (NumberFormatException e) {
          response.put("result", 0);
          return response;
      }

      String memo_title = String.valueOf(paraMap.get("memo_title"));
      String memo_contents = String.valueOf(paraMap.get("memo_contents"));

//      System.out.println("memo_no: " + memo_no);
//      System.out.println("memo_title: " + memo_title);
//      System.out.println("memo_contents: " + memo_contents);
      
      
      int result = service.updateMemo(memo_no, memo_title, memo_contents);
      
//      System.out.println("DB 업데이트 결과 : " + result);
      
		response.put("result", result);
		return response; // {"result":1}
	}

  
  
  	// 메모 삭제 (휴지통으로 이동)
	@DeleteMapping("trash")
	public ResponseEntity<Map<String, Object>> memoDelete(@RequestBody Map<String, Object> paraMap) {
		Map<String, Object> response = new HashMap<>();

		// memo_no 검증
		if (!paraMap.containsKey("memo_no") || paraMap.get("memo_no") == null) {
//			response.put("status", "fail");
//			response.put("message", "메모 번호가 없습니다.");
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}

		int memo_no;
		try {
			memo_no = Integer.parseInt(String.valueOf(paraMap.get("memo_no")));
		} catch (NumberFormatException e) {
//			response.put("status", "fail");
//			response.put("message", "잘못된 메모 번호 형식입니다.");
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}

		// 메모를 휴지통으로 이동 (DB 상태 업데이트)
		int result = service.trash(memo_no);

		if (result > 0) {
			response.put("status", "success");
			response.put("message", "메모가 휴지통으로 이동되었습니다.");
			response.put("memo_no", memo_no);
			return ResponseEntity.ok(response);
		} else {
//			response.put("status", "fail");
//			response.put("message", "메모 이동 실패");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	
	////////////////////////// 휴지통 시작 /////////////////////////////
	
	// 휴지통에서 복원하기
	@PutMapping("restoreMemo")
	public ResponseEntity<Map<String, Object>> restoreMemo(@RequestBody Map<String, Object> paraMap) {
		processMemoAction(paraMap, "restore");
		return ResponseEntity.ok(paraMap); // 200 OK 응답 보장
	}

	// 휴지통에서 완전 삭제하기
	@DeleteMapping("deleteTrash")
	public ResponseEntity<Map<String, Object>> deleteTrash(@RequestBody Map<String, Object> paraMap) {
		processMemoAction(paraMap, "delete");
		return ResponseEntity.ok(paraMap); // 200 OK 응답 보장
	}

	// 공통 처리 메서드 => action 수행할 동작 ("restore" 또는 "delete")
	private Map<String, Object> processMemoAction(Map<String, Object> paraMap, String action) {

		try {
			int memo_no = Integer.parseInt(paraMap.get("memo_no").toString());
//			System.out.println("복원하려는 메모 번호: " + memo_no);

			int result = (action.equals("restore")) ? service.restoreMemo(memo_no) : service.deleteTrash(memo_no);
//			System.out.println("복원 결과: " + result);

			paraMap.put("status", (result > 0) ? "success" : "fail");
			paraMap.put("message", action.equals("restore") ? (result > 0 ? "메모가 복원되었습니다." : "메모 복원 실패")
					: (result > 0 ? "메모가 완전 삭제되었습니다." : "메모 삭제 실패"));

		} catch (Exception e) {
			paraMap.put("status", "error");
			paraMap.put("message", "예외 발생");
		}
		return paraMap; // paraMap을 그대로 반환
	}
	
	
	
  // 휴지통으로 이동한 메모 조회
  @GetMapping("trashlist")
  public ModelAndView trash_list(ModelAndView mav, HttpServletRequest request) {
	  
      HttpSession session = request.getSession();
      ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

      String fk_member_userid = loginuser.getMember_userid();
      
//    System.out.println("확인용~~~~~~~" + fk_member_userid);

      // Map을 사용하여 파라미터를 전달
      Map<String, Object> paraMap = new HashMap<>();
      paraMap.put("fk_member_userid", fk_member_userid);
      
      // 휴지통에서 삭제된 메모 목록 조회
      List<MemoVO> trash_list = service.trash_list(paraMap); 
//    System.out.println("확인용~~~~~~~ Trash List: " + trash_list);
      

      mav.addObject("fk_member_userid", fk_member_userid);
      mav.addObject("trash_list", trash_list);
      mav.addObject("loginuser", loginuser);
      
      mav.setViewName("content/memo/trashlist"); // 목록 페이지로 이동
      
      return mav;
  }




  ////////////////////////// 휴지통 끝 /////////////////////////////
  
  
  
  ////////////////////////// 즐겨찾기 시작 /////////////////////////////
  // 메모 즐겨찾기 상태 업데이트 
  @PostMapping("memoMark")
  @ResponseBody
  public Map<String, Object> memoBookmark(@RequestParam String memo_no, HttpServletRequest request) {
      
      HttpSession session = request.getSession();
      ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

      Map<String, Object> resultMap = new HashMap<>();
      
      if (loginuser != null) {
          String member_userid = loginuser.getMember_userid();
          
          Map<String, String> paraMap = new HashMap<>();
          paraMap.put("memo_no", memo_no);
          paraMap.put("member_userid", member_userid);

          // 로그 추가해서 요청이 들어오는지 확인
          System.out.println("요청 도착! / 메모 번호: " + memo_no + " / 유저 ID: " + member_userid);
          
          // 현재 중요 메모 여부 확인
          String importance = service.getMemoImportance(paraMap);
          System.out.println(" 현재 중요 여부: " + importance);

          if ("0".equals(importance)) {
              service.updateMemoImportance(paraMap, "1"); // 중요 메모(즐겨찾기)로 설정
              resultMap.put("success", true);
              resultMap.put("isBookmark", true); // 즐겨찾기 추가됨
          } else {
              service.updateMemoImportance(paraMap, "0"); // 일반 메모로 변경
              resultMap.put("success", true);
              resultMap.put("isBookmark", false); // 즐겨찾기 해제됨
          }
      } else {
          resultMap.put("success", false);
      }
      
      return resultMap;
  }



  	//즐겨찾기한 메모 조회
	@GetMapping("importantmemolist")
	public ModelAndView importantMemoList(HttpServletRequest request, ModelAndView mav) {

		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

		// 로그인 확인
		if (loginuser == null) {
			mav.setViewName("redirect:/member/login"); // 로그인 페이지로 이동
			return mav;
		}

		String member_userid = loginuser.getMember_userid(); // 로그인한 사용자 ID 가져오기

		// 즐겨찾기한 메모 리스트 가져오기
		List<MemoVO> importantMemoList = service.getImportantMemoList(member_userid);

		// ⭐ 가져온 데이터가 정확한지 로그 확인
	    for (MemoVO memovo : importantMemoList) {
	        System.out.println("메모번호: " + memovo.getMemo_no() + " / 중요여부: " + memovo.getMemo_importance());
	    }
		
		mav.addObject("importantMemoList", importantMemoList);
		mav.addObject("loginuser", loginuser);

		mav.setViewName("content/memo/importantmemolist"); // JSP 경로
		return mav;
	}
  
  
/*  

  //중요 메모(즐겨찾기) 목록 가져오기 
  @GetMapping("selectmemomark")
  @ResponseBody
  public List<Map<String, String>> selectImportantMemo(HttpServletRequest request) {
      
      HttpSession session = request.getSession();
      ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

      String member_userid = loginuser.getMember_userid();

      List<Map<String, String>> memoList = service.selectImportantMemo(member_userid);

      System.out.println("확인용: " + memoList); // 콘솔 로그 확인용

      return memoList;
  }


  
  
 */ 
}

