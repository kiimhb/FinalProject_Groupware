package com.spring.med.attendance.model;

import java.util.List;
import java.util.Map;

public interface AttendanceCommuteDAO {

	//근태관리- 근태조회 (사고계,기초계 총합)
	List<Map<String, String>> get_commute_count(String member_userid);

	//근태관리- 근태조회 (출퇴근내역 총합)
	int getTotalCount(Map<String, String> paraMap);

	//근태관리- 근태조회 (출퇴근내역 총합 리스트)
	List<Map<String, String>> get_work_count(Map<String, String> paraMap);

	
	
	//근태관리- 휴가관리 (휴가 총합)
	List<Map<String, String>> get_myLeave_count(String member_userid);

	//근태관리- 휴가관리 (휴가 내역총합)
	int get_myLeave_list_Total(Map<String, String> paraMap);

	//근태관리- 휴가관리 (휴가 내역 총합리스트)
	List<Map<String, String>> get_myLeave_list(Map<String, String> paraMap);

}
