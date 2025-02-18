package com.spring.med.administration.model;

import java.util.List;
import java.util.Map;

import com.spring.med.surgery.domain.SurgeryVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

public interface RegisterDAO {

	// 수술 대기자 목록 개수
	int register_list_cnt();
	
	// 수술 대기자 목록 조회하기 
	List<Map<String, String>> register_list(Map<String, String> paraMap);

	// 환자명 알아오기
	String getPatientName(String order_no);

	// 수술실 목록 알아오기
	List<SurgeryroomVO> getSurgeryRoom();

	// 예약된 시간 가져오기
	List<String> reservedTime(Map<String, String> paraMap);

}
