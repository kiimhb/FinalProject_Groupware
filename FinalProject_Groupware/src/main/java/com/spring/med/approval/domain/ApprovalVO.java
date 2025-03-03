package com.spring.med.approval.domain;

//**** 기안결재 VO **** //

public class ApprovalVO {
	
	// === Field === //
	private String approval_no;        	// 기안양식번호
	private String fk_draft_no;        	// 기안문서번호
	private String fk_member_userid;    // 결재자사번, 결재자사번
	private String approval_step;       // 결재순서(단계 1/2/3)
	private String approver_status;     // 결재상태(대기/승인/반려)
	private String approver_feedback;   // 결재 or 반려 의견
	private String approver_date;		// 결재일자

	private String draft_no;				// 기안문서번호
	private String draft_form_type;			// 기안양식종류
	private String draft_subject;			// 기안제목
	private String draft_write_date;		// 작성일자
	private String draft_status;			// 결재상태
	private String draft_urgent;			// 긴급여부
	private String draft_saved;				// 임시저장여부
	private String draft_file_origin_name;	// 원본파일명
	private String draft_file_name;			// 저장된 파일명
	private String draft_file_size;			// 파일크기
	

	private String parent_dept_name;	// 결재자의 부문(상위부서)
	private String child_dept_name;		// 결재자의 부서(하위부서)
	private String member_position;		// 결재자의 직급
	private String member_name;			// 결재자의 이름
	private String member_userid;		// 결재자의 아이디
	
	
	// === Join === //
	private DayLeaveVO dayLeaveVO;
	private WorkChangeVO workchangeVO;


	// === Method === //
	public WorkChangeVO getWorkchangeVO() {
		return workchangeVO;
	}
	public void setWorkchangeVO(WorkChangeVO workchangeVO) {
		this.workchangeVO = workchangeVO;
	}
	public DayLeaveVO getDayLeaveVO() {
		return dayLeaveVO;
	}
	public void setDayLeaveVO(DayLeaveVO dayLeaveVO) {
		this.dayLeaveVO = dayLeaveVO;
	}
	public String getApproval_no() {
		return approval_no;
	}
	public String getParent_dept_name() {
		return parent_dept_name;
	}
	public void setParent_dept_name(String parent_dept_name) {
		this.parent_dept_name = parent_dept_name;
	}
	public String getChild_dept_name() {
		return child_dept_name;
	}
	public void setChild_dept_name(String child_dept_name) {
		this.child_dept_name = child_dept_name;
	}
	public String getMember_position() {
		return member_position;
	}
	public void setMember_position(String member_position) {
		this.member_position = member_position;
	}
	public String getMember_name() {
		return member_name;
	}
	public void setMember_name(String member_name) {
		this.member_name = member_name;
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
	public String getMember_userid() {
		return member_userid;
	}
	public void setMember_userid(String member_userid) {
		this.member_userid = member_userid;
	}
	public String getDraft_file_origin_name() {
		return draft_file_origin_name;
	}
	public void setDraft_file_origin_name(String draft_file_origin_name) {
		this.draft_file_origin_name = draft_file_origin_name;
	}
	public String getDraft_file_name() {
		return draft_file_name;
	}
	public void setDraft_file_name(String draft_file_name) {
		this.draft_file_name = draft_file_name;
	}
	public String getDraft_file_size() {
		return draft_file_size;
	}
	public void setDraft_file_size(String draft_file_size) {
		this.draft_file_size = draft_file_size;
	}
	public String getDraft_no() {
		return draft_no;
	}
	public void setDraft_no(String draft_no) {
		this.draft_no = draft_no;
	}
	public String getDraft_form_type() {
		return draft_form_type;
	}
	public void setDraft_form_type(String draft_form_type) {
		this.draft_form_type = draft_form_type;
	}
	public String getDraft_subject() {
		return draft_subject;
	}
	public void setDraft_subject(String draft_subject) {
		this.draft_subject = draft_subject;
	}
	public String getDraft_write_date() {
		return draft_write_date;
	}
	public void setDraft_write_date(String draft_write_date) {
		this.draft_write_date = draft_write_date;
	}
	public String getDraft_status() {
		return draft_status;
	}
	public void setDraft_status(String draft_status) {
		this.draft_status = draft_status;
	}
	public String getDraft_urgent() {
		return draft_urgent;
	}
	public void setDraft_urgent(String draft_urgent) {
		this.draft_urgent = draft_urgent;
	}
	public String getDraft_saved() {
		return draft_saved;
	}
	public void setDraft_saved(String draft_saved) {
		this.draft_saved = draft_saved;
	}

}
