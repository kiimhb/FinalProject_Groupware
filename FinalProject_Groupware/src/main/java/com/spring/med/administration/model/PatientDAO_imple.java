package com.spring.med.administration.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.administration.domain.Calendar_patient_recordVO;
import com.spring.med.patient.domain.PatientVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

@Repository
public class PatientDAO_imple implements PatientDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 진료기록이 있는 총 환자수 (totalCount)
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("hyeyeon.totalCount", paraMap);
		return n;
	}

	// 진료기록이 있는 환자 목록 
	@Override
	public List<Map<String, String>> patientList(Map<String, String> paraMap) {
		List<Map<String, String>> patientList = sqlsession.selectList("hyeyeon.patientList", paraMap);
		return patientList;
	}
	
	// 환자 주민번호 가져오기
	@Override
	public String getJubun(String seq) {
		String getJubun = sqlsession.selectOne("hyeyeon.getJubun", seq);
		return getJubun;
	}
	

	// 선택한 환자의 차트 조회하기 (기본 인적사항)
	@Override
	public Map<String, String> detail_patient(String seq) {
		Map<String, String> detail_patient = sqlsession.selectOne("hyeyeon.detail_patient", seq);
		return detail_patient;
	}
	
	// 개인별 환자 진료목록
	@Override
	public List<Map<String, String>> order_list(String jubun) {
		List<Map<String, String>> order_list = sqlsession.selectList("hyeyeon.order_list", jubun);
		return order_list;
	}

	// 개인별 환자 수술기록
	@Override
	public List<Map<String, Object>> surgery_list(String jubun) {
		List<Map<String, Object>> surgery_list = sqlsession.selectList("hyeyeon.surgery_list", jubun);
		return surgery_list;
	}

	// 수술실 목록 불러오기
	@Override
	public List<SurgeryroomVO> getSurgeryRoom() {
		List<SurgeryroomVO> room = sqlsession.selectList("hyeyeon.getRoom");
		return room;
	}

	 // 입원목록 불러오기 
	@Override
	public List<Map<String, Object>> hospitalize_list(String jubun) {
		List<Map<String, Object>> hospitalize_list = sqlsession.selectList("hyeyeon.hospitalizeList", jubun);
		return hospitalize_list;
	}

	// 환자의 일정목록을 불러오기 캘린더
	@Override
	public List<Calendar_patient_recordVO> selectSchedule(String jubun) {
		List<Calendar_patient_recordVO> selectSchedule = sqlsession.selectList("hyeyeon.selectSchedule", jubun);
		return selectSchedule;
	}


}
