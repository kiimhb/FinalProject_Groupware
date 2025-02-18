package com.spring.med.patient.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.patient.domain.TreatPatientVO;
import com.spring.med.patient.model.TreatPatientDAO;

@Service
public class TreatPatientService_imple implements TreatPatientService {

	
	@Autowired
	private TreatPatientDAO tpdao;
	
	
	// 진료 - 진료대기환자 에서 진료대기환자 리스트 보여주기
	@Override
	public List<Map<String, String>> selectPatientWaiting(Map<String, String> paraMap) {
		List<Map<String, String>> patientList = tpdao.selectPatientWaiting(paraMap);
		return patientList;
	}
	
	// 진료 - 진료대기환자 에서 총 진료환자수 알아오기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = tpdao.getTotalCount(paraMap);
		return n;
	}
	
	// 진료 - 환자 등록 검색어 입력시 자동글 완성하기 4 === //
	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = tpdao.wordSearchShow(paraMap);
		return wordList;
	}

	// === 진료- 기존환자 조회에서 검색된 주민번호로 환자 정보 보여주기
	@Override
	public List<TreatPatientVO> existPatientShow(Map<String, String> paraMap) {
		List<TreatPatientVO> existPatientList = tpdao.existPatientShow(paraMap);
		return existPatientList;
	}
	
}
