package com.spring.med.management.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import com.spring.med.management.domain.Child_deptVO_ga;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.management.domain.Parent_deptVO_ga;

import jakarta.servlet.http.HttpServletRequest;

public interface ManagementService {

	//상위부서 테이블 가져오기
	List<Parent_deptVO_ga> parentDeptList();
	
	//하위부서 테이블 가져오기
	List<Child_deptVO_ga> childDeptJSON(Map<String, Object> paraMap);

	//로그인
	ModelAndView login(ModelAndView mav, HttpServletRequest request, Map<String, String> paraMap);

	//로그아웃
	ModelAndView logout(ModelAndView mav, HttpServletRequest request);

	int manag_form(ManagementVO_ga managementVO_ga);



}
