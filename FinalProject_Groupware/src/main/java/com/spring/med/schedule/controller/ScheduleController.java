package com.spring.med.schedule.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

// import com.spring.med.member.domain.MemberVO;
import com.spring.med.common.MyUtil;
import com.spring.med.schedule.domain.Calendar_schedule_VO;
import com.spring.med.schedule.domain.Calendar_small_category_VO;
import com.spring.med.schedule.service.ScheduleService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/schedule/*")
public class ScheduleController {

	@Autowired
	private ScheduleService service;
	
	
	// === 일정관리 시작 페이지 ===
	@GetMapping("scheduleManagement")
	public ModelAndView requiredLogin_showSchedule(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { 
		
		mav.setViewName("content/schedule/scheduleManagement");
		// Aop, LoginCheckInterceptor.java // ==== 로그인 여부 검사 ==== // 에서 로그인 막아뒀음

		return mav;
	}
	
	
	// === 사내 캘린더에 사내캘린더 소분류 추가하기 ===
	@ResponseBody
	@PostMapping("addComCalendar")
	public String addComCalendar(HttpServletRequest request) throws Throwable {
		
		String com_small_category_name = request.getParameter("com_small_category_name");
		String fk_member_userid = request.getParameter("fk_member_userid");
		
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("com_small_category_name",com_small_category_name);
		paraMap.put("fk_member_userid",fk_member_userid);
		
		int n = service.addComCalendar(paraMap);
				
		JSONObject jsObj = new JSONObject();
		jsObj.put("n", n);
		
		return jsObj.toString();
	}
	
	
	// === 내 캘린더에 내캘린더 소분류 추가하기 ===
	@ResponseBody
	@PostMapping("addMyCalendar")
	public String addMyCalendar(HttpServletRequest request) throws Throwable {
		
		String my_small_category_name = request.getParameter("my_small_category_name");
		String fk_member_userid = request.getParameter("fk_member_userid");
		
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("my_small_category_name",my_small_category_name);
		paraMap.put("fk_member_userid",fk_member_userid);
		
		int n = service.addMyCalendar(paraMap);
				
		JSONObject jsObj = new JSONObject();
		jsObj.put("n", n);
		
		return jsObj.toString();
	}
	
	
	// === 사내 캘린더에서 사내캘린더 소분류  보여주기 ===
	@ResponseBody
	@GetMapping(value="showCompanyCalendar", produces="text/plain;charset=UTF-8")  
	public String showCompanyCalendar() {
		
		List<Calendar_small_category_VO> calendar_small_category_VO_CompanyList = service.showCompanyCalendar();
		
		JSONArray jsonArr = new JSONArray();
		
		if(calendar_small_category_VO_CompanyList != null) {
			for(Calendar_small_category_VO smcatevo : calendar_small_category_VO_CompanyList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("small_category_no", smcatevo.getSmall_category_no());
				jsObj.put("small_category_name", smcatevo.getSmall_category_name());
				jsonArr.put(jsObj);
			}
		}
		
		return jsonArr.toString();
	}
	
	
	// === 내 캘린더에서 내캘린더 소분류  보여주기 ===
	@ResponseBody
	@GetMapping(value="showMyCalendar", produces="text/plain;charset=UTF-8") 
	public String showMyCalendar(HttpServletRequest request) {
		
		String fk_member_userid = request.getParameter("fk_member_userid");
		
		List<Calendar_small_category_VO> calendar_small_category_VO_CompanyList = service.showMyCalendar(fk_member_userid);
		
		JSONArray jsonArr = new JSONArray();
		
		if(calendar_small_category_VO_CompanyList != null) {
			for(Calendar_small_category_VO smcatevo : calendar_small_category_VO_CompanyList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("small_category_no", smcatevo.getSmall_category_no());
				jsObj.put("small_category_name", smcatevo.getSmall_category_name());
				jsonArr.put(jsObj);
			}
		}
		
		return jsonArr.toString();
	}
	
	
	// === 풀캘린더에서 날짜 클릭할 때 발생하는 이벤트(일정 등록창으로 넘어간다) ===
	@PostMapping("insertSchedule")
	public ModelAndView insertSchedule(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { 
		
		// form 에서 받아온 날짜
		String chooseDate = request.getParameter("chooseDate");
		
		mav.addObject("chooseDate", chooseDate);
		mav.setViewName("content/community/schedule/chooseDate");
		
		return mav;
	}
	
	
	// === 일정 등록시 내캘린더,사내캘린더 선택에 따른 서브캘린더 종류를 알아오기 ===
	@ResponseBody
	@GetMapping(value="selectSmallCategory", produces="text/plain;charset=UTF-8") 
	public String selectSmallCategory(HttpServletRequest request) {
		
		String fk_large_category_no = request.getParameter("fk_large_category_no"); // 캘린더 대분류 번호
		String fk_member_userid = request.getParameter("fk_member_userid");       // 사용자아이디
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("fk_large_category_no", fk_large_category_no);
		paraMap.put("fk_member_userid", fk_member_userid);
		
		List<Calendar_small_category_VO> small_category_VOList = service.selectSmallCategory(paraMap);
			
		JSONArray jsArr = new JSONArray();
		if(small_category_VOList != null) {
			for(Calendar_small_category_VO scvo : small_category_VOList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("small_category_no", scvo.getSmall_category_no());
				jsObj.put("small_category_name", scvo.getSmall_category_name());
				
				jsArr.put(jsObj);
			}
		}
		
		return jsArr.toString();
	}
	
	
	// === 공유자를 찾기 위한 특정글자가 들어간 회원명단 불러오기 ===
/*	
	@ResponseBody
	@GetMapping(value="insertSchedule/searchJoinUserList", produces="text/plain;charset=UTF-8")
	public String searchJoinUserList(HttpServletRequest request) {
		
		String joinUserName = request.getParameter("joinUserName");
		
		// 사원 명단 불러오기
		List<MemberVO> joinUserList = service.searchJoinUserList(joinUserName);

		JSONArray jsonArr = new JSONArray();
		if(joinUserList != null && joinUserList.size() > 0) {
			for(MemberVO mvo : joinUserList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("userid", mvo.getUserid());
				jsObj.put("name", mvo.getName());
				
				jsonArr.put(jsObj);
			}
		}
		
		return jsonArr.toString();
		
	}
*/	
	
	// === 일정 등록하기 ===
	@PostMapping("registerSchedule_end")
	public ModelAndView registerSchedule_end(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String schedule_startdate= request.getParameter("schedule_startdate");
   	//  System.out.println("확인용 schedule_startdate => " + schedule_startdate);
	//  확인용 schedule_startdate => 20231129140000
   	    
		String schedule_enddate = request.getParameter("schedule_enddate");
		String schedule_subject = request.getParameter("schedule_subject");
		String fk_large_category_no= request.getParameter("fk_large_category_no");
		String fk_small_category_no = request.getParameter("fk_small_category_no");
		String schedule_color = request.getParameter("schedule_color");
		String schedule_place = request.getParameter("schedule_place");
		String schedule_joinuser = request.getParameter("schedule_joinuser");
		
     //	System.out.println("확인용 schedule_joinuser => " + schedule_joinuser);
	 // 확인용 schedule_joinUser_es =>
	 // 또는 
	 // 확인용 schedule_joinUser_es => 이순신(leess),아이유1(iyou1),설현(seolh) 	
		
		String schedule_content = request.getParameter("schedule_content");
		String fk_member_userid = request.getParameter("fk_member_userid");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("schedule_startdate", schedule_startdate);
		paraMap.put("schedule_enddate", schedule_enddate);
		paraMap.put("schedule_subject", schedule_subject);
		paraMap.put("fk_large_category_no",fk_large_category_no);
		paraMap.put("fk_small_category_no", fk_small_category_no);
		paraMap.put("schedule_color", schedule_color);
		paraMap.put("schedule_place", schedule_place);
		
		paraMap.put("schedule_joinuser", schedule_joinuser);
		
		paraMap.put("schedule_content", schedule_content);
		paraMap.put("fk_member_userid", fk_member_userid);
		
		int n = service.registerSchedule_end(paraMap);

		if(n == 0) {
			mav.addObject("message", "일정 등록에 실패하였습니다.");
		}
		else {
			mav.addObject("message", "일정 등록에 성공하였습니다.");
		}
		
		mav.addObject("loc", request.getContextPath()+"/schedule/scheduleManagement");
		
		mav.setViewName("msg");
		
		return mav;
	}
	
	
	
	
	// === 모든 캘린더(사내캘린더, 내캘린더, 공유받은캘린더)를 불러오는것 ===
	@ResponseBody
	@GetMapping(value="selectSchedule", produces="text/plain;charset=UTF-8")
	public String selectSchedule(HttpServletRequest request) {
		
		// 등록된 일정 가져오기
		
		String fk_member_userid = request.getParameter("fk_member_userid");
				
		List<Calendar_schedule_VO> scheduleList = service.selectSchedule(fk_member_userid);
		
		JSONArray jsArr = new JSONArray();
		
		if(scheduleList != null && scheduleList.size() > 0) {
			
			for(Calendar_schedule_VO svo : scheduleList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("schedule_subject", svo.getSchedule_subject());
				jsObj.put("schedule_startdate", svo.getSchedule_startdate());
				jsObj.put("schedule_enddate", svo.getSchedule_enddate());
				jsObj.put("schedule_color", svo.getSchedule_color());
				jsObj.put("schedule_no", svo.getSchedule_no());
				jsObj.put("fk_large_category_no", svo.getFk_large_category_no());
				jsObj.put("fk_small_category_no", svo.getFk_small_category_no());
				jsObj.put("fk_member_userid", svo.getFk_member_userid());
				jsObj.put("schedule_joinuser", svo.getSchedule_joinuser());
				
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		
		}
		
		return jsArr.toString();
	}
	
	
	
	// === 일정상세보기 ===
	@GetMapping(value="detailSchedule")
	public ModelAndView detailSchedule(ModelAndView mav, HttpServletRequest request) {
		
		String schedule_no = request.getParameter("schedule_no");
		
		// 검색하고 나서 취소 버튼 클릭했을 때 필요함
		String listgobackURL_schedule = request.getParameter("listgobackURL_schedule");
		mav.addObject("listgobackURL_schedule",listgobackURL_schedule);

		
		// 일정상세보기에서 일정수정하기로 넘어갔을 때 필요함
		String gobackURL_detailSchedule = MyUtil.getCurrentURL(request);
		mav.addObject("gobackURL_detailSchedule", gobackURL_detailSchedule);
		
		try {
			Integer.parseInt(schedule_no);
			Map<String,String> map = service.detailSchedule(schedule_no);
			mav.addObject("map", map);
			mav.setViewName("content/community/schedule/detailSchedule");
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/schedule/scheduleManagement"); // OR content/community/schedule/scheduleManagement
		}
		
		return mav;
	}
	
	
	
	// === 일정삭제하기 ===
	@ResponseBody
	@PostMapping("deleteSchedule")
	public String deleteSchedule(HttpServletRequest request) throws Throwable {
		
		String schedule_no = request.getParameter("schedule_no");
				
		int n = service.deleteSchedule(schedule_no);
		
		JSONObject jsObj = new JSONObject();
		jsObj.put("n", n);
			
		return jsObj.toString();
	}
	
	
	
	// === 일정 수정하기 ===
/*	
	@PostMapping("editSchedule")
	public ModelAndView editSchedule(ModelAndView mav, HttpServletRequest request) {
		
		String schedule_no= request.getParameter("schedule_no");
   		
		try {
			Integer.parseInt(schedule_no);
			
			String gobackURL_detailSchedule = request.getParameter("gobackURL_detailSchedule");
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			Map<String,String> map = service.detailSchedule(schedule_no);
			
			if( !loginuser.getMember_userid().equals( map.get("FK_MEMBER_USERID") ) ) {
				String message = "다른 사용자가 작성한 일정은 수정이 불가합니다.";
				String loc = "javascript:history.back()";
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				mav.setViewName("msg");
			}
			else {
				mav.addObject("map", map);
				mav.addObject("gobackURL_detailSchedule", gobackURL_detailSchedule);
				
				mav.setViewName("content/community/schedule/editSchedule");
			}
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/schedule/scheduleManagement");
		}
		
		return mav;
		
	}
*/	
	
	
	// === 일정 수정 완료하기 ===
	@PostMapping("editSchedule_end")
	public ModelAndView editSchedule_end(Calendar_schedule_VO svo, HttpServletRequest request, ModelAndView mav) {
		
		try {
			 int n = service.editSchedule_end(svo);
			 
			 if(n==1) {
				 mav.addObject("message", "일정을 수정하였습니다.");
				 mav.addObject("loc", request.getContextPath()+"/schedule/scheduleManagement");
			 }
			 else {
				 mav.addObject("message", "일정 수정에 실패하였습니다.");
				 mav.addObject("loc", "javascript:history.back()");
			 }
			 
			 mav.setViewName("msg");
		} catch (Throwable e) {	
			e.printStackTrace();
			mav.setViewName("redirect:/schedule/scheduleManagement");
		}
			
		return mav;
	}
	
	

	// === (사내캘린더 또는 내캘린더)속의  소분류 카테고리인 서브캘린더 삭제하기  === 	
	@ResponseBody
	@PostMapping("deleteSubCalendar")
	public String deleteSubCalendar(HttpServletRequest request) throws Throwable {
		
		String small_category_no = request.getParameter("small_category_no");
				
		int n = service.deleteSubCalendar(small_category_no);
		
		JSONObject jsObj = new JSONObject();
		jsObj.put("n", n);
			
		return jsObj.toString();
	}
	
	
	
	// === (사내캘린더 또는 내캘린더)속의 소분류 카테고리인 서브캘린더 수정하기 === 
	@ResponseBody
	@PostMapping("editCalendar")
	public String editComCalendar(HttpServletRequest request) throws Throwable {
		
		String small_category_no = request.getParameter("small_category_no");
		String small_category_name = request.getParameter("small_category_name");
		String member_userid = request.getParameter("member_userid");
		String caltype = request.getParameter("caltype");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("small_category_no", small_category_no);
		paraMap.put("small_category_name", small_category_name);
		paraMap.put("member_userid", member_userid);
		paraMap.put("caltype", caltype);
		
		int n = service.editCalendar(paraMap);
		
		JSONObject jsObj = new JSONObject();
		jsObj.put("n", n);
			
		return jsObj.toString();
	}
	
	
	// === 검색 기능 === //
	@GetMapping("searchSchedule")
	public ModelAndView searchSchedule(HttpServletRequest request, ModelAndView mav) { 
		
		List<Map<String,String>> scheduleList = null;
		
		String schedule_startdate = request.getParameter("schedule_startdate");
		String schedule_enddate = request.getParameter("schedule_enddate");
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String fk_member_userid = request.getParameter("fk_member_userid");  // 로그인한 사용자id
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		String str_sizePerPage = request.getParameter("sizePerPage");
	
		String fk_large_category_no = request.getParameter("fk_large_category_no");
		
		if(searchType==null || (!"schedule_subject".equals(searchType) && !"schedule_content".equals(searchType)  && !"schedule_joinuser".equals(searchType))) {  
			searchType="";
		}
		
		if(searchWord==null || "".equals(searchWord) || searchWord.trim().isEmpty()) {  
			searchWord="";
		}
		
		if(schedule_startdate==null || "".equals(schedule_startdate)) {
			schedule_startdate="";
		}
		
		if(schedule_enddate==null || "".equals(schedule_enddate)) {
			schedule_enddate="";
		}
			
		if(str_sizePerPage == null || "".equals(str_sizePerPage) || 
		   !("10".equals(str_sizePerPage) || "15".equals(str_sizePerPage) || "20".equals(str_sizePerPage))) {
				str_sizePerPage ="10";
		}
		
		if(fk_large_category_no == null ) {
			fk_large_category_no="";
		}
		
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("schedule_startdate", schedule_startdate);
		paraMap.put("schedule_enddate", schedule_enddate);
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("fk_member_userid", fk_member_userid);
		paraMap.put("str_sizePerPage", str_sizePerPage);

		paraMap.put("fk_large_category_no", fk_large_category_no);
		
		int totalCount=0;          // 총 게시물 건수		
		int currentShowPageNo=0;   // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함.
		int totalPage=0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)  
		int sizePerPage = Integer.parseInt(str_sizePerPage);  // 한 페이지당 보여줄 행의 개수
		int startRno=0;            // 시작 행번호
	    int endRno=0;              // 끝 행번호 
	    
	    // 총 일정 검색 건수(totalCount)
	    totalCount = service.getTotalCount(paraMap);
	//  System.out.println("~~~ 확인용 총 일정 검색 건수 totalCount : " + totalCount);
      
	    totalPage = (int)Math.ceil((double)totalCount/sizePerPage); 

		if(str_currentShowPageNo == null) {
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					currentShowPageNo = 1;
				}
			} catch (NumberFormatException e) {
				currentShowPageNo=1;
			}
		}
		
		startRno = ((currentShowPageNo - 1 ) * sizePerPage) + 1;
	    endRno = startRno + sizePerPage - 1;
	      
	    paraMap.put("startRno", String.valueOf(startRno));
	    paraMap.put("endRno", String.valueOf(endRno));
	    	   
	    scheduleList = service.scheduleListSearchWithPaging(paraMap);
	    // 페이징 처리한 캘린더 가져오기(검색어가 없다라도 날짜범위 검색은 항시 포함된 것임)
		
		mav.addObject("paraMap", paraMap);
		// 검색대상 컬럼과 검색어를 유지시키기 위한 것임.
		
		// === 페이지바 만들기 === //
		int blockSize= 5;
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	   
		String pageBar = "<ul style='list-style:none;'>";
		
		String url = "searchSchedule";
		
		// === [맨처음][이전] 만들기 ===
		if(pageNo!=1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?schedule_startdate="+schedule_startdate+"&schedule_enddate="+schedule_enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_member_userid="+fk_member_userid+"&fk_large_category_no="+fk_large_category_no+"&sizePerPage="+sizePerPage+"&currentShowPageNo=1'>[맨처음]</a></li>";
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?schedule_startdate="+schedule_startdate+"&schedule_enddate="+schedule_enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_member_userid="+fk_member_userid+"&fk_large_category_no="+fk_large_category_no+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
		}
		while(!(loop>blockSize || pageNo>totalPage)) {
			
			if(pageNo==currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?schedule_startdate="+schedule_startdate+"&schedule_enddate="+schedule_enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_member_userid="+fk_member_userid+"&fk_large_category_no="+fk_large_category_no+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
			}
			
			loop++;
			pageNo++;
		}// end of while--------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?schedule_startdate="+schedule_startdate+"&schedule_enddate="+schedule_enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_member_userid="+fk_member_userid+"&fk_large_category_no="+fk_large_category_no+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?schedule_startdate="+schedule_startdate+"&schedule_enddate="+schedule_enddate+"&searchType="+searchType+"&searchWord="+searchWord+"&fk_member_userid="+fk_member_userid+"&fk_large_category_no="+fk_large_category_no+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
		}
		pageBar += "</ul>";
		
		mav.addObject("pageBar",pageBar);
		
		String listgobackURL_schedule = MyUtil.getCurrentURL(request);
	//	System.out.println("~~~ 확인용 검색 listgobackURL_schedule : " + listgobackURL_schedule);
		
		mav.addObject("listgobackURL_schedule",listgobackURL_schedule);
		mav.addObject("scheduleList", scheduleList);
		mav.setViewName("content/schedule/searchSchedule");

		return mav;
	}

	
}
