package com.spring.med.attendance.model;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

@Repository
public class AttendanceRecordDAO_imple implements AttendanceRecordDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 이름 알아오기 
	@Override
	public String getName(String member_userid) {
		String name = sqlsession.selectOne("hyeyeon.getMemberName", member_userid);
		return name;
	}

	
	// 출퇴근 기록 List
	@Override
	public List<Map<String, String>> StartRecordList(String member_userid) {
		List<Map<String, String>> StartRecordList = sqlsession.selectList("hyeyeon.StartRecordList", member_userid);
		return StartRecordList;
	}

	// 퇴근 기록 List
	@Override
	public List<Map<String, String>> EndRecordList(String member_userid) {
		List<Map<String, String>> EndRecordList = sqlsession.selectList("hyeyeon.EndRecordList", member_userid);
		return EndRecordList;
	}

	
	// 1. 어제 출근하지 않은 사원들의 아이디 알아오기
	@Override
	public List<String> yesterday_notWork_userid() {
		List<String> yesterday_notWork_userid = sqlsession.selectList("hyeyeon.yesterday_notWork_userid");
		return yesterday_notWork_userid;
	}
	
	// 2. 결근한 사원들 출퇴근 테이블 결근 처리 하기
	@Override
	public void insert_status_no(String fk_member_userid) {
		sqlsession.insert("hyeyeon.insert_status_no", fk_member_userid);
	}

	// 오늘 출근기록이 있는지 확인하기
	@Override
	public boolean already_check_in(String member_userid) {
		return sqlsession.selectOne("hyeyeon.already_check_in", member_userid);
	}
	
	// 오늘 이미 퇴근기록이 있는지 확인하기
	@Override
	public boolean already_check_out(String member_userid) {
		return sqlsession.selectOne("hyeyeon.already_check_out", member_userid);
	}
	
	// 출근기록하기
	@Override
	public void check_in(Map<String, String> paraMap) {
		sqlsession.insert("hyeyeon.check_in", paraMap);
	}

	// 퇴근기록하기
	@Override
	public void check_out(Map<String, String> paraMap) {
		sqlsession.update("hyeyeon.check_out", paraMap);
	}

	



}
