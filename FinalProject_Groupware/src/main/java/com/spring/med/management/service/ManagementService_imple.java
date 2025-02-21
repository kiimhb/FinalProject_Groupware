package com.spring.med.management.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.Sha256;
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
	public int manag_form(ManagementVO_ga managementVO_ga, Map<String, String> paraMap) {
	
		 String member_pwd = Sha256.encrypt(String.valueOf(paraMap.get("randomidAndPwd")));
		 String member_start = String.valueOf(paraMap.get("member_start"));
		 
		  managementVO_ga.setMember_pwd(member_pwd);
		  paraMap.put("randomidAndPwd", member_pwd);
		  paraMap.put("member_start", member_start);
		  
		  int n = manaDAO.manag_form(managementVO_ga); 
		
		return n;
	}


	// ==== 로그인 처리 ==== //
	@Override
	public ModelAndView login(ModelAndView mav, HttpServletRequest request, Map<String, String> paraMap) {
		
		paraMap.put("member_pwd", Sha256.encrypt(paraMap.get("member_pwd"))); // 비밀번호를 암호화 시키기 
		
		ManagementVO_ga loginuser = manaDAO.getLoginMember(paraMap);
		
		if(loginuser == null) { // 로그인 실패시
        	String message = "아이디 또는 암호가 틀립니다.";
        	String loc = "javascript:history.back()";
        	
        	mav.addObject("message", message);
        	mav.addObject("loc", loc);
        	
        	mav.setViewName("msg");
        	//  /WEB-INF/views/msg.jsp  파일을 생성한다.
        }
		else { // 암호를 마지막으로 변경한 것이 3개월 이내인 경우
			
			HttpSession session = request.getSession();
    		// 메모리에 생성되어져 있는 session 을 불러온다.
    		
    		session.setAttribute("loginuser", loginuser);

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
		String loc = request.getContextPath()+"/management/login";
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	}

	// ==== 사원 전체조회 ==== //
	@Override
	public List<ManagementVO_ga> Manag_List(Map<String, String> paraMap) {
		List<ManagementVO_ga> Manag_List = manaDAO.Manag_List(paraMap);
		return Manag_List;
	}

	// 총 사원수 구하기 --> 검색이 있을 때와 검색이 없을때 로 나뉜다.
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = manaDAO.getTotalCount(paraMap);
		return totalCount;
	}

	// 검색어 입력시 자동글 완성하기
	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = manaDAO.wordSearchShow(paraMap);
		return wordList;
	}



	// === 인사관리 회원수정 한명의 멤버 조회 === //
	@Override
	public ManagementVO_ga getView_member_one(Map<String, String> paraMap) {
	
		ManagementVO_ga member_one = manaDAO.getView_member_one(paraMap);
		return member_one;
	}


	





	



	
}
