package com.spring.med.attendance.service;

import java.util.List;
import java.util.Map;

public interface AttendanceCommuteService {

	List<Map<String, String>> get_commute_count(String member_userid);
	
	int getTotalCount(Map<String, String> paraMap);
	
	List<Map<String, String>> get_work_count(Map<String, String> paraMap);



}
