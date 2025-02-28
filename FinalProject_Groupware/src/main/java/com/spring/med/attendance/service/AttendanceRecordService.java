package com.spring.med.attendance.service;

import java.util.List;
import java.util.Map;

public interface AttendanceRecordService {

	// 이름 알아오기
	String getName(String member_userid);
	
	// 출근 기록 List
	List<Map<String, String>> StartRecordList(String member_userid);

	// 퇴근 기록 List
	List<Map<String, String>> EndRecordList(String member_userid);

	// 자동으로 결근 기록하기 (스프링 스케줄러)
	public void not_work_insert();
	
	// 이미 출근기록이 존재하는지 확인하기 
	boolean already_check_in(String member_userid);
	
	// 이미 퇴근기록이 존재하는지 확인하기 
	boolean already_check_out(String member_userid);
	
	// 출근기록하기
	void check_in(Map<String, String> paraMap);

	// 퇴근기록하기
	void check_out(Map<String, String> paraMap);

	

	
	


}
