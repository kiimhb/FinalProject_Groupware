package com.spring.med.index.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.attendance.service.AttendanceRecordService;
import com.spring.med.index.service.IndexService;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.notice.domain.NoticeVO;
import com.spring.med.notice.service.NoticeService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/*")
public class IndexController {

	@Autowired
	private IndexService service;
	
	@Autowired
	private AttendanceRecordService attendanceRecordService;
	
	@Autowired
	private NoticeService noticeService;

	// === 메인 페이지 요청 === //
	@GetMapping("/") 
	public String main() {
		return "redirect:/index"; 
	}

	@GetMapping("index")
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = Index_commuteRecord(request, response, new ModelAndView("content/main/index"));
		 mav = requiredLogin_notice_list(request, response, mav); 

		return mav;
	}

	
	@GetMapping("Index_commuteRecord")
	public ModelAndView Index_commuteRecord(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
	    new ModelAndView("content/main/index"); 
	    
	    HttpSession session = request.getSession();
	    ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

	    if (loginuser != null) {
		    String member_userid = loginuser.getMember_userid();
		        
	        // 이름 알아오기
	        String name = attendanceRecordService.getName(member_userid);
	        mav.addObject("member_name", name);
	        
	        // 오늘 출근 기록
	        Map<String, String> todayStartRecord = service.getTodayStartRecord(member_userid);
	        // 오늘 퇴근 기록
	        Map<String, String> todayEndRecord = service.getTodayEndRecord(member_userid);
	        
	        mav.addObject("TodayStartRecord", todayStartRecord);
	        mav.addObject("TodayEndRecord", todayEndRecord);
	        mav.addObject("member_userid", member_userid);
	    }
	    return mav;
	}
	
	@GetMapping("Index_notice_list")
	public ModelAndView requiredLogin_notice_list(HttpServletRequest request, HttpServletResponse response,
			  ModelAndView mav) {
		new ModelAndView("content/main/index");
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		if (loginuser != null) {
		String fk_member_userid = loginuser.getMember_userid();
		int member_grade = Integer.parseInt(loginuser.getMember_grade()); // 로그인 한 유저의 grade-level 알아오기 
		String fk_child_dept_no = loginuser.getFk_child_dept_no(); 	//  로그인 한 유저의 부서 알아오기
																   	// 1~7:진료부 / 8~10:간호부 / 11~13:경영지원부
		mav.addObject("member_grade", member_grade);
		mav.addObject("fk_member_userid", fk_member_userid);
		
		int parent_dept_no; // 1: 진료부 2:간호부 3: 경영지원부
		int child_dept_no = Integer.parseInt(fk_child_dept_no); // 값 비교를 위해 int 형으로 바꿈
		
		if(child_dept_no >= 1 && child_dept_no <= 7) {
			parent_dept_no = 1; // 진료부
		}
		else if(child_dept_no >= 8 && child_dept_no <= 10) {
			parent_dept_no = 2; // 간호부
		}
		else {
			parent_dept_no = 3; // 경영지원부
		}
		
		Map<String, Object> paraMap = new HashMap<>();
		List<Integer> parent_deptList = Arrays.asList(0, parent_dept_no); // 0 은 전체공지 , 나머지는 매번 바뀐다.
		
		paraMap.put("parent_deptList", parent_deptList);
		
		int totalCount = 0; 
		
		totalCount = noticeService.getNoticeCount(paraMap); // 개인별(부서별) 총 공지사항 개수 (totalCount) 전체공지 + 해당 부서 공지사항
//		System.out.println("totalCount"+totalCount);
		mav.addObject("totalCount", totalCount);
		
		List<NoticeVO> notice_list = service.notice_list(paraMap);
//		System.out.println(notice_list);
		mav.addObject("notice_list", notice_list);
		}
		return mav;
	}
	   @PostMapping("weatherXMLtoJSON")
	   @ResponseBody
	   public String weatherXMLtoJSON(HttpServletRequest request) {
	      
	      String str_jsonObjArr = request.getParameter("str_jsonObjArr");
	      
	   //   System.out.println(str_jsonObjArr);
	     
	      str_jsonObjArr = str_jsonObjArr.substring(1, str_jsonObjArr.length()-1);
	   //   System.out.println(str_jsonObjArr);
	      
	      String[] arr_str_jsonObjArr = str_jsonObjArr.split("\\},");
	      
	      for(int i=0; i<arr_str_jsonObjArr.length; i++) {
	         arr_str_jsonObjArr[i] += "}";
	      }// end of for-------------
	      
	      String[] locationArr = {"서울","인천","수원","춘천","강릉","청주","홍성","대전","안동","포항","대구","전주","울산","부산","창원","여수","광주","목포","제주","울릉도","백령도"}; 
	      String result = "[";
	      
	      for(String jsonObj : arr_str_jsonObjArr) {
	         
	         for(int i=0; i<locationArr.length; i++) {
	            if( jsonObj.indexOf(locationArr[i]) >= 0 && jsonObj.indexOf("북") == -1 && jsonObj.indexOf("서청주") == -1 ) { // 북춘천,춘천,북강릉,강릉,북부산,부산이 있으므로  "북" 이 있는 것은 제외하도록 한다. 또한 서청주(예)도 제외하도록 한다.    
	               result += jsonObj+",";
	               break;
	            }
	         }// end of for--------------
	         
	      }// end of for----------------------
	      
	   //   System.out.println(result);	      
	      result = result.substring(0, result.length()-1);
	      result = result + "]";
	      
	   //   System.out.println(result);
	      
	      return result;
	      
	   }
	   
	   
	   @GetMapping("alarm")
	   @ResponseBody 
	   public List<Map<String, String>> alarm (HttpServletRequest request, HttpServletResponse response, ManagementVO_ga managementVO_ga) {
	   HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		if (loginuser != null) {
			int totalCount = 0; 
			
			Map<String, Object> paraMap = new HashMap<>();
			
			totalCount = noticeService.getNoticeCount(paraMap);
		}
	   }
}
