package com.spring.med.administration.service;

import java.util.List;
import java.util.Map;

import com.spring.med.hospitalize.domain.HospitalizeVO;
import com.spring.med.hospitalize.domain.HospitalizeroomVO;
import com.spring.med.surgery.domain.SurgeryVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

public interface RegisterService {

	// ********** 수술  예약  관리 **********// 
	// 수술 대기자 목록 총 개수
	int getTotalCount();
	
	// 수술 대기자 목록 조회하기
	List<Map<String, String>> register_list(Map<String, String> paraMap);

	// 환자명 알아오기
	String getPatientName(String order_no);

	// 수술설명불러오기
	String surgery_description(String order_no);
			
	// 수술실 목록 알아오기
	List<SurgeryroomVO> getSurgeryRoom();
	
	// 수술 가능한 시간 찾기
	List<String> oktime(Map<String, Object> paraMap);
	
	// 수술예약이 있는 시간 찾기
	List<Map<String, String>> reservedTime(Map<String, Object> paraMap);
	
	// 수술 예약하기 - 동시성처리
	void surgeryRegister(SurgeryVO surgeryvo, String jubun);

	// 수술예약 수정하기
	void surgeryUpdate(Map<String, String> paraMap);

	// 주민번호 알아오기 
	String getJubun(SurgeryVO surgeryvo);
	
	
	// ********** 입원 예약  관리 **********// 
	// 입원 대기자 목록 총 개수
	int getTotalCount2();

	// 입원 대기자 목록
	List<Map<String, String>> hospitalize_list(Map<String, String> paraMap2);

	// 입원일수 알아오기
	String order_howlonghosp(String order_no);
	
	// 입원실 잔여석 가져오기
	List<Map<String, String>> okSeat(Map<String, String> paraMap);

	// 중복 입원 확인을 위해 주민번호 알아오기
	String jubunGet(HospitalizeVO hospitalizevo);

	// 2. 입원예약하기 - 동시성 처리 
	void hospitalizeRegister(HospitalizeVO hospitalizevo, String jubun);

	// 입원 예약 수정하기 
	void hospitalizeUpdate(Map<String, String> paraMap);






	
}
