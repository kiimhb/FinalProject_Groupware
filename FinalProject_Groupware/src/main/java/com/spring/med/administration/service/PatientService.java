package com.spring.med.administration.service;

import java.util.List;
import java.util.Map;

import com.spring.med.patient.domain.PatientVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

public interface PatientService {

	//진료기록이 있는 총 환자수 (totalCount)
	int getTotalCount(Map<String, String> paraMap);

	// 진료기록이 있는 환자 목록 
	List<Map<String, String>> patientList(Map<String, String> paraMap);

	// 환자 주민번호 가져오기
	String getJubun(String seq);
	
	// 선택한 환자의 차트 조회하기
	Map<String, String> detail_patient(String seq);

	// 개인별 환자 진료목록
	List<Map<String, String>> order_list(String jubun);

	// 개인별 환자 수술기록
	List<Map<String, Object>> surgery_list(String seq);

	// 수술실 목록 불러오기
	List<SurgeryroomVO> getSurgeryRoom();



}
