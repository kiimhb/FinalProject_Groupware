package com.spring.med.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.MyUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/board/*")
public class BoardController {

	@GetMapping("list")
	public ModelAndView list(ModelAndView mav) {


		mav.setViewName("content/community/board/list"); 
		// /WEB-INF/views/content/community/board/list.jsp 파일을 생성한다.

		return mav;
	}
}


