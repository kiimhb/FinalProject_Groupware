package com.spring.med.approval.domain;

//**** 기안문서(작성) VO **** //

public class DraftVO {
	
	// === Field === //
	private String draft_no;               		// 기안문서번호
	private String fk_member_userid;            // 기안자사번
	private String draft_form_type;             // 기안양식종류(휴가/지출/근뭅녀경/출장)
	private String draft_subject;               // 기안제목
	private String draft_write_date;            // 작성일자
	private String draft_status;                // 결재상태(상신취소/대기/진행중/승인/반려)
	private String draft_urgent;                // 긴급여부(0/1)
	private String draft_saved;                 // 임시저장여부(0/1)
	private String draft_file_origin_name;      // 원본파일명
	private String draft_file_name;             // 저장된파일명
	private String draft_file_size;             // 파일크기
	
	
	// === Method === // 
	public String getDraft_no() {
		return draft_no;
	}
	public void setDraft_no(String draft_no) {
		this.draft_no = draft_no;
	}
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
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

	
}
