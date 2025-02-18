package com.spring.med.patient.service;

import java.util.List;
import java.util.Map;

import com.spring.med.patient.domain.TreatPatientVO;

public interface TreatPatientService {
	
	// 진료 - 진료대기환자 에서 진료대기환자 리스트 보여주기
	List<Map<String, String>> selectPatientWaiting(Map<String, String> paraMap);

	// 진료 - 진료대기환자 에서 총 진료환자수 알아오기
	int getTotalCount(Map<String, String> paraMap);

	// 검색어 입력시 자동글 완성하기
	List<String> wordSearchShow(Map<String, String> paraMap);

	// === 진료- 기존환자 조회에서 검색된 주민번호로 환자 정보 보여주기
	List<TreatPatientVO> existPatientShow(Map<String, String> paraMap);


}
