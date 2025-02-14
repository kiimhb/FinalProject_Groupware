package com.spring.med.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value="/community/*")
public class BookmarkController {
	
	@GetMapping("bookmark")
	public ModelAndView bookmark(ModelAndView mav) {


		mav.setViewName("content/community/bookmark"); 
		// /WEB-INF/views/content/community/bookmark.jsp 파일을 생성한다.

		return mav;
	}
}






