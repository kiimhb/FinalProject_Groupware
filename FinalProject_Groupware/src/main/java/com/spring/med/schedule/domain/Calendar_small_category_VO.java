package com.spring.med.schedule.domain;

public class Calendar_small_category_VO {

	private String small_category_no;     // 캘린더 소분류 번호
	private String fk_large_category_no;  // 캘린더 대분류 번호
	private String small_category_name;   // 캘린더 소분류 명
	private String fk_member_userid;     // 캘린더 소분류 작성자 유저아이디
	
	public String getSmall_category_no() {
		return small_category_no;
	}
	
	public void setSmall_category_no(String small_category_no) {
		this.small_category_no = small_category_no;
	}
	
	public String getFk_large_category_no() {
		return fk_large_category_no;
	}
	
	public void setFk_large_category_no(String fk_large_category_no) {
		this.fk_large_category_no = fk_large_category_no;
	}
	
	public String getSmall_category_name() {
		return small_category_name;
	}
	
	public void setSmall_category_name(String small_category_name) {
		this.small_category_name = small_category_name;
	}
	
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	
	

	
}
