package com.spring.med.index.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.spring.med.index.service.IndexService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value = "/*")
public class IndexController {

	@Autowired
	private IndexService service;

	// === 메인 페이지 요청 === //
	@GetMapping("/") // http://localhost:9090/myspring/
	public String main() {
		return "redirect:/index"; // http://localhost:9090/myspring/index
	}

	@GetMapping("index")
	public String index(HttpServletRequest request) {

		// List<Map<String, String>> mapList = service.getImgfilenameList();

		// request.setAttribute("mapList", mapList);

		return "content/main/index";
		// /WEB-INF/views/mycontent1/main/index.jsp 페이지를 만들어야 한다.
	}
}
