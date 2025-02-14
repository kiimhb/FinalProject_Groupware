package com.spring.med.notice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/notice/*")
public class NoticeController {

	@GetMapping("list")
	public ModelAndView notice(HttpServletRequest request, ModelAndView mav) {
	
		mav.setViewName("content/notice/notice");
		return mav;
	}

}