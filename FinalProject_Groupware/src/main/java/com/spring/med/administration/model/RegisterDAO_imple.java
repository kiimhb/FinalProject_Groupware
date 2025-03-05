package com.spring.med.administration.model;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.administration.domain.Calendar_hospitalize_recordVO;
import com.spring.med.administration.domain.Calendar_surgery_recordVO;
import com.spring.med.hospitalize.domain.HospitalizeVO;
import com.spring.med.surgery.domain.SurgeryVO;
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

	// 수술설명 불러오기
	@Override
	public String surgery_description(String order_no) {
		String surgery_description = sqlsession.selectOne("hyeyeon.surgery_description", order_no);
		return surgery_description;
	}
	
	// 수술실 목록 알아오기
	@Override
	public List<SurgeryroomVO> getSurgeryRoom() {
		List<SurgeryroomVO> room = sqlsession.selectList("hyeyeon.getRoom");
		return room;
	}
		
	// 수술 가능한 시간 찾기 (기존에 예약된 시간을 찾는것)
	@Override
	public List<Map<String, String>> reservedTime(Map<String, Object> paraMap) {
		List<Map<String, String>> reservedTime = sqlsession.selectList("hyeyeon.reservedTime", paraMap);	
		return reservedTime;
	}

	// 동일한 날 한개이상의 수술을 막기 위해 주민번호 알아오기 
	@Override
	public String getJubun(SurgeryVO surgeryvo) {
		String jubun = sqlsession.selectOne("hyeyeon.jubun", surgeryvo);
		return jubun;
	}

	// 1. 동일한 환자가 같은 날 다른 수술이 있는지 확인하기 (수술은 하루에 한개만 가능)
	@Override
	public int todayOtherSurgery(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("hyeyeon.todayOtherSurgery", paraMap);
		return n;
	}

	
	// 2. 비관적락 사용해서 예약된 시간인지 확인하기
	@Override
	public SurgeryVO existingSurgery(Map<String, String> paraMap) {
		SurgeryVO existingSurgery = sqlsession.selectOne("hyeyeon.existingSurgery", paraMap);
		return existingSurgery;
	}
	
	// 3. 예약처리하기
	@Override
	public void insertSurgery(SurgeryVO surgeryvo) {
		sqlsession.update("hyeyeon.insertSurgery", surgeryvo);
	}

	// 수술 예약일정 수정하기 
	@Override
	public void surgeryUpdate(Map<String, String> paraMap) {
		sqlsession.update("hyeyeon.surgeryUpdate", paraMap);
	}

	// 입원 대기자 목록 총 개수
	@Override
	public int hospitalize_list_cnt() {
		int n = sqlsession.selectOne("hyeyeon.hospitalize_list_cnt");
		return n;
	}

	// 입원 대기자 목록
	@Override
	public List<Map<String, String>> hospitalize_list(Map<String, String> paraMap2) {
		List<Map<String, String>> hospitalize_list = sqlsession.selectList("hyeyeon.hospitalize_list", paraMap2);
		return hospitalize_list;
	}

	// 수술일수 알아오기
	@Override
	public String order_howlonghosp(String order_no) {
		String howlonghosp = sqlsession.selectOne("hyeyeon.order_howlonghosp", order_no);
		return howlonghosp;
	}

	// 입원실 잔여석 가져오기
	@Override
	public List<Map<String, String>> okSeat(Map<String, String> paraMap) {
		List<Map<String, String>> okSeat = sqlsession.selectList("hyeyeon.okSeat", paraMap);
		return okSeat;
	}

	// 중복 입원 확인을 위해 주민번호 알아오기
	@Override
	public String jubunGet(HospitalizeVO hospitalizevo) {
		String n = sqlsession.selectOne("hyeyeon.jubunGet", hospitalizevo);
		return n;
	}
	
	// 1. 동일한 입원일/퇴원일에 다른 입원건이 있는지 확인
	@Override
	public int todayOtherHospitalize(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("hyeyeon.todayOtherHospitalize", paraMap);
		return n;
	}
	
	// 2. 비관적락 사용해서 예약된 시간인지 확인하기(입원)
	@Override
	public HospitalizeVO existingHospitalize(Map<String, String> paraMap) {
		HospitalizeVO existingHospitalize = sqlsession.selectOne("hyeyeon.existingHospitalize", paraMap);
		return existingHospitalize;
	}
	
	// 3. 입원 예약하기 
	@Override
	public void hospitalizeRegister(HospitalizeVO hospitalizevo) {
		sqlsession.update("hyeyeon.hospitalizeRegister", hospitalizevo);
	}

	// 입원예약수정하기
	@Override
	public void hospitalizeUpdate(Map<String, String> paraMap) {
		sqlsession.update("hyeyeon.hospitalizeUpdate", paraMap);	
	}

	// 입원실 현황 캘린더조회
	@Override
	public List<Calendar_hospitalize_recordVO> hospitalizeScheduleList() {
		List<Calendar_hospitalize_recordVO> hospitalizeScheduleList = sqlsession.selectList("hyeyeon.hospitalizeScheduleList");
		return hospitalizeScheduleList;
	}

	// 수술현황 캘린더조회
	@Override
	public List<Calendar_surgery_recordVO> surgerySchedule() {
		List<Calendar_surgery_recordVO> surgerySchedule = sqlsession.selectList("hyeyeon.surgerySchedule");
		return surgerySchedule;
	}
	
}
