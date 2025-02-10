package com.spring.med.approval.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.approval.service.ApprovalService;

import jakarta.security.auth.message.callback.PrivateKeyCallback.Request;
import jakarta.servlet.http.HttpServletRequest;

// **** 기안서 및 결재 컨트롤러 **** //

@Controller
@RequestMapping(value="/approval/*")
public class ApprovalController {
	
	@Autowired
	private ApprovalService service;
	
	
	// ==== 기안문작성 폼페이지 요청 ==== //
	@GetMapping("write")
	public ModelAndView writeDraftForm(ModelAndView mav) {
		mav.setViewName("content/approval/write");
		
		return mav;
	}
	
	// ==== 휴가신청서 양식 예시 ==== //
	@GetMapping("dayLeaveForm")
	public ModelAndView dayLeaveForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/dayLeaveForm");
		return mav;
	}
	
	// ==== 지출결의서 양식 예시 ==== //
	@GetMapping("expenseReportForm")
	public ModelAndView expenseReportForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/expenseReportForm");
		return mav;
	}
	
	// ==== 근무 교대 신청서 양식 예시 ==== //
	@GetMapping("workChangeForm")
	public ModelAndView workChangeForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/workChangeForm");
		return mav;
	}
	
	// ==== 출장신청서 양식 예시 ==== //
	@GetMapping("businessTripForm")
	public ModelAndView businessTripForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/businessTripForm");
		return mav;
	}
	
	
	// ==== 선택한 기안 양식 가져오기 ==== //
	@GetMapping("writeDraft")
	public ModelAndView writeDraft(ModelAndView mav,
								   @RequestParam String typeSelect) {
		
		// >>> 이곳에서 작성자 정보 모두 넣어주기 <<< //
		
		if(typeSelect.equals("휴가신청서")) {
			
			// 잔여 연차
			
			// 양식 번호 추출
			
			// 문서 양식
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("지출결의서")) {
			
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("근무 변경 신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");			
		}
		else if(typeSelect.equals("출장신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}

		return mav;
	}
}
