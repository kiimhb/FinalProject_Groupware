package com.spring.med.order.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.order.model.OrderDAO;
import com.spring.med.patient.model.TreatPatientDAO;

@Service
public class OrderService_imple implements OrderService {

	
	@Autowired
	private OrderDAO odao;
	
	
	// === 환자 클릭하지않고 바로 진료 정보 입력 들어갔을시 첫 대기 환자 정보 select하기 === //
	@Override
	public Map<String, String> orderEnterandView(Map<String, String> paraMap) {

		Map<String, String> map = odao.orderEnterandView(paraMap);
			
		return map;
	}


	// === 대기환자 명에서 환자를 클릭하여 진료정보 입력 들어갔을시 환자 정보 select하기 === //
	@Override
	public Map<String, String> orderClickEnterandView(Map<String, String> paraMap) {
		
		Map<String, String> map = odao.orderClickEnterandView(paraMap);
		
		return map;
	}


	// === 진료정보입력에서 환자의 오더 기록 select하기 === //
	@Override
	public List<Map<String, String>> orderList(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = odao.orderList(paraMap);
		return mapList;
	}
}


