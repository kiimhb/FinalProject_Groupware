package com.spring.med.order.service;

import java.util.List;
import java.util.Map;

public interface OrderService {


	// === 환자 클릭하지않고 바로 진료 정보 입력 들어갔을시 첫 대기 환자 정보 select하기 === //
	Map<String, String> orderEnterandView(Map<String, String> paraMap);

	// === 대기환자 명에서 환자를 클릭하여 진료정보 입력 들어갔을시 환자 정보 select하기 === //
	Map<String, String> orderClickEnterandView(Map<String, String> paraMap);

	// === 진료정보입력에서 환자의 오더 기록 select하기 === //
	List<Map<String, String>> orderList(Map<String, String> paraMap);

}
