package com.spring.med.administration.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.administration.model.PatientDAO;
import com.spring.med.patient.domain.PatientVO;


@Service
public class PatientService_imple implements PatientService {
	
	@Autowired  // Type에 따라 알아서 Bean 을 주입해준다.
	private PatientDAO dao;

	// 진료기록이 있는 총 환자수 (totalCount)
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = dao.getTotalCount(paraMap);
		return n;
	}
	
	// 진료기록이 있는 환자 목록 
	@Override
	public List<Map<String, String>> patientList(Map<String, String> paraMap) {
		List<Map<String, String>> patientList = dao.patientList(paraMap);
		return patientList;
	}

	// 환자 주민번호 가져오기
	@Override
	public String getJubun(String seq) {
		String getJubun = dao.getJubun(seq);
		return getJubun;
	}
	
	// 선택한 환자의 차트 조회하기
	@Override
	public Map<String, String> detail_patient(String seq) {
		Map<String, String> detail_patient = dao.detail_patient(seq);
		return detail_patient;
	}

	// 개인별 환자 진료목록
	@Override
	public List<Map<String, String>> order_list(String jubun) {
		List<Map<String, String>> order_list = dao.order_list(jubun);
		return order_list;
	}

	
	
	
	
}
