package com.spring.med.management.domain;

public class ManagementVO {
	
	private String member_userid;		//사번
	private String fk_position_no;		//직급번호
	private String member_pwd;			//비밀번호 (SHA-256 암호화 대상)
	private String member_name;			//성명
	private String member_mobile;		//휴대전화
	private String member_email;		//이메일
	private String member_birthday;		//생년월일
	private String member_gender;		//성별
	private String member_signature;	//서명이미지
	private String member_start;		//입사일자
	private String member_last;			//퇴사일자
	private String member_filename;		//프로필사진 
	private String member_orgfilename;	//프로필사진 오리지널명
	private String member_filesize;		//파일 사이즈 체크
	private String member_yeoncha;		//연차
	private String member_grade;		//등급
	private String member_workingTime;	//근무시간
	
	public String getMember_userid() {
		return member_userid;
	}
	public void setMember_userid(String member_userid) {
		this.member_userid = member_userid;
	}
	public String getFk_position_no() {
		return fk_position_no;
	}
	public void setFk_position_no(String fk_position_no) {
		this.fk_position_no = fk_position_no;
	}
	public String getMember_pwd() {
		return member_pwd;
	}
	public void setMember_pwd(String member_pwd) {
		this.member_pwd = member_pwd;
	}
	public String getMember_name() {
		return member_name;
	}
	public void setMember_name(String member_name) {
		this.member_name = member_name;
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
	public String getMember_birthday() {
		return member_birthday;
	}
	public void setMember_birthday(String member_birthday) {
		this.member_birthday = member_birthday;
	}
	public String getMember_gender() {
		return member_gender;
	}
	public void setMember_gender(String member_gender) {
		this.member_gender = member_gender;
	}
	public String getMember_signature() {
		return member_signature;
	}
	public void setMember_signature(String member_signature) {
		this.member_signature = member_signature;
	}
	public String getMember_start() {
		return member_start;
	}
	public void setMember_start(String member_start) {
		this.member_start = member_start;
	}
	public String getMember_last() {
		return member_last;
	}
	public void setMember_last(String member_last) {
		this.member_last = member_last;
	}
	public String getMember_filename() {
		return member_filename;
	}
	public void setMember_filename(String member_filename) {
		this.member_filename = member_filename;
	}
	public String getMember_orgfilename() {
		return member_orgfilename;
	}
	public void setMember_orgfilename(String member_orgfilename) {
		this.member_orgfilename = member_orgfilename;
	}
	public String getMember_filesize() {
		return member_filesize;
	}
	public void setMember_filesize(String member_filesize) {
		this.member_filesize = member_filesize;
	}
	public String getMember_yeoncha() {
		return member_yeoncha;
	}
	public void setMember_yeoncha(String member_yeoncha) {
		this.member_yeoncha = member_yeoncha;
	}
	public String getMember_grade() {
		return member_grade;
	}
	public void setMember_grade(String member_grade) {
		this.member_grade = member_grade;
	}
	public String getMember_workingTime() {
		return member_workingTime;
	}
	public void setMember_workingTime(String member_workingTime) {
		this.member_workingTime = member_workingTime;
	}
	
	
	
	

}
