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
	
	//사원등록 폼태그
	int manag_form(ManagementVO_ga managementVO_ga, Map<String, String> paraMap);

	//로그인
	ModelAndView login(ModelAndView mav, HttpServletRequest request, Map<String, String> paraMap);

	//로그아웃
	ModelAndView logout(ModelAndView mav, HttpServletRequest request);

	// 총 사원수 구하기 --> 검색이 있을 때와 검색이 없을때 로 나뉜다.
	int getTotalCount(Map<String, String> paraMap);
	
	//사원정보 전체조회
	List<ManagementVO_ga> Manag_List(Map<String, String> paraMap);

	// 검색어 입력시 자동글 완성하기
	List<String> wordSearchShow(Map<String, String> paraMap);

	//인사관리 사원수정 한명의 멤버 조회
	ManagementVO_ga getView_member_one(Map<String, String> paraMap);

	//인사관리 사원퇴사 처리
	int managementone_delete(String member_userid);

	//인사관리 사원수정 처리
	int Managementone_update(ManagementVO_ga managementVO_ga);



	

	



}
