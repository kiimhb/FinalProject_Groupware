package com.spring.med.notice.domain;

import org.springframework.web.multipart.MultipartFile;

public class NoticeVO {
	 private int notice_no;
	 private int fk_member_userid;
	 private int notice_dept;
	 private String notice_title;
	 private String notice_content;
	 private int notice_fix;
	 private int notice_del;
	 private int notice_view_cnt;
	 private String notice_write_date;
	 
	 /*
	    파일을 첨부하도록 VO 수정하기
	    먼저, 오라클에서 tbl_board 테이블에 3개 컬럼(fileName, orgFilename, fileSize)을 추가한 다음에 아래의 작업을 한다.        
	*/
	private MultipartFile attach;
	/*
	    form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 
	       진짜파일 ==> WAS(톰캣) 디스크에 저장됨.
           조심할것은 MultipartFile attach 는 오라클 데이터베이스 tbl_board 테이블의 컬럼이 아니다.
        /myspring/src/main/webapp/WEB-INF/views/mycontent1/board/add.jsp 파일에서 input type="file" 인 name 의 이름(attach) 과 
        동일해야만 파일첨부가 가능해진다.!!!!           
	*/
	private String notice_fileName;     // WAS(톰캣)에 저장될 파일명(2025020709291535243254235235234.png)                                       
	private String notice_orgFilename;  // 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
	private String notice_fileSize;     // 파일크기
	 
	 
	 
	 // select 용
	 private String fk_child_dept_no;
	 
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
	
	
	public String getNotice_write_date() {
		return notice_write_date;
	}
	public void setNotice_write_date(String notice_write_date) {
		this.notice_write_date = notice_write_date;
	}
	public String getFk_child_dept_no() {
		return fk_child_dept_no;
	}
	public void setFk_child_dept_no(String fk_child_dept_no) {
		this.fk_child_dept_no = fk_child_dept_no;
	}
	public MultipartFile getAttach() {
		return attach;
	}
	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	public String getNotice_fileName() {
		return notice_fileName;
	}
	public void setNotice_fileName(String notice_fileName) {
		this.notice_fileName = notice_fileName;
	}
	public String getNotice_orgFilename() {
		return notice_orgFilename;
	}
	public void setNotice_orgFilename(String notice_orgFilename) {
		this.notice_orgFilename = notice_orgFilename;
	}
	public String getNotice_fileSize() {
		return notice_fileSize;
	}
	public void setNotice_fileSize(String notice_fileSize) {
		this.notice_fileSize = notice_fileSize;
	}
	
	
	
	 
	 
}
