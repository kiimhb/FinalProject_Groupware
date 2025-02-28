package com.spring.med.administration.model;

import java.util.List;
import java.util.Map;

public interface PayDAO {

	// 수납상태와 검색어에 따른 총 수납개수
	int getTotalCount(Map<String, String> paraMap);

	// 수납대기 또는 수납 완료 목록 
	List<Map<String, String>> pay_list(Map<String, String> paraMap);

	// 수납처리하기
	void pay_success(String order_no);

}
