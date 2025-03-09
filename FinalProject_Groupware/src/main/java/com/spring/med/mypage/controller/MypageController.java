package com.spring.med.mypage.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/mypage/*")
public class MypageController {
	
	// === 마이페이지 페이지 요청 시작 === //
	@GetMapping("mypage")
	public String mypage(HttpServletRequest request) {
		
		return "content/mypage/mypage";
	}

}
