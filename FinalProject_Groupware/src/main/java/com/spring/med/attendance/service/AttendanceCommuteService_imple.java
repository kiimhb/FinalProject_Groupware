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

	@Override
	public List<Map<String, String>> get_commute_count(String member_userid) {
		List<Map<String, String>> commute_count = dao.get_commute_count(member_userid);
		return commute_count;
	}
	
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = dao.getTotalCount(paraMap);
		return totalCount;
	}

	@Override
	public List<Map<String, String>> get_work_count(Map<String, String> paraMap) {
		List<Map<String, String>> work_count = dao.get_work_count(paraMap);
		return work_count;
	}

	

	

	

}
