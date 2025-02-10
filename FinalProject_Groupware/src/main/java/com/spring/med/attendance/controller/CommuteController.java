package com.spring.med.attendance.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/*")
public class CommuteController {


	@GetMapping("commute")
	public String index(HttpServletRequest request) {
	
		return "content/attendance/commute";
		// /WEB-INF/views/mycontent1/main/index.jsp 페이지를 만들어야 한다.
	}
	
}
