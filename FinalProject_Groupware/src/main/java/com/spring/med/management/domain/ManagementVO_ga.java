package com.spring.med.management.domain;

import org.springframework.web.multipart.MultipartFile;

public class ManagementVO_ga {
	
	private String member_userid;				//사번
	private String fk_child_dept_no;			//하위부서번호
	private String member_pwd;					//비밀번호 (SHA-256 암호화 대상)
	private String member_name;					//성명
	private String member_mobile;				//휴대전화
	private String member_email;				//이메일
	private String member_birthday;				//생년월일
	private String member_gender;				//성별
	private String member_start;				//입사일자
	private String member_last;					//퇴사일자
	
	private String member_pro_filename;			//프로필사진 
	private String member_pro_orgfilename;		//프로필사진 오리지널명
	private String member_pro_filesize;			//파일 사이즈 체크
	private String member_position;				//직급
	private String member_yeoncha;				//연차
	private String member_grade;				//등급
	private String member_workingTime;			//근무시간
	
	private String member_sign_filename;		//서명이미지 
	private String member_sign_orgfilename;		//서명이미지 오리지널명
	private String member_sign_filesize;		//서명이미지 사이즈 체크
	
	private String child_dept_name;
	
	private Child_deptVO_ga ChildVO;
	private Parent_deptVO_ga ParentVO;
	
	
	public Child_deptVO_ga getChildVO() {
		return ChildVO;
	}




	public void setChildVO(Child_deptVO_ga childVO) {
		ChildVO = childVO;
	}




	public Parent_deptVO_ga getParentVO() {
		return ParentVO;
	}




	public void setParentVO(Parent_deptVO_ga parentVO) {
		ParentVO = parentVO;
	}




	
	
	private MultipartFile attach;
	/*
    form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 
       진짜파일 ==> WAS(톰캣) 디스크에 저장됨.
    */
	
	public ManagementVO_ga() {}
	
	
	

	public ManagementVO_ga(String member_userid, String fk_child_dept_no, String member_pwd, String member_name,
			String member_mobile, String member_email, String member_birthday, String member_gender,
			String member_start, String member_last, String member_pro_filename, String member_pro_orgfilename,
			String member_pro_filesize, String member_position, String member_yeoncha, String member_grade,
			String member_workingTime, String member_sign_filename, String member_sign_orgfilename,
			String member_sign_filesize, MultipartFile attach) {
		super();
		this.member_userid = member_userid;
		this.fk_child_dept_no = fk_child_dept_no;
		this.member_pwd = member_pwd;
		this.member_name = member_name;
		this.member_mobile = member_mobile;
		this.member_email = member_email;
		this.member_birthday = member_birthday;
		this.member_gender = member_gender;
		this.member_start = member_start;
		this.member_last = member_last;
		this.member_pro_filename = member_pro_filename;
		this.member_pro_orgfilename = member_pro_orgfilename;
		this.member_pro_filesize = member_pro_filesize;
		this.member_position = member_position;
		this.member_yeoncha = member_yeoncha;
		this.member_grade = member_grade;
		this.member_workingTime = member_workingTime;
		this.member_sign_filename = member_sign_filename;
		this.member_sign_orgfilename = member_sign_orgfilename;
		this.member_sign_filesize = member_sign_filesize;
		this.attach = attach;
	}




	public String getMember_userid() {
		return member_userid;
	}

	public void setMember_userid(String member_userid) {
		this.member_userid = member_userid;
	}

	public String getFk_child_dept_no() {
		return fk_child_dept_no;
	}

	public void setFk_child_dept_no(String fk_child_dept_no) {
		this.fk_child_dept_no = fk_child_dept_no;
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

	public String getMember_pro_filename() {
		return member_pro_filename;
	}

	public void setMember_pro_filename(String member_pro_filename) {
		this.member_pro_filename = member_pro_filename;
	}

	public String getMember_pro_orgfilename() {
		return member_pro_orgfilename;
	}

	public void setMember_pro_orgfilename(String member_pro_orgfilename) {
		this.member_pro_orgfilename = member_pro_orgfilename;
	}

	public String getMember_pro_filesize() {
		return member_pro_filesize;
	}

	public void setMember_pro_filesize(String member_pro_filesize) {
		this.member_pro_filesize = member_pro_filesize;
	}

	public String getMember_position() {
		return member_position;
	}

	public void setMember_position(String member_position) {
		this.member_position = member_position;
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

	public String getMember_sign_filename() {
		return member_sign_filename;
	}

	public void setMember_sign_filename(String member_sign_filename) {
		this.member_sign_filename = member_sign_filename;
	}

	public String getMember_sign_orgfilename() {
		return member_sign_orgfilename;
	}

	public void setMember_sign_orgfilename(String member_sign_orgfilename) {
		this.member_sign_orgfilename = member_sign_orgfilename;
	}

	public String getMember_sign_filesize() {
		return member_sign_filesize;
	}

	public void setMember_sign_filesize(String member_sign_filesize) {
		this.member_sign_filesize = member_sign_filesize;
	}

	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}




	public String getChild_dept_name() {
		return child_dept_name;
	}




	public void setChild_dept_name(String child_dept_name) {
		this.child_dept_name = child_dept_name;
	}




	

	

	

}