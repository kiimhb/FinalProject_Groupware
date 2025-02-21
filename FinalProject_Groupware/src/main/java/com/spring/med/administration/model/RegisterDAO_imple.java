package com.spring.med.administration.model;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.hospitalize.domain.HospitalizeVO;
import com.spring.med.hospitalize.domain.HospitalizeroomVO;
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

	// 비관적락 사용해서 예약된 시간인지 확인하기
	@Override
	public SurgeryVO existingSurgery(Map<String, String> paraMap) {
		SurgeryVO existingSurgery = sqlsession.selectOne("hyeyeon.existingSurgery", paraMap);
		return existingSurgery;
	}
	
	// 예약처리하기
	@Override
	public void insertSurgery(SurgeryVO surgeryvo) {
		sqlsession.update("hyeyeon.insertSurgery", surgeryvo);
	}

	// 수술 예약일정 수정하기 
	@Override
	public int surgeryUpdate(Map<String, String> paraMap) {
		int n = sqlsession.update("hyeyeon.surgeryUpdate", paraMap);
		return n;
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

	// 수술실 목록 가져오기 4인실
	@Override
	public List<HospitalizeroomVO> hospitalizeroom() {
		List<HospitalizeroomVO> hospitalizeroom = sqlsession.selectList("hyeyeon.hospitalizeroom");
		return hospitalizeroom;
	}

	// 수술실 목록 가져오기 2인실
	@Override
	public List<HospitalizeroomVO> hospitalizeroom_2() {
		List<HospitalizeroomVO> hospitalizeroom_2 = sqlsession.selectList("hyeyeon.hospitalizeroom_2");
		return hospitalizeroom_2;
	}

	@Override
	public void hospitalizeRegister(HospitalizeVO hospitalizevo) {
		sqlsession.update("hyeyeon.hospitalizeRegister", hospitalizevo);
	}

	// 입원실 잔여석 가져오기
	@Override
	public List<Map<String, String>> okSeat() {
		List<Map<String, String>> okSeat = sqlsession.selectList("hyeyeon.okSeat");
		return okSeat;
	}
	
	
}
