package com.spring.med.administration.model;

import java.util.List;
import java.util.Map;

import com.spring.med.patient.domain.PatientVO;

public interface PatientDAO {

	//진료기록이 있는 총 환자수 (totalCount)
	int getTotalCount(Map<String, String> paraMap);

	// 진료기록이 있는 환자 목록 
	List<Map<String, String>> patientList(Map<String, String> paraMap);

	// 환자 주민번호 가져오기
	String getJubun(String seq);
	
	// 선택한 환자의 차트 조회하기
	Map<String, String>  detail_patient(String seq);

	// 개인별 환자 진료목록
	List<Map<String, String>> order_list(String jubun);
	
}
