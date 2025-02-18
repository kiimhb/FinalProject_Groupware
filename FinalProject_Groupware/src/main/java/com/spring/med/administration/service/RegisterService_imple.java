package com.spring.med.administration.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.administration.model.RegisterDAO;
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

	// 수술실 목록 알아오기 
	@Override
	public List<SurgeryroomVO> getSurgeryRoom() {
		List<SurgeryroomVO> room = dao.getSurgeryRoom();
		return room;
	}

	
	// 수술 가능한 시간 찾기
	@Override
	public List<String> oktime(Map<String, String> paraMap) {
		
		// 30 분 단위 예약 가능 배열 생성하기
		List<String> alltime = Arrays.asList(
			"09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
			"12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
			"15:00", "15:30", "16:00", "16:30", "17:00", "17:30"
		);
		
		// 예약된 시간 가져오기 
		List<String> reservedTime = dao.reservedTime(paraMap);
		System.out.println("예약된 시간"+reservedTime);
		
		if(reservedTime.isEmpty()) {
			return alltime;
		}
		
		// 예약 가능한 시간 필터링하기 
		return alltime.stream() // alltime 리스트를 stream 으로 변환한다. 
					  .filter(time -> !reservedTime.contains(time)) // 필터를 통해 특정 조건을 만족하는 요소만 걸러낸다. (예약된 시간이 아닌 경우만 골라냄)
					  .collect(Collectors.toList()); // 다시 리스트 형태로 변환한다. 
	}
}
