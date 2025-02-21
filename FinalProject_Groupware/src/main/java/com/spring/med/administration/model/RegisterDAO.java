package com.spring.med.administration.model;

import java.util.List;
import java.util.Map;

import com.spring.med.hospitalize.domain.HospitalizeVO;
import com.spring.med.hospitalize.domain.HospitalizeroomVO;
import com.spring.med.surgery.domain.SurgeryVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

public interface RegisterDAO {

	// 수술 대기자 목록 개수
	int register_list_cnt();
	
	// 수술 대기자 목록 조회하기 
	List<Map<String, String>> register_list(Map<String, String> paraMap);

	// 환자명 알아오기
	String getPatientName(String order_no);
	
	// 수술설명 불러오기
	String surgery_description(String order_no);

	// 수술실 목록 알아오기
	List<SurgeryroomVO> getSurgeryRoom();

	// 예약된 시간 가져오기
	List<Map<String, String>> reservedTime(Map<String, Object> paraMap);

	// 비관적락 사용해서 예약된 시간인지 확인하기
	SurgeryVO existingSurgery(Map<String, String> paraMap);

	// 예약 처리해주기
	void insertSurgery(SurgeryVO surgeryvo);

	// 수술 예약일정 수정하기
	int surgeryUpdate(Map<String, String> paraMap);

	
	// 입원 대기자 목록 총 개수
	int hospitalize_list_cnt();

	// 입원 대기자 목록
	List<Map<String, String>> hospitalize_list(Map<String, String> paraMap2);

	// 입원일수 알아오기
	String order_howlonghosp(String order_no);

	// 입원실 목록가져오기 4인실
	List<HospitalizeroomVO> hospitalizeroom();

	// 입원실 목록가져오기 2인실
	List<HospitalizeroomVO> hospitalizeroom_2();

	// 입원예약하기
	void hospitalizeRegister(HospitalizeVO hospitalizevo);

	// 입원실 잔여석 가져오기
	List<Map<String, String>> okSeat();


}
