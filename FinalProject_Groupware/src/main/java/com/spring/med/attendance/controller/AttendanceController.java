package com.spring.med.attendance.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/attendance/*")
public class AttendanceController {


	@GetMapping("commute")
	public String commute(HttpServletRequest request) {
	
		return "content/attendance/commute";
	}

}
