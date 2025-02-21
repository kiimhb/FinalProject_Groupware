package com.spring.med.organization.domain;

//**** 조직도 VO **** //

public class OrganVO {
	
	// === Field === //
	private String member_userid;		// 사번
	private String member_name;			// 이름
	private String parent_dept_name;	// 상위부서명
	private String child_dept_name;		// 하위부서명
	private String child_dept_no;		// 하위부서번호
	private String parent_dept_no;		// 상위부서번호
	private String fk_parent_dept_no;	// 하위부서가 참조하는 상위부서번호
	private String member_mobile;		// 휴대폰번호
	private String member_email;		// 이메일
	private String member_start;		// 입사일
	private String member_pro_filename;	// 프로필_첨부파일
	private String member_position;		// 직급

	
	private String type;				// 상위부서/하위부서/사원 을 구분하기 위한 필드
	
	
	
	// === Method === //
	public String getMember_userid() {
		return member_userid;
	}
	public void setMember_userid(String member_userid) {
		this.member_userid = member_userid;
	}
	public String getMember_name() {
		return member_name;
	}
	public void setMember_name(String member_name) {
		this.member_name = member_name;
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
	public String getMember_mobile() {
		return member_mobile;
	}
	public void setMember_mobile(String member_mobile) {
		this.member_mobile = member_mobile;
	}
	public String getMember_email() {
		return member_email;
	}
	public void setMember_email(String member_email) {
		this.member_email = member_email;
	}
	public String getMember_start() {
		return member_start;
	}
	public void setMember_start(String member_start) {
		this.member_start = member_start;
	}
	public String getMember_pro_filename() {
		return member_pro_filename;
	}
	public void setMember_pro_filename(String member_pro_filename) {
		this.member_pro_filename = member_pro_filename;
	}
	public String getChild_dept_no() {
		return child_dept_no;
	}
	public void setChild_dept_no(String child_dept_no) {
		this.child_dept_no = child_dept_no;
	}
	public String getParent_dept_no() {
		return parent_dept_no;
	}
	public void setParent_dept_no(String parent_dept_no) {
		this.parent_dept_no = parent_dept_no;
	}
	public String getFk_parent_dept_no() {
		return fk_parent_dept_no;
	}
	public void setFk_parent_dept_no(String fk_parent_dept_no) {
		this.fk_parent_dept_no = fk_parent_dept_no;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getMember_position() {
		return member_position;
	}
	public void setMember_position(String member_position) {
		this.member_position = member_position;
	}
}
