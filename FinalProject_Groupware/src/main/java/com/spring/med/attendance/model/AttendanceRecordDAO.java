package com.spring.med.attendance.model;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface AttendanceRecordDAO {
	
	
	// 이름 알아오기
	String getName(String member_userid);

	// 출퇴근 기록 List
	List<Map<String, String>> StartRecordList(String member_userid);

	// 퇴근 기록 List
	List<Map<String, String>> EndRecordList(String member_userid);

	// 1. 어제 출근하지 않은 사원들의 아이디 알아오기
	List<String> yesterday_notWork_userid();

	// 2. 결근한 사원들 출퇴근 테이블 결근 처리 하기
	void insert_status_no(String fk_member_userid);

	
	// 오늘 이미 출근 기록이 있는지 확인하기
	boolean already_check_in(String member_userid);
	
	// 오늘 이미 퇴근 기록이 있는지 확인하기
	boolean already_check_out(String member_userid);

	// 출근기록하기
	void check_in(Map<String, String> paraMap);

	// 퇴근기록하기
	void check_out(Map<String, String> paraMap);

	
}
