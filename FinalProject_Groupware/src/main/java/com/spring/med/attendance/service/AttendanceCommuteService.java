package com.spring.med.attendance.service;

import java.util.List;
import java.util.Map;

public interface AttendanceCommuteService {

	List<Map<String, String>> get_commute_count(String member_userid);

}
