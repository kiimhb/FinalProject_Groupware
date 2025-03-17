package com.spring.med.attendance.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository
public class AttendanceCommuteDAO_imple implements AttendanceCommuteDAO {
	
	@Autowired
	private SqlSessionTemplate sqlsession;

	//근태관리- 근태조회 (사고계,기초계 총합)
	@Override
	public List<Map<String, String>> get_commute_count(String member_userid) {
		List<Map<String, String>> commute_count = sqlsession.selectList("AttendanceCommute_ga.get_commute_count", member_userid);
		return commute_count;
	}

	//근태관리- 근태조회 (출퇴근내역 총합)
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount  = sqlsession.selectOne("AttendanceCommute_ga.getTotalCount",paraMap);
		return totalCount;
	}

	//근태관리- 근태조회 (출퇴근내역 총합 리스트)
	@Override
	public List<Map<String, String>> get_work_count(Map<String, String> paraMap) {
		List<Map<String, String>> work_count = sqlsession.selectList("AttendanceCommute_ga.get_work_count", paraMap);
		return work_count;
	}

	
	
	
	
	//근태관리- 휴가관리 (휴가 총합)
	@Override
	public List<Map<String, String>> get_myLeave_count(String member_userid) {
		List<Map<String, String>> myLeave_count = sqlsession.selectList("AttendanceCommute_ga.get_myLeave_count", member_userid);
		return myLeave_count; 
	}

	
	//근태관리- 휴가관리 (휴가 내역총합)
	@Override
	public int get_myLeave_list_Total(Map<String, String> paraMap) {
		int myLeave_list_Total = sqlsession.selectOne("AttendanceCommute_ga.get_myLeave_list_Total", paraMap);
		return myLeave_list_Total;
	}

	//근태관리- 휴가관리 (휴가 내역 총합리스트)
	@Override
	public List<Map<String, String>> get_myLeave_list(Map<String, String> paraMap) {
		List<Map<String, String>> myLeave_list = sqlsession.selectList("AttendanceCommute_ga.get_myLeave_list", paraMap);
		return myLeave_list;
	}


}
