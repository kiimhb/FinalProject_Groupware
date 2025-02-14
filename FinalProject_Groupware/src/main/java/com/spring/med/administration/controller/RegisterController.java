package com.spring.med.administration.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/register/*")
public class RegisterController {
	
	
	// 환자조회 
	@GetMapping("list")
	public ModelAndView register_list(HttpServletRequest request, ModelAndView mav) {
		mav.setViewName("content/administration/register");
		return mav;
	}
	
	@GetMapping("surgery")
	public ModelAndView surgery_form(HttpServletRequest request, ModelAndView mav) {
		mav.setViewName("content/administration/surgeryRegister");
		return mav;
	}
	
	@GetMapping("hospitalization")
	public ModelAndView hospitalization_form(HttpServletRequest request, ModelAndView mav) {
		mav.setViewName("content/administration/hospitalRegister");
		return mav;
	}
	
}
