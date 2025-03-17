package com.spring.med.attendance.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.attendance.service.AttendanceRecordService;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/*")
public class CommuteController {

	@Autowired
	AttendanceRecordService service;
	
	// 아이피 보류
	// private static final List<String> companyIps = Arrays.asList("0:0:0:0:0:0:0:1"); 	// 회사 ip (접속가능한 아이피를 말한다.)
	
	/*
	private boolean isCompanyIp(String clintIp) {
		return companyIps.contains(clintIp);
	}
	*/
	
	// 내 아이디 65897690
	@GetMapping("commuteRecord")
	public ModelAndView requiredLogin_commuteRecord(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String member_userid = loginuser.getMember_userid();
		
		// 이름 알아오기
		String name = service.getName(member_userid);
		mav.addObject("member_name", name);
		
		// 출근 기록 List
		List<Map<String, String>> StartRecordList = service.StartRecordList(member_userid);
		// 퇴근 기록 List
		List<Map<String, String>> EndRecordList = service.EndRecordList(member_userid);
		
		mav.addObject("StartRecordList", StartRecordList);
		mav.addObject("EndRecordList", EndRecordList);
		mav.addObject("member_userid", member_userid);
		
		mav.setViewName("content/attendance/commuteRecord");
				
		return mav;
	}
	
	// 출근기록이 있는지 확인하기
	@GetMapping("already_check_in")
	@ResponseBody
	public ResponseEntity<Map<String,Boolean>> already_check_in(@RequestParam String member_userid) {
		
		boolean already_check_in = service.already_check_in(member_userid); // 이미 출근기록이 존재하는지 확인하기
		Map<String, Boolean> response = new HashMap<>();
		response.put("already_check_in", already_check_in);
		
		return ResponseEntity.ok(response);
	}
	
	
	// 퇴근기록이 있는지 확인하기
	@GetMapping("already_check_out")
	@ResponseBody
	public ResponseEntity<Map<String,Boolean>> already_check_out(@RequestParam String member_userid) {
		
		boolean already_check_out = service.already_check_out(member_userid); // 이미 퇴근기록이 존재하는지 확인하기
		Map<String, Boolean> response = new HashMap<>();
		response.put("already_check_out", already_check_out);
	
		return ResponseEntity.ok(response);
	}
	

	// 출근기록하기
	@PostMapping("check_in")
	@ResponseBody
	public ResponseEntity<Map<String,String>> check_in(@RequestParam String member_userid,
													   @RequestParam String work_starttime,
													   HttpServletRequest request) {
		
		Map<String, String> response = new HashMap<>();
		
		String work_startstatus = "";	
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_member_userid", member_userid);
		paraMap.put("work_starttime", work_starttime);
		paraMap.put("work_startstatus", work_startstatus);

		try {
			service.check_in(paraMap); // 예약하기 insert
			response.put("message", "출근 기록 성공! 오늘도 파이팅★");
			return ResponseEntity.ok(response);
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", e.getMessage()); // service 단의 예외 메시지 그대로 반환해준다. 
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}
	
	}
	
	
	// 퇴근기록하기
	@PostMapping("check_out")
	@ResponseBody
	public ResponseEntity<Map<String,String>> check_out(@RequestParam String member_userid,
														@RequestParam String work_recorddate,
													    @RequestParam String work_endtime,
													    HttpServletRequest request) {
		
		// String currentIp = request.getRemoteAddr();
		
		String work_endstatus = "";	
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_member_userid", member_userid);
		paraMap.put("work_recorddate", work_recorddate);
		paraMap.put("work_endtime", work_endtime);
		paraMap.put("work_endstatus", work_endstatus);
		
		Map<String, String> response = new HashMap<>();
		
		try {
			service.check_out(paraMap); // 퇴근기록하기
			response.put("message", "퇴근 기록 성공! 오늘 수고 많았습니다 ♧");
			return ResponseEntity.ok(response);
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", e.getMessage()); // service 단의 예외 메시지 그대로 반환해준다.
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}
	}

	
}
