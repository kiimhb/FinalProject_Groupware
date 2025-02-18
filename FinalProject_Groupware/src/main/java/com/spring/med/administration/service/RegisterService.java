package com.spring.med.administration.service;

import java.util.List;
import java.util.Map;

import com.spring.med.surgery.domain.SurgeryVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

public interface RegisterService {

	// 수술 대기자 목록 총 개수
	int getTotalCount();
	
	// 수술 대기자 목록 조회하기
	List<Map<String, String>> register_list(Map<String, String> paraMap);

	// 환자명 알아오기
	String getPatientName(String order_no);

	// 수술실 목록 알아오기
	List<SurgeryroomVO> getSurgeryRoom();

	// 수술 가능한 시간 찾기
	List<String> oktime(Map<String, String> paraMap);
}
