package com.spring.med.management.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.management.domain.Child_deptVO;
import com.spring.med.management.domain.ManagementVO;
import com.spring.med.management.domain.Parent_deptVO;
import com.spring.med.management.service.ManagementService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/management/*")
public class ManagementController {
	
	@Autowired
	private ManagementService managService;
	
	
	
	// === 사원등록 폼 페이지 요청 시작 === //
	@GetMapping("ManagementFrom")
	public String ManagementFrom_get(HttpServletRequest request) {
		
		//상위부서 테이블 가져오기
		List<Parent_deptVO> parentDeptList = managService.parentDeptList();
		
		//상위부서 테이블 가져오기
		List<Child_deptVO> childDeptList = managService.childDeptList();
		
		request.setAttribute("parentDeptList", parentDeptList);
		request.setAttribute("childDeptList", childDeptList);
	
		return "content/management/ManagementFrom";
	}
	
	
	@PostMapping("ManagementFrom")
	public ModelAndView ManagementFrom_post(Map<String, String> paraMap,  ModelAndView mav, ManagementVO managementVO,  MultipartHttpServletRequest mrequest) {
		return mav;
	}
	// === 사원등록 폼 페이지 요청 끝 === //
	
	
	// === 메인페이지 이전 로그인 폼 페이지 요청 시작 === //
	@GetMapping("login")
	public ModelAndView login(ModelAndView mav) {
		mav.setViewName("content/management/login");
		
		return mav;
	}
	
	@PostMapping("login")
	public ModelAndView login(ModelAndView mav, 
                              HttpServletRequest request,
                              @RequestParam Map<String, String> paraMap) {
		
		// === 클라이언트의 IP 주소를 알아오는 것 === //
		// /myspring/src/main/webapp/JSP 파일을 실행시켰을 때 IP 주소가 제대로 출력되기위한 방법.txt 참조할 것!!!
		String clientip = request.getRemoteAddr();
		paraMap.put("clientip", clientip);
		
		mav = managService.login(mav, request, paraMap);
		
		return mav;
	}
	
	@GetMapping("logout")
	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {
		
		mav = managService.logout(mav, request);
		return mav;
	}
	// === 메인페이지 이전 로그인 폼 페이지 요청 끝 === //
	

	
	
	// === 사원목록 페이지 조회 요청 시작 === //
	@GetMapping("ManagementList")
	public String ManagementList(HttpServletRequest request) {
	
		return "content/management/ManagementList";
	}
	// === 사원목록 페이지 조회 요청 끝 === //

}
