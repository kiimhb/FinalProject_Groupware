package com.spring.med.administration.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/pay/*")
public class PayController {
	
	
	// 수납대기조회
	@GetMapping("wait")
	public ModelAndView pay_wait(HttpServletRequest request, ModelAndView mav) {
		mav.setViewName("content/administration/pay");
		return mav;
	}
	
	// 수납완료조회
	@GetMapping("finish")
	public ModelAndView pay_finish(HttpServletRequest request, ModelAndView mav) {
		mav.setViewName("content/administration/pay");
		return mav;
	}
	
}
