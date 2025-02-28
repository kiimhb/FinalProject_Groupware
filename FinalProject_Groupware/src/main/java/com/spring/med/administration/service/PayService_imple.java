package com.spring.med.administration.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.med.administration.model.PayDAO;

@Service
public class PayService_imple implements PayService {
	
	@Autowired
	private PayDAO dao;

	
	// 수납상태와 검색어에 따른 총 수납개수
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = dao.getTotalCount(paraMap);
		return n;
	}
	
	// 수납대기 또는 수납 완료 목록 
	
	@Override
	public List<Map<String, String>> pay_list(Map<String, String> paraMap) {
		List<Map<String, String>> pay_list = dao.pay_list(paraMap);
		return pay_list;
	}

	// 수납처리하기
	@Transactional
	public void pay_success(List<String> order_no) {
		
		for(int i=0; i<order_no.size(); i++) {
			dao.pay_success(order_no.get(i));
		}
		
	}
	
}
