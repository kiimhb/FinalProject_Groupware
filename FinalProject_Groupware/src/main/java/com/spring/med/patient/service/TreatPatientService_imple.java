package com.spring.med.patient.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.spring.med.patient.domain.TreatPatientVO;
import com.spring.med.patient.model.TreatPatientDAO;

public class TreatPatientService_imple implements TreatPatientService {

	
	@Autowired
	private TreatPatientDAO dao;
	
	
	// 진료 - 진료대기환자 에서 진료대기환자 리스트 보여주기
	@Override
	public List<TreatPatientVO> selectPatientWaiting() {

		List<TreatPatientVO> patientList = dao.selectPatientWaiting();

		return patientList;
	}

}
