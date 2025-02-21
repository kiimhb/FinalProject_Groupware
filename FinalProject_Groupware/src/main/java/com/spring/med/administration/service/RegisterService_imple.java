package com.spring.med.administration.service;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.med.administration.model.RegisterDAO;
import com.spring.med.hospitalize.domain.HospitalizeVO;
import com.spring.med.hospitalize.domain.HospitalizeroomVO;
import com.spring.med.surgery.domain.SurgeryVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

@Service
public class RegisterService_imple  implements RegisterService {

	@Autowired 
	private RegisterDAO dao;
	
	// 수술 대기자 목록 개수
	@Override
	public int getTotalCount() {
		int n = dao.register_list_cnt();
		return n;
	}
	
	// 수술 대기자 목록 조회하기 
	@Override
	public List<Map<String, String>> register_list(Map<String, String> paraMap) {
		List<Map<String, String>> register_list =  dao.register_list(paraMap);
		return register_list;
	}

	// 환자명 알아오기
	@Override
	public String getPatientName(String order_no) {
		String name = dao.getPatientName(order_no);
		return name;
	}
	
	// 수술설명불러오기
	@Override
	public String surgery_description(String order_no) {
		String surgery_description = dao.surgery_description(order_no);
		return surgery_description;
	}

	// 수술실 목록 알아오기 
	@Override
	public List<SurgeryroomVO> getSurgeryRoom() {
		List<SurgeryroomVO> room = dao.getSurgeryRoom();
		return room;
	}

	// 수술 시작 가능한 시간 찾기
	@Override
	public List<String> oktime(Map<String, Object> paraMap) {
		
		// 30 분 단위 예약 가능 배열 생성하기 
		List<String> alltime = Arrays.asList(
			"09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
			"12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
			"15:00", "15:30", "16:00", "16:30", "17:00", "17:30"
		);
		
		// 예약된 시간 가져오기 (조회사항 : 수술실, 시작시간, 끝나는 시간)
		List<Map<String, String>> reservedTime = dao.reservedTime(paraMap); 
		// System.out.println("예약된 시간" + reservedTime);
		// 예약된 시간[{SURGERY_END_TIME=15:30, SURGERY_START_TIME=14:00}]
		
		if(reservedTime.isEmpty()) { // 예약된 시간이 없다면 모든 시간대를 출력해라 
			return alltime;
		}
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");	
		
		
		// 예약 가능한 시간 필터링하기 
		return alltime.stream() 	// alltime 리스트를 stream 으로 변환한다. 
					  .map(time -> LocalTime.parse(time, formatter)) // 문자열을 LocalTime 으로 변환
					  .filter(time -> reservedTime.stream()
							  .noneMatch(reserved -> {
							   String startStr = reserved.get("surgery_start_time");
					           String endStr = reserved.get("surgery_end_time");
					           //System.out.println("startStr"+startStr);
					           //System.out.println("endStr"+endStr);
					          
					           if (startStr == null || endStr == null) {
					        	   return false; // null 값이면 필터링에서 제외 (예약된 시간으로 간주 X)
					           }
							   
					           LocalTime start = LocalTime.parse(startStr, formatter);
					           LocalTime end = LocalTime.parse(endStr, formatter);
					           
					           // 시작시간 ~ 종료시간을 제외한 시간을 선택한다.
					           return (time.equals(start) || time.equals(end) || time.isAfter(start) && time.isBefore(end)); // 예약된 시간 범위안에 포함되면 제거
							  })
					   )
					  .map(time -> time.format(formatter))
					  .collect(Collectors.toList());
	}

	
	// 수술 예약이 있는 시간 찾기
	@Override
	public List<Map<String, String>> reservedTime(Map<String, Object> paraMap) {
		List<Map<String, String>> reservedTime = dao.reservedTime(paraMap);
		return reservedTime;
	}
	
	// 수술 예약하기 - 동시성처리
	@Transactional // 중복검사 -> 예약완료하기 (트랜잭션 처리)
	public void surgeryRegister(SurgeryVO surgeryvo) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("surgery_surgeryroom_name", surgeryvo.getSurgery_surgeryroom_name());
		paraMap.put("surgery_day", surgeryvo.getSurgery_day());
		paraMap.put("surgery_start_time", surgeryvo.getSurgery_start_time());
		
		// 1. 비관적락 사용해서 예약된 시간인지 확인하기
		SurgeryVO existingSurgery = dao.existingSurgery(paraMap);
		
		if(existingSurgery != null) { // 1-2. 예약이 되어있는 상태라면 오류 발생(동시성)
			throw new RuntimeException("해당 시간에 이미 예약이 존재합니다.");
		}
		
		// 2. 예약이 없다면 예약 처리를 해준다.
		dao.insertSurgery(surgeryvo);
	}

	// 수술 예약 일정 수정하기
	@Override
	public int surgeryUpdate(Map<String, String> paraMap) {
		int n = dao.surgeryUpdate(paraMap);
		return n;
	}

	// 입원 대기자 목록 총 개수
	@Override
	public int getTotalCount2() {
		int n = dao.hospitalize_list_cnt();
		return n;
	}

	// 입원 대기자 목록
	@Override
	public List<Map<String, String>> hospitalize_list(Map<String, String> paraMap2) {
		List<Map<String, String>> hospitalize_list = dao.hospitalize_list(paraMap2);
		return hospitalize_list;
	}

	// 입원일수 알아오기
	@Override
	public String order_howlonghosp(String order_no) {
		String howlonghosp = dao.order_howlonghosp(order_no);
		return howlonghosp;
	}

	// 입원실 목록 가져오기 4인실
	@Override
	public List<HospitalizeroomVO> hospitalizeroom() {
		List<HospitalizeroomVO> hospitalizeroom = dao.hospitalizeroom();
		return hospitalizeroom;
	}

	// 입원실 목록 가져오기 2인실
	@Override
	public List<HospitalizeroomVO> hospitalizeroom_2() {
		List<HospitalizeroomVO> hospitalizeroom_2 = dao.hospitalizeroom_2();
		return hospitalizeroom_2;
	}

	// 입원예약하기
	@Override
	public void hospitalizeRegister(HospitalizeVO hospitalizevo) {
		dao.hospitalizeRegister(hospitalizevo);
	}

	// 입원실 잔여석 가져오기
	@Override
	public List<Map<String, String>> okSeat() {
		List<Map<String, String>> okseat = dao.okSeat();
		return okseat;
	}



}
