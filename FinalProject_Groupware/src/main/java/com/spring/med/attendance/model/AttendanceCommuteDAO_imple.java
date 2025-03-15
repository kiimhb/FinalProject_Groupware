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

	@Override
	public List<Map<String, String>> get_commute_count(String member_userid) {
		List<Map<String, String>> commute_count = sqlsession.selectList("AttendanceCommute_ga.get_commute_count", member_userid);
		return commute_count;
	}

	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount  = sqlsession.selectOne("AttendanceCommute_ga.getTotalCount",paraMap);
		return totalCount;
	}

	@Override
	public List<Map<String, String>> get_work_count(Map<String, String> paraMap) {
		List<Map<String, String>> work_count = sqlsession.selectList("AttendanceCommute_ga.get_work_count", paraMap);
		return work_count;
	}


}
