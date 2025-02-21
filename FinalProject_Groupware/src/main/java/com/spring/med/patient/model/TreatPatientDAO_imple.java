package com.spring.med.patient.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.patient.domain.TreatPatientVO;

@Repository
public class TreatPatientDAO_imple implements TreatPatientDAO {

	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	
	
	
	// 진료 - 진료대기환자 에서 진료대기환자 리스트 보여주기
	@Override
	public List<Map<String, String>> selectPatientWaiting(Map<String, String> paraMap) {
		
		List<Map<String, String>> PatientList = sqlsession.selectList("seonggon_patient.selectPatientWaiting", paraMap);
		
		return PatientList;

	}
	
	// 진료 - 진료대기환자 에서 총 진료환자수 알아오기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("seonggon_patient.totalCount", paraMap);
		return n;
	}
	
	
	// === 진료 - 환자 등록 검색어 입력시 자동글 완성하기 5 === //
	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = sqlsession.selectList("seonggon_patient.wordSearchShow", paraMap);
		return wordList;
	}

	// === 진료- 기존환자 조회에서 검색된 주민번호로 환자 정보 보여주기
	@Override
	public List<TreatPatientVO> existPatientShow(Map<String, String> paraMap) {
		List<TreatPatientVO> existPatientList = sqlsession.selectList("seonggon_patient.existPatientShow", paraMap);
		return existPatientList;
	}

	// === 기존환자 조회에서 등록 및 접수 update 하기
	@Override
	public int submitNcheck2(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_patient.submitNcheck2", paraMap);
		return n;
	}

	// === 신규환자 정보 입력하여 등록 및 접수 insert 하기
	@Override
	public int submitNcheck1(TreatPatientVO tpvo) {
		int n = sqlsession.insert("seonggon_patient.submitNcheck1", tpvo);
		return n;
	}
	

}
