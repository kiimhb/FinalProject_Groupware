package com.spring.med.management.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.AES256;
import com.spring.med.management.domain.Child_deptVO;
import com.spring.med.management.domain.Parent_deptVO;
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
	public List<Parent_deptVO> parentDeptList() {
		List<Parent_deptVO> parentDeptList = manaDAO.parentDeptList();
		return parentDeptList;
	}


	//하위부서 테이블 가져오기
	@Override
	public List<Child_deptVO> childDeptList() {
		List<Child_deptVO> childDeptList = manaDAO.childDeptList();
		return childDeptList;
	}

	// ==== 로그인 처리 ==== //
	@Override
	public ModelAndView login(ModelAndView mav, HttpServletRequest request, Map<String, String> paraMap) {
	
		return null;
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
