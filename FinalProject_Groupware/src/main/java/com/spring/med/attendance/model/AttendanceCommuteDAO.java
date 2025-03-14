package com.spring.med.attendance.model;

import java.util.List;
import java.util.Map;

public interface AttendanceCommuteDAO {

	List<Map<String, String>> get_commute_count(String member_userid);

}
