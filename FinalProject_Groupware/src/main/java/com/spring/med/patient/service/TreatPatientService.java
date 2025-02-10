package com.spring.med.patient.service;

import java.util.List;

import com.spring.med.patient.domain.TreatPatientVO;

public interface TreatPatientService {
	
	// 진료 - 진료대기환자 에서 진료대기환자 리스트 보여주기
	List<TreatPatientVO> selectPatientWaiting();


}
