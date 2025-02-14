package com.spring.med.approval.domain;

//**** 휴가신청서 VO **** //

public class DayLeaveVO {

	// === Field === //
	private String day_leave_no;         // 휴가신청번호
	private String fk_draft_no;          // 기안문서번호
	private String day_leave_start;      // 연/반차 시작일자
	private String day_leave_end;        // 연/반차 종료일자
	private String day_leave_cnt;        // 사용일수
	private String day_leave_reason;     // 휴가사유
	
	
	// === Method === //
	public String getDay_leave_no() {
		return day_leave_no;
	}
	public void setDay_leave_no(String day_leave_no) {
		this.day_leave_no = day_leave_no;
	}
	public String getFk_draft_no() {
		return fk_draft_no;
	}
	public void setFk_draft_no(String fk_draft_no) {
		this.fk_draft_no = fk_draft_no;
	}
	public String getDay_leave_start() {
		return day_leave_start;
	}
	public void setDay_leave_start(String day_leave_start) {
		this.day_leave_start = day_leave_start;
	}
	public String getDay_leave_end() {
		return day_leave_end;
	}
	public void setDay_leave_end(String day_leave_end) {
		this.day_leave_end = day_leave_end;
	}
	public String getDay_leave_cnt() {
		return day_leave_cnt;
	}
	public void setDay_leave_cnt(String day_leave_cnt) {
		this.day_leave_cnt = day_leave_cnt;
	}
	public String getDay_leave_reason() {
		return day_leave_reason;
	}
	public void setDay_leave_reason(String day_leave_reason) {
		this.day_leave_reason = day_leave_reason;
	}
	
	
}
