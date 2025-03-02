package com.spring.med.approval.controller;

import java.io.File;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.med.approval.domain.ApprovalVO;
import com.spring.med.approval.service.ApprovalService;
import com.spring.med.common.FileManager;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

// **** 기안서 및 결재 컨트롤러 **** //

@Controller
@RequestMapping(value="/approval/*")
public class ApprovalController {
	
	@Autowired
	private ApprovalService approvalService;
	
	@Autowired
	private FileManager fileManager; 
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 기안문작성 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ==== 기안문작성 폼페이지 요청 ==== //
	@GetMapping("write")
	public ModelAndView writeDraftForm(ModelAndView mav) {
		mav.setViewName("content/approval/write");
		
		return mav;
	}
	
	// ==== 휴가신청서 양식 예시 ==== //
	@GetMapping("dayLeaveForm")
	public ModelAndView dayLeaveForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/dayLeaveForm");
		return mav;
	}
	
	// ==== 지출결의서 양식 예시 ==== //
	@GetMapping("expenseReportForm")
	public ModelAndView expenseReportForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/expenseReportForm");
		return mav;
	}
	
	// ==== 근무 교대 신청서 양식 예시 ==== //
	@GetMapping("workChangeForm")
	public ModelAndView workChangeForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/workChangeForm");
		return mav;
	}
	
	// ==== 출장신청서 양식 예시 ==== //
	@GetMapping("businessTripForm")
	public ModelAndView businessTripForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/businessTripForm");
		return mav;
	}
	
	
	// ==== 선택한 기안 양식 가져오기 ==== //
	@GetMapping("writeDraft")
	public ModelAndView writeDraft(ModelAndView mav,
								   HttpServletRequest request,
								   @RequestParam String typeSelect
								   ) {
		
		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		Map<String, Object> paraMap = new HashMap<>();
		
		if(loginuser != null) {
			
			// 기안자 정보 불러오기
			ApprovalVO memverInfo = approvalService.insertToApprovalLine(loginuser.getMember_userid());
			
			// 문서번호 생성
			String draft_no = approvalService.createDraftNo();
			
			// 기안일자 
			LocalDate now = LocalDate.now();	// 현재날짜
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
			String now_date = now.format(formatter);

			paraMap.put("memverInfo", memverInfo);
			paraMap.put("draft_no", draft_no);		
			paraMap.put("now_date", now_date);
		}
		
		
		if(typeSelect.equals("휴가신청서")) {
			
			// 잔여 연차 조회
			String member_yeoncha = approvalService.leftoverYeoncha(loginuser.getMember_userid());
			paraMap.put("member_yeoncha", member_yeoncha);	
			
			// 문서 양식
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("지출결의서")) {
			
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("근무 변경 신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");			
		}
		else if(typeSelect.equals("출장신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}

		mav.addObject("paraMap", paraMap);
		
		return mav;
	}
	
	
	// ==== 결재선 목록에 선택한 사원 추가하기 ==== //
	@PostMapping("insertToApprovalLine")
	@ResponseBody
	public ApprovalVO insertToApprovalLine(@RequestParam String member_userid) {

		ApprovalVO member = approvalService.insertToApprovalLine(member_userid);
		
		return member;
	}
	
	
	// ==== 참조자 목록에 선택한 사원 추가하기 ==== //
	@PostMapping("insertToReference")
	@ResponseBody
	public ApprovalVO insertToReference(@RequestParam String member_userid) {

		ApprovalVO member = approvalService.insertToApprovalLine(member_userid);
		
		return member;
	}
	
	
	// ==== 결재선 결재순위 지정 ==== // 
	@PostMapping("orderByApprovalStep")
	@ResponseBody
	public List<HashMap<String, String>> orderByApprovalStep(@RequestParam String[] arr_approvalLineMembers) {
		
		List<HashMap<String, String>> memberList = approvalService.orderByApprovalStep(arr_approvalLineMembers);

		return memberList;
	}
	
	
	// ==== 참조자 목록 순서 지정 ==== // 
	@PostMapping("orderByReferenceMember")
	@ResponseBody
	public List<HashMap<String, String>> orderByReferenceMember(@RequestParam String[] arr_referenceMembers) {
		
		List<HashMap<String, String>> memberList = approvalService.orderByReferenceMembers(arr_referenceMembers);

		return memberList;
	}
	
	
	// ==== 기존에 추가했던 결재선 사원을 목록에 불러오기 ==== //
	@PostMapping("insertToApprovalLine_Arr")
	@ResponseBody
	public List<ApprovalVO> insertToApprovalLine_Arr(@RequestParam String[] arr_approvalLineMembers) {

		List<ApprovalVO> memberList = approvalService.insertToApprovalLine_Arr(arr_approvalLineMembers);
		
		return memberList;
	}
	
	
	// ==== 기존에 추가했던 참조자 사원을 목록에 불러오기 ==== //
	@PostMapping("insertToReferenceMember_Arr")
	@ResponseBody
	public List<ApprovalVO> insertToReferenceMember_Arr(@RequestParam String[] arr_referenceMembers) {

		List<ApprovalVO> memberList = approvalService.insertToReferenceMember_Arr(arr_referenceMembers);
		
		return memberList;
	}

	
	// ==== 기안문 임시저장하기 ==== // 
	@PostMapping("insertToTemporaryStored")
	@ResponseBody
	public int insertToTemporaryStored(MultipartHttpServletRequest mtp_request) {
		
		Map<String, Object> paraMap = new HashMap<>();
	
		paraMap.put("fk_member_userid", mtp_request.getParameter("fk_member_userid"));
		paraMap.put("draft_no", mtp_request.getParameter("draft_no"));
		paraMap.put("draft_form_type", mtp_request.getParameter("draft_form_type"));
		paraMap.put("draft_subject", mtp_request.getParameter("draft_subject"));
		paraMap.put("draft_write_date", mtp_request.getParameter("draft_write_date"));
		paraMap.put("draft_urgent", mtp_request.getParameter("draft_urgent"));
		paraMap.put("day_leave_start", mtp_request.getParameter("day_leave_start"));
		paraMap.put("day_leave_end", mtp_request.getParameter("day_leave_end"));
		paraMap.put("day_leave_cnt", mtp_request.getParameter("day_leave_cnt"));
		paraMap.put("day_leave_reason", mtp_request.getParameter("day_leave_reason"));
		
		
		try {
			String mtp_approvalLineMember = mtp_request.getParameter("approvalLineMember");
			String mtp_referMember = mtp_request.getParameter("referMember");
			
			// >>> JSON 문자열을 Map 으로 변환 <<<
			ObjectMapper objectMapper = new ObjectMapper();
			
			if(mtp_approvalLineMember != null && mtp_referMember == null) {
				Map<String, String> approvalLineMember = objectMapper.readValue(mtp_approvalLineMember, new TypeReference<Map<String, String>>(){});
				paraMap.put("approvalLineMember", approvalLineMember);
			}
			else if(mtp_approvalLineMember == null && mtp_referMember != null) {
				Map<String, String> referMember = objectMapper.readValue(mtp_referMember, new TypeReference<Map<String, String>>(){});
				paraMap.put("referMember", referMember);
			}
			else if(mtp_approvalLineMember != null && mtp_referMember != null) {
				Map<String, String> approvalLineMember = objectMapper.readValue(mtp_approvalLineMember, new TypeReference<Map<String, String>>(){});
				Map<String, String> referMember = objectMapper.readValue(mtp_referMember, new TypeReference<Map<String, String>>(){});
				paraMap.put("approvalLineMember", approvalLineMember);
				paraMap.put("referMember", referMember);
			}
			else {
				paraMap.put("approvalLineMember", mtp_request.getParameter("approvalLineMember"));
				paraMap.put("referMember", mtp_request.getParameter("referMember"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// >>>> 파일이 있는 경우 <<<<
		MultipartFile attachFile = mtp_request.getFile("file");	// 첨부한 파일 가져오기
		
		if(attachFile != null) {
			
			// WAS(톰캣)의 절대경로 알아오기
			HttpSession session = mtp_request.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root + "resources" + File.separator + "draft";  // 파일 저장 위치
			
			// 만약 폴더가 없으면 생성
			File dir = new File(path);
			if(!dir.exists()) {
				dir.mkdir();
			}

			String newFileName = "";	// WAS(톰캣)의 디스크에 저장될 파일명
			byte[] bytes = null;		// 파일 내용 담을 변수
			long fileSize = 0;			// 첨부파일의 크기
			
			try {
					bytes = attachFile.getBytes(); // 첨부파일의 내용물 읽어오기
					
					String originalFilename = attachFile.getOriginalFilename();	// 첨부파일의 실제 파일명
					
					fileSize = attachFile.getSize(); // 첨부된 파일의 파일사이즈
					
					// >>> 첨부된 파일을 저장소에 업로드
					newFileName = fileManager.doFileUpload(bytes, originalFilename, path);	
					
					paraMap.put("draft_file_name", newFileName);				// 저장된 파일명
					paraMap.put("draft_file_origin_name", originalFilename);	// 원본파일명
					paraMap.put("draft_file_size", String.valueOf(fileSize));	// 파일사이즈
	
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
		
		int result = 0;
		
		// ==== 첨부파일이 없는 경우 기안문 임시저장하기 ==== //
		if(attachFile == null) {
			result = approvalService.insertToTemporaryStored(paraMap);
		}
		// ==== 첨부파일이 있는 경우 기안문 임시저장하기 ==== //
		else if(attachFile != null) {
			result = approvalService.insertToTemporaryStored_withFile(paraMap);
		}
		
		return result;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 결재상신함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 임시저장함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ==== 임시저장함 폼페이지 요청 ==== //
	@GetMapping("approvalTemporaryList")
	public ModelAndView approvalTemporaryList(ModelAndView mav
			                                , HttpServletRequest request
			                                , @RequestParam(defaultValue = "") String searchType
			                                , @RequestParam(defaultValue = "") String searchWord
			                                , @RequestParam(defaultValue = "10") int sizePerPage
			                                , @RequestParam(defaultValue = "1") int currentShowPageNo) {

		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("member_userid", loginuser.getMember_userid());
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		// >>> 총 게시물 건수 구하기 <<< ///
		int totalCount = 0;
		int totalPage = 0;
		
		totalCount = approvalService.getTotalCount(paraMap);
		
		// 페이지 당 보여줄 기안문 개수에 따라 총 페이지 수 구하기
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
			
		try {
			// url 에 잘못된 페이지번호가 입력 될 경우 첫 페이지로 처리
			if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
				currentShowPageNo = 1;
			}
		} catch (NumberFormatException e) {
			currentShowPageNo = 1;
		}
		
		
		// >>> 페이지당 보여줄 목록 가져오기 <<< //
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 범위시작
		int endRno = startRno + sizePerPage -1;	// 범위끝
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// >>> 임시저장함 기안문 불러오기 <<< //
		List<ApprovalVO> temporaryList = approvalService.selectTemporaryList(paraMap);
		mav.addObject("temporaryList", temporaryList);
		
		// 검색어 유지시키기 위해 데이터 전달
		if("draft_form_type".equals(searchType) || "draft_subject".equals(searchType)) {	
			mav.addObject("paraMap", paraMap);
		}
		
		// >>> 페이지바 생성 <<< //
		int blockSize = 10;	// 한 줄에 보이는 페이지 번호 개수
		int loop = 1;		// 페이지바의 다음 줄을 보여주는데 사용
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
	    String url = "approvalTemporaryList";
	    
	    // === [맨처음][이전] 만들기 === //
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'><<</a></li>";
       
	    if(pageNo != 1) {  // 내가 보고자 하는 넘버가 1페이지가 아닐 때(맨처음 페이지라면 [이전]이 없음)
	    	pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'><</a></li>";
	    }
      
	    while( !(loop > blockSize || pageNo > totalPage) ) {   // 10 보다 크거나 totalPage 보다 크면 안 된다
          
          
	    	if(pageNo == currentShowPageNo) {  // 내가 현재 보고자 하는 페이지(현재페이지는 a태그 뺌)
            	pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border: solid 1px gray; color:red; padding:2px 4px'>"+pageNo+"</li>";
	    	}
	    	else { 
	    		pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
	    	}
             
	    	loop++;
	    	pageNo++;
	    }  // end of while ------------------------------ (10번을 반복하면 빠져나옴)
       
       
	    // === [다음][마지막] 만들기 === //
	    if(pageNo <= totalPage) {  // 맨 마지막 페이지라면 [다음]이 없음
	    	pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>></a></li>";
	    }
 
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>>></a></li>";
         
	    pageBar += "</ul>"; 
       
	    mav.addObject("pageBar", pageBar); // modelandview(뷰단페이지에 페이지바를 나타냄)

		mav.setViewName("content/approval/approvalTemporaryList");

		return mav;
	}
	
		
	// ==== 임시저장함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
	@PostMapping("approvalTemporaryDetail")
	public ModelAndView approvalTemporaryDetail(ModelAndView mav, @RequestParam String draft_no) {
		
		ApprovalVO approvalvo = approvalService.approvalTemporaryDetail(draft_no);
		
		mav.addObject("approvalvo", approvalvo);
		mav.setViewName("/content/approval/write");
		
		return mav;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 결재문서함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 참조문서함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	
}
