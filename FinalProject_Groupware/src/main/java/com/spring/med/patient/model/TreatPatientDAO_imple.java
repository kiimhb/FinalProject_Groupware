package com.spring.med.patient.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.spring.med.patient.domain.TreatPatientVO;

public class TreatPatientDAO_imple implements TreatPatientDAO {

	/*
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	
	
	
	@Override
	public List<TreatPatientVO> selectPatientWaiting() {
		
		List<TreatPatientVO> PatientList = sqlsession.selectList("patient.selectPatientWaiting");
		
		return PatientList;

	}
	*/

}
