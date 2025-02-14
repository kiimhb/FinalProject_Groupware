package com.spring.med.management.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.Sha256;
import com.spring.med.common.AES256;
import com.spring.med.management.domain.Child_deptVO_ga;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.management.domain.Parent_deptVO_ga;
import com.spring.med.management.model.ManagementDAO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

//=== 서비스 선언 ===//
@Service
public class ManagementService_imple implements ManagementService {
	
	@Autowired
	private ManagementDAO manaDAO;
	
	private AES256 aes;
	

	//상위부서 테이블 가져오기
	@Override
	public List<Parent_deptVO_ga> parentDeptList() {
		List<Parent_deptVO_ga> parentDeptList = manaDAO.parentDeptList();
		return parentDeptList;
	}


	//하위부서 테이블 가져오기
	@Override
	public List<Child_deptVO_ga> childDeptJSON(Map<String, Object> paraMap) {
		List<Child_deptVO_ga> childDeptJSON = manaDAO.childDeptJSON(paraMap);
		return childDeptJSON;
	}
	
	//사원등록 폼태그
	@Override
	public int manag_form(ManagementVO_ga managementVO_ga) {
		int n = manaDAO.manag_form(managementVO_ga); 
		return n;
	}


	// ==== 로그인 처리 ==== //
	@Override
	public ModelAndView login(ModelAndView mav, HttpServletRequest request, Map<String, String> paraMap) {
		
		return mav;
	}

	
	// ==== 로그아웃 처리 ==== //
	@Override
	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.invalidate();
		
		String message = "로그아웃 되었습니다.";
		String loc = request.getContextPath()+"/login";
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	}



	



	
}
