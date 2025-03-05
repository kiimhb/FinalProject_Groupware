package com.spring.med.attendance.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.spring.med.attendance.model.AttendanceRecordDAO;

@Service
public class AttendanceRecordService_imple implements AttendanceRecordService {

	@Autowired
	AttendanceRecordDAO dao;
	
	// 이름 알아오기
	@Override
	public String getName(String member_userid) {
		String name = dao.getName(member_userid);
		return name;
	}
	
	// 출근 기록 List
	@Override
	public List<Map<String, String>> StartRecordList(String member_userid) {
		List<Map<String, String>> StartRecordList = dao.StartRecordList(member_userid);
		return StartRecordList;
	}

	// 퇴근 기록 List
	@Override
	public List<Map<String, String>> EndRecordList(String member_userid) {
		List<Map<String, String>> EndRecordList = dao.EndRecordList(member_userid);
		return EndRecordList;
	}

	// 매일 자동으로 결근 확인하기 (자정에 insert 되도록) 
	// 어제 출근 기록이 있는지 확인하는 것이다. 없다면 결근처리
	// 주말은 결근처리 되지 않도록 한다.
	@Override
	@Scheduled(cron="0 0 0 * * MON-FRI")
	public void not_work_insert() {
		
		// 1. 어제 출근하지 않은 사원들의 아이디 알아오기
		List<String> notWork_usreid = dao.yesterday_notWork_userid();
		
		for(String fk_member_userid : notWork_usreid) {
			dao.insert_status_no(fk_member_userid); // 2. 결근한 사원들 출퇴근 테이블 결근 처리 하기
		}
	}
	
	// 이미 출근기록이 존재하는지 확인하기 
	@Override
	public boolean already_check_in(String member_userid) {
		return dao.already_check_in(member_userid);
	}
	
	// 이미 퇴근기록이 존재하는지 확인하기 
	@Override
	public boolean already_check_out(String member_userid) {
		return dao.already_check_out(member_userid);
	}

	
	// 출근기록하기
	@Override
	public void check_in(Map<String, String> paraMap) {
		
		String work_starttime = paraMap.get("work_starttime");
		String work_startstatus = paraMap.get("work_startstatus");
		
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		
		try {
			Date date_work_starttime = sdf.parse(work_starttime);  // date 형식으로 변환 
			Date referenceTime = sdf.parse("09:00"); // 출근 기준시간 
			
			if(date_work_starttime.before(referenceTime)) { 
				work_startstatus = "0"; // 9시 이전이라면 
			} else { 
				work_startstatus = "1"; // 9시 이후에 출근했다면
			}
			
			paraMap.put("work_startstatus", work_startstatus);
			
		} catch(ParseException e) {
			e.printStackTrace();
		}

		dao.check_in(paraMap); // 출근기록하기
		
	}

	// 퇴근 기록하기
	@Override
	public void check_out(Map<String, String> paraMap) {
		String work_endtime = paraMap.get("work_endtime");
		String work_endstatus = paraMap.get("work_endstatus");
		
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		
		try {
			Date date_work_endttime = sdf.parse(work_endtime);  // date 형식으로 변환 
			Date referenceTime = sdf.parse("18:00"); // 퇴근 기준시간
			
			if(date_work_endttime.before(referenceTime)) { 
				work_endstatus = "1"; // 18시 이전에 퇴근했다면 조퇴
			} else { 
				work_endstatus = "0"; // 18시 이후에 퇴근했다면 정상퇴근
			}
			
			paraMap.put("work_endstatus", work_endstatus);
			
		} catch(ParseException e) {
			e.printStackTrace();
		}

		dao.check_out(paraMap); // 퇴근기록하기
		
	}
}
