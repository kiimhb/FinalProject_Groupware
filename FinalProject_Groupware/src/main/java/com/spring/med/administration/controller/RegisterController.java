package com.spring.med.administration.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/*")
public class RegisterController {
	
	
	// 환자조회 
	@GetMapping("register")
	public String index(HttpServletRequest request) {
		
		return "content/administration/register";
	}
	
}
