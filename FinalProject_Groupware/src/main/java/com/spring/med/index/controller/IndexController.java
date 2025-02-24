package com.spring.med.index.controller;

import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.MyUtil;
import com.spring.med.schedule.domain.Calendar_schedule_VO;
import com.spring.med.schedule.service.ScheduleService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/*")
public class IndexController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	
	// === 메인 페이지 요청 === //
	@GetMapping("/")	// http://localhost:9090/myspring/
	public String main() {
		return "redirect:/index";	// http://localhost:9090/myspring/index
	}

	@GetMapping("index")
	public String index(HttpServletRequest request) {
		
		//List<Map<String, String>> mapList = service.getImgfilenameList();
		
		//request.setAttribute("mapList", mapList);
		
		return "content/main/index";
		// /WEB-INF/views/mycontent1/main/index.jsp 페이지를 만들어야 한다.
	}
	
	
	@ResponseBody
	@GetMapping(value="selectSchedule")
	public String selectSchedule(HttpServletRequest request) {
		
		// 등록된 일정 가져오기
		
		String fk_member_userid = request.getParameter("fk_member_userid");
				
		List<Calendar_schedule_VO> scheduleList = scheduleService.selectSchedule(fk_member_userid);
		
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
			Map<String,String> map = scheduleService.detailSchedule(schedule_no);
			mav.addObject("map", map);
			mav.setViewName("content/schedule/detailSchedule");
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/schedule/scheduleManagement"); 
		}
		
		return mav;
	}
	
}
