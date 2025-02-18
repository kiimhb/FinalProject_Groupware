package com.spring.med.administration.model;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.surgery.domain.SurgeryroomVO;

@Repository
public class RegisterDAO_imple implements RegisterDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 수술 대기자 목록 개수
	@Override
	public int register_list_cnt() {
		int n = sqlsession.selectOne("hyeyeon.registerListCnt");
		return n;
	}
	
	// 수술 대기자 목록 조회하기 
	@Override
	public List<Map<String, String>> register_list(Map<String, String> paraMap) {
		List<Map<String, String>> register_list = sqlsession.selectList("hyeyeon.registerList", paraMap);
		return register_list;
	}

	// 환자명 알아오기
	@Override
	public String getPatientName(String order_no) {
		String name = sqlsession.selectOne("hyeyeon.getName", order_no);
		return name;
	}

	// 수술실 목록 알아오기
	@Override
	public List<SurgeryroomVO> getSurgeryRoom() {
		List<SurgeryroomVO> room = sqlsession.selectList("hyeyeon.getRoom");
		return room;
	}
	
	
	// 예약된 시간 가져오기
	@Override
	public List<String> reservedTime(Map<String, String> paraMap) {
		List<String> reservedTime = sqlsession.selectList("hyeyeon.reservedTime", paraMap);	
		return reservedTime;
	}

}
