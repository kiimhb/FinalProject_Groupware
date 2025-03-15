package com.spring.med.attendance.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;

import com.spring.med.attendance.service.AttendanceCommuteService;
import com.spring.med.common.MyUtil;
import com.spring.med.management.domain.ManagementVO_ga;


@Controller
@RequestMapping(value="/attendance/*")
public class AttendanceController {
	
	@Autowired
	private AttendanceCommuteService service;
	
//	근태관리 - 근태현황 조회
	@GetMapping("commute")
	public ModelAndView commute_count(HttpServletRequest request, HttpServletResponse response, ModelAndView mav,
									  @RequestParam(defaultValue = "") String searchType, 		
									  @RequestParam(defaultValue = "") String searchWord,
									  @RequestParam(defaultValue = "1") String currentShowPageNo  ) {
		
	    HttpSession session = request.getSession();
	    ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

	    String member_userid = loginuser.getMember_userid();
	    
	    List<Map<String, String>> commute_count = service.get_commute_count(member_userid);
	    //System.out.println(commute_count);
	    mav.addObject("commute_count", commute_count);
	    
	    
	    List<Map<String, String>> work_count = null;
	    
	    Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("member_userid", member_userid);
	    
	    int totalCount = 0;  			
		int sizePerPage = 10; 		 
		int totalPage = 0;
		
		int n_currentShowPageNo = 0;
		
		totalCount = service.getTotalCount(paraMap);
		//System.out.println("~~~ 확인용 totalCount : " + totalCount);
		
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
		
		try {
			  n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
		
			  if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				  
				  n_currentShowPageNo = 1;
			  }
			  
		} catch(NumberFormatException e) {
			n_currentShowPageNo = 1;
		}
		
		 int startRno = ((n_currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		 int endRno = startRno + sizePerPage - 1; // 끝 행번호 
		 
		 paraMap.put("startRno", String.valueOf(startRno)); 
		 paraMap.put("endRno", String.valueOf(endRno));    
		 
		 paraMap.put("currentShowPageNo", currentShowPageNo);
	    
	    work_count = service.get_work_count(paraMap);
	    
	    mav.addObject("work_count", work_count);
	    
	    int blockSize = 10;
	    
		 int loop = 1;
		 
		 int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
			  
		 String pageBar = "<ul style='list-style:none;'>";
		 String url = "work_count";
			
			// === [맨처음][이전] 만들기 === //
			pageBar += "<li style='display:inline-block; width:70px; font-size:13pt;  '><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1' style='color:#006769; font-weight: bold;'> << </a></li>";
			
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:13pt; '><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"' style='color:#006769; font-weight: bold;'> [이전] </a></li>"; 
			}
			
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == Integer.parseInt(currentShowPageNo)) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:13pt; border:solid 1px gray; color:red; padding:2px 4px;' >"+pageNo+"</li>"; 
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:13pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'  style='color:#006769; font-weight: bold;' >"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:13pt;  color:#006769;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color:#006769; font-weight: bold;'> [다음] </a></li>"; 	
			}
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:13pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color:#006769; font-weight: bold;'> >> </a></li>";
						
			pageBar += "</ul>";	
			
			mav.addObject("pageBar", pageBar);
		
			mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			String currentURL = MyUtil.getCurrentURL(request);
		//	System.out.println("~~~ 확인용 currentURL : " + currentURL);

			mav.addObject("goBackURL", currentURL);
	    
	    mav.setViewName("content/attendance/commute");

	    return mav;
	}
	
	
	@GetMapping("myLeave")
	public ModelAndView myLeave(HttpServletRequest request, HttpServletResponse response,ModelAndView mav) {
		
		 mav.setViewName("content/attendance/myLeave");
		 
		 return mav;
	}


	

}
