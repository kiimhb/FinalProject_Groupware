package com.spring.med.schedule.domain;

public class Calendar_schedule_VO {

	private String schedule_no;    // 일정관리 번호
	private String schedule_startdate;     // 시작일자
	private String schedule_enddate;       // 종료일자
	private String schedule_subject;       // 제목
	private String schedule_color;         // 색상
	private String schedule_place;         // 장소
	private String schedule_joinuser;      // 공유자	
	private String schedule_content;       // 내용	
	private String fk_small_category_no;  // 캘린더 소분류 번호
	private String fk_large_category_no;  // 캘린더 대분류 번호
	private String fk_member_userid;     // 캘린더 일정 작성자 유저아이디
	
	public String getSchedule_no() {
		return schedule_no;
	}
	
	public void setSchedule_no(String schedule_no) {
		this.schedule_no = schedule_no;
	}
	
	public String getSchedule_startdate() {
		return schedule_startdate;
	}
	
	public void setSchedule_startdate(String schedule_startdate) {
		this.schedule_startdate = schedule_startdate;
	}
	
	public String getSchedule_enddate() {
		return schedule_enddate;
	}
	
	public void setSchedule_enddate(String schedule_enddate) {
		this.schedule_enddate = schedule_enddate;
	}
	
	public String getSchedule_subject() {
		return schedule_subject;
	}
	
	public void setSchedule_subject(String schedule_subject) {
		this.schedule_subject = schedule_subject;
	}
	
	public String getSchedule_color() {
		return schedule_color;
	}
	
	public void setSchedule_color(String schedule_color) {
		this.schedule_color = schedule_color;
	}
	
	public String getSchedule_place() {
		return schedule_place;
	}
	
	public void setSchedule_place(String schedule_place) {
		this.schedule_place = schedule_place;
	}
	
	public String getSchedule_joinuser() {
		return schedule_joinuser;
	}
	
	public void setSchedule_joinuser(String schedule_joinuser) {
		this.schedule_joinuser = schedule_joinuser;
	}
	
	public String getSchedule_content() {
		return schedule_content;
	}
	
	public void setSchedule_content(String schedule_content) {
		this.schedule_content = schedule_content;
	}
	
	public String getFk_small_category_no() {
		return fk_small_category_no;
	}
	
	public void setFk_small_category_no(String fk_small_category_no) {
		this.fk_small_category_no = fk_small_category_no;
	}
	
	public String getFk_large_category_no() {
		return fk_large_category_no;
	}
	
	public void setFk_large_category_no(String fk_large_category_no) {
		this.fk_large_category_no = fk_large_category_no;
	}
	
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}


	
}
