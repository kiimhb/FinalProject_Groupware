package com.spring.med.management.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.Sha256;
import com.spring.med.common.AES256;
import com.spring.med.management.domain.Child_deptVO;
import com.spring.med.management.domain.ManagementVO;
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
	public List<Child_deptVO> childDeptJSON(Map<String, Object> paraMap) {
		List<Child_deptVO> childDeptJSON = manaDAO.childDeptJSON(paraMap);
		return childDeptJSON;
	}

	// ==== 로그인 처리 ==== //
	@Override
	public ModelAndView login(ModelAndView mav, HttpServletRequest request, Map<String, String> paraMap) {
		
		paraMap.put("pwd", Sha256.encrypt(paraMap.get("pwd"))); // 비밀번호를 암호화 시키기 
		
		ManagementVO loginuser = manaDAO.getLoginMember(paraMap);
		
		if(loginuser != null) {
				try {
					String email = aes.decrypt(loginuser.getEmail());   // 이메일 복호화
					String mobile = aes.decrypt(loginuser.getMobile()); // 휴대폰 복호화
					
					loginuser.setEmail(email);
					loginuser.setMobile(mobile);
					
				} catch (UnsupportedEncodingException | GeneralSecurityException e) {
					e.printStackTrace();
				} 
		} // end of if(loginuser != null)--------------
		
		
		if(loginuser == null) { // 로그인 실패시
        	String message = "아이디 또는 암호가 틀립니다.";
        	String loc = "javascript:history.back()";
        	
        	mav.addObject("message", message);
        	mav.addObject("loc", loc);
        	
        	mav.setViewName("msg");
        	//  /WEB-INF/views/msg.jsp  파일을 생성한다.
        }
        else { // 아이디와 암호가 존재하는 경우 
        		
        			String goBackURL = (String) session.getAttribute("goBackURL"); 
        			
        			if(goBackURL != null) {
        				mav.setViewName("redirect:"+goBackURL);
        				session.removeAttribute("goBackURL"); // 세션에서 반드시 제거해주어야 한다. 
        			}
        			else {
        				mav.setViewName("redirect:/index"); // 시작페이지로 이동 
        			}
        }
		
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
