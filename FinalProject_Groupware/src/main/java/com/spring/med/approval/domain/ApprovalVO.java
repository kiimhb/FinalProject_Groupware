package com.spring.med.approval.domain;

//**** 기안결재 VO **** //

public class ApprovalVO {
	
	// === Field === //
	private String approval_no;        	// 기안양식번호
	private String fk_draft_no;        	// 기안문서번호
	private String fk_member_userid;    // 결재자사번
	private String approval_step;       // 결재순서(단계 1/2/3)
	private String approver_status;     // 결재상태(대기/승인/반려)
	private String approver_feedback;   // 결재 or 반려 의견
	private String approver_date;		// 결재일자
	

	// === Method === //
	public String getApproval_no() {
		return approval_no;
	}
	public void setApproval_no(String approval_no) {
		this.approval_no = approval_no;
	}
	public String getFk_draft_no() {
		return fk_draft_no;
	}
	public void setFk_draft_no(String fk_draft_no) {
		this.fk_draft_no = fk_draft_no;
	}
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	public String getApproval_step() {
		return approval_step;
	}
	public void setApproval_step(String approval_step) {
		this.approval_step = approval_step;
	}
	public String getApprover_status() {
		return approver_status;
	}
	public void setApprover_status(String approver_status) {
		this.approver_status = approver_status;
	}
	public String getApprover_feedback() {
		return approver_feedback;
	}
	public void setApprover_feedback(String approver_feedback) {
		this.approver_feedback = approver_feedback;
	}
	public String getApprover_date() {
		return approver_date;
	}
	public void setApprover_date(String approver_date) {
		this.approver_date = approver_date;
	}
	
	
	

}
