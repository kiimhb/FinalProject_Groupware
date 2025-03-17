package com.spring.med.attendance.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.attendance.model.AttendanceCommuteDAO;

@Service
public class AttendanceCommuteService_imple implements AttendanceCommuteService {
	
	@Autowired
	private AttendanceCommuteDAO dao;

	
	//근태관리- 근태조회 (사고계,기초계 총합)
	@Override
	public List<Map<String, String>> get_commute_count(String member_userid) {
		List<Map<String, String>> commute_count = dao.get_commute_count(member_userid);
		return commute_count;
	}
	
	//근태관리- 근태조회 (출퇴근내역 총합)
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = dao.getTotalCount(paraMap);
		return totalCount;
	}

	//근태관리- 근태조회 (출퇴근내역 총합 리스트)
	@Override
	public List<Map<String, String>> get_work_count(Map<String, String> paraMap) {
		List<Map<String, String>> work_count = dao.get_work_count(paraMap);
		return work_count;
	}

	
	
	
	
	//근태관리- 휴가관리 (휴가 총합)
	@Override
	public List<Map<String, String>> get_myLeave_count(String member_userid) {
		List<Map<String, String>> myLeave_count = dao.get_myLeave_count(member_userid);
		return myLeave_count;
	}

	//근태관리- 휴가관리 (휴가 내역총합)
	@Override
	public int get_myLeave_list_Total(Map<String, String> paraMap) {
		int myLeave_list_Total = dao.get_myLeave_list_Total(paraMap);
		return myLeave_list_Total;
	}

	//근태관리- 휴가관리 (휴가 내역 총합리스트)
	@Override
	public List<Map<String, String>> get_myLeave_list(Map<String, String> paraMap) {
		List<Map<String, String>> myLeave_list = dao.get_myLeave_list(paraMap);
		return myLeave_list;
	}

	

	

	

}
