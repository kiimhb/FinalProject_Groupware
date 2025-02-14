package com.spring.med.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value="/community/*")
public class MyboardController {
	
	@GetMapping("myboard")
	public ModelAndView myboard(ModelAndView mav) {


		mav.setViewName("content/community/myboard"); 
		// /WEB-INF/views/content/community/myboard.jsp 파일을 생성한다.

		return mav;
	}
}


