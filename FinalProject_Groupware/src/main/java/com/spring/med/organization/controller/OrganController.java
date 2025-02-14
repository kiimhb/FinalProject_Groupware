package com.spring.med.organization.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

//**** 조직도 컨트롤러 **** //

@Controller
@RequestMapping(value="/organization/*")
public class OrganController {
	
	
	// ==== 조직도 페이지 요청 ==== //
	@GetMapping("orgChart")
	public ModelAndView writeDraftForm(ModelAndView mav) {
		mav.setViewName("/content/organization/orgChart");
		
		return mav;
	}
	
	
	// ==== 조직도 상위 부서 불러오기 ==== //
	@GetMapping("parentDept")
	@ResponseBody
	public String parentDept() {
		
		//List<Organ> orgList 
		
		
		return "";
	}
	
}
