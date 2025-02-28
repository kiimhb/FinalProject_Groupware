package com.spring.med.administration.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

@Repository
public class PayDAO_imple implements PayDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 수납상태와 검색어에 따른 총 수납개수
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("hyeyeon.getTotalCount", paraMap);
		return n;
	}

	
	// 수납대기 또는 수납 완료 목록 
	@Override
	public List<Map<String, String>> pay_list(Map<String, String> paraMap) {
		List<Map<String, String>> pay_list = sqlsession.selectList("hyeyeon.pay_list", paraMap);
		return pay_list;
	}

	// 수납처리하기
	@Override
	public void pay_success(String order_no) {	
		sqlsession.update("hyeyeon.pay_success", order_no);
	}
	
	
	
}
