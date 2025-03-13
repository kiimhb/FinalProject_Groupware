package com.spring.med.administration.model;

import java.util.List;
import java.util.Map;

import com.spring.med.patient.domain.PrescribeVO;

public interface PayDAO {

	// 수납상태와 검색어에 따른 총 수납개수
	int getTotalCount(Map<String, String> paraMap);

	// 수납대기 또는 수납 완료 목록 
	List<Map<String, String>> pay_list(Map<String, String> paraMap);

	// 수납처리하기
	void pay_success(String order_no);

	// 환자정보 불러오기
	Map<String, String> pay_patientInfo(String order_no);

	// 처방약 정보 불러오기
	List<PrescribeVO> prescribe_list(String order_no);

}
