package com.spring.med.attendance.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;

import com.spring.med.attendance.service.AttendanceCommuteService;
import com.spring.med.management.domain.ManagementVO_ga;


@Controller
@RequestMapping(value="/attendance/*")
public class AttendanceController {
	
	@Autowired
	private AttendanceCommuteService service;

//	근태관리 - 근태현황 조회
	@GetMapping("commute")
	public String commute(HttpServletRequest request) {
	
		return "content/attendance/commute";
	}
	
	@GetMapping("commute_count")
	public ModelAndView commute_count(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String member_userid = loginuser.getMember_userid();
		
		List<Map<String, String>> commute_count = service.get_commute_count(member_userid);
		
		mav.addObject("commute_count", commute_count);
		System.out.println(commute_count);
		
		return mav;
	}
	

}
