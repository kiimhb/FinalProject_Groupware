package com.spring.med.approval.domain;

//**** 근무변경신청서 vo **** //

public class WorkChangeVO {
	
	// === field === //
	private String work_change_no;                     // 근무변경신청번호
	private String fk_draft_no;                        // 기안문서번호
	private String work_change_start;                  // 근무변경 시작일자
	private String work_change_end;                    // 근무변경 종료일자
	private String work_change_reason;                 // 교대사유
	private String work_change_member_workingtime;     // 변경근무시간
	
	
	// === Method === //
	public String getWork_change_no() {
		return work_change_no;
	}
	public void setWork_change_no(String work_change_no) {
		this.work_change_no = work_change_no;
	}
	public String getFk_draft_no() {
		return fk_draft_no;
	}
	public void setFk_draft_no(String fk_draft_no) {
		this.fk_draft_no = fk_draft_no;
	}
	public String getWork_change_start() {
		return work_change_start;
	}
	public void setWork_change_start(String work_change_start) {
		this.work_change_start = work_change_start;
	}
	public String getWork_change_end() {
		return work_change_end;
	}
	public void setWork_change_end(String work_change_end) {
		this.work_change_end = work_change_end;
	}
	public String getWork_change_reason() {
		return work_change_reason;
	}
	public void setWork_change_reason(String work_change_reason) {
		this.work_change_reason = work_change_reason;
	}
	public String getWork_change_member_workingtime() {
		return work_change_member_workingtime;
	}
	public void setWork_change_member_workingtime(String work_change_member_workingtime) {
		this.work_change_member_workingtime = work_change_member_workingtime;
	}
	
	
	
	

}
