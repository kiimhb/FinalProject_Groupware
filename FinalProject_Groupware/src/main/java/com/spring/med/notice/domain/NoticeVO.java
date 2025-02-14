package com.spring.med.notice.domain;

public class NoticeVO {
	 private int notice_no;
	 private int fk_member_userid;
	 private int notice_dept;
	 private String notice_title;
	 private String notice_content;
	 private int notice_fix;
	 private int notice_del;
	 private int notice_view_cnt;
	 
	public int getNotice_no() {
		return notice_no;
	}
	public void setNotice_no(int notice_no) {
		this.notice_no = notice_no;
	}
	public int getFk_member_userid() {
		return fk_member_userid;
	}
	public void setFk_member_userid(int fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	public int getNotice_dept() {
		return notice_dept;
	}
	public void setNotice_dept(int notice_dept) {
		this.notice_dept = notice_dept;
	}
	public String getNotice_title() {
		return notice_title;
	}
	public void setNotice_title(String notice_title) {
		this.notice_title = notice_title;
	}
	public String getNotice_content() {
		return notice_content;
	}
	public void setNotice_content(String notice_content) {
		this.notice_content = notice_content;
	}
	public int getNotice_fix() {
		return notice_fix;
	}
	public void setNotice_fix(int notice_fix) {
		this.notice_fix = notice_fix;
	}
	public int getNotice_del() {
		return notice_del;
	}
	public void setNotice_del(int notice_del) {
		this.notice_del = notice_del;
	}
	public int getNotice_view_cnt() {
		return notice_view_cnt;
	}
	public void setNotice_view_cnt(int notice_view_cnt) {
		this.notice_view_cnt = notice_view_cnt;
	}
	 
	 
}
