package com.spring.med.administration.model;

import java.util.List;
import java.util.Map;

import com.spring.med.administration.domain.Calendar_hospitalize_recordVO;
import com.spring.med.administration.domain.Calendar_surgery_recordVO;
import com.spring.med.hospitalize.domain.HospitalizeVO;
import com.spring.med.hospitalize.domain.HospitalizeroomVO;
import com.spring.med.surgery.domain.SurgeryVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

public interface RegisterDAO {

	// ********** 수술  예약  관리 **********// 
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

	// 동일한 날 한개이상의 수술을 막기 위해 주민번호 알아오기 
	String getJubun(SurgeryVO surgeryvo);
	
	// 1. 동일한 환자가 같은 날 다른 수술이 있는지 확인하기 (수술은 하루에 한개만 가능)
	int todayOtherSurgery(Map<String, String> paraMap);
	
	// 2. 비관적락 사용해서 예약된 시간인지 확인하기 (수술)
	SurgeryVO existingSurgery(Map<String, String> paraMap);

	// 3. 예약 처리해주기
	void insertSurgery(SurgeryVO surgeryvo);

	// 수술 예약일정 수정하기
	void surgeryUpdate(Map<String, String> paraMap);

	
	// ********** 입원 예약  관리 **********// 
	// 입원 대기자 목록 총 개수
	int hospitalize_list_cnt();

	// 입원 대기자 목록
	List<Map<String, String>> hospitalize_list(Map<String, String> paraMap2);

	// 입원일수 알아오기
	String order_howlonghosp(String order_no);

	// 입원실 잔여석 가져오기
	List<Map<String, String>> okSeat(Map<String, String> paraMap);

	// 중복 입원 확인을 위해 주민번호 알아오기
	String jubunGet(HospitalizeVO hospitalizevo);
	
	// 1. 동일한 입원일/퇴원일에 다른 입원건이 있는지 확인
	int todayOtherHospitalize(Map<String, String> paraMap);

	// 2. 비관적락 사용해서 예약된 시간인지 확인하기(입원)
	HospitalizeVO existingHospitalize(Map<String, String> paraMap);
	
	// 3. 입원예약하기
	void hospitalizeRegister(HospitalizeVO hospitalizevo);

	// 입원 수정하기 
	void hospitalizeUpdate(Map<String, String> paraMap);

	// 입원실 현황 캘린더조회
	List<Calendar_hospitalize_recordVO> hospitalizeScheduleList();

	// 수술현황 캘린더조회
	List<Calendar_surgery_recordVO> surgerySchedule();

}
