package com.spring.med.management.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/management/*")
public class ManagementController {
	
	@GetMapping("ManagementFrom")
	public String ManagementFrom(HttpServletRequest request) {
	
		return "content/management/ManagementFrom";
	}
	
	@GetMapping("ManagementList")
	public String ManagementList(HttpServletRequest request) {
	
		return "content/management/ManagementList";
	}


}
