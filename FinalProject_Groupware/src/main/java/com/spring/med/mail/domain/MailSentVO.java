package com.spring.med.mail.domain;

import org.springframework.web.multipart.MultipartFile;

public class MailSentVO {

	private String mail_sent_no;				//메일번호
	private String fk_member_userid;			//발신자사번
	private String mail_title;					//제목
	private String mail_sent_content;			//내용
	private String mail_sent_trashdate;			//휴지통 날짜 (발신)
	private String mail_sent_trashstatus;		//휴지통여부(발신)
	private String mail_sent_important;			//중요 여부(발신)
	private String mail_sent_senddate;			//발신일자
	private String mail_sent_file;				//첨부파일명
	private String mail_sent_file_origin;		//원본파일명
	private String mail_sent_filesize;			//파일사이즈
	
	
	
	private MultipartFile attach;
	/*
	    form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 
	       진짜파일 ==> WAS(톰캣) 디스크에 저장됨.
              조심할것은 MultipartFile attach 는 오라클 데이터베이스 tbl_board 테이블의 컬럼이 아니다.
        /myspring/src/main/webapp/WEB-INF/views/mycontent1/board/add.jsp 파일에서 input type="file" 인 name 의 이름(attach) 과 
         동일해야만 파일첨부가 가능해진다.!!!!           
	 */
	private String fileName;     // WAS(톰캣)에 저장될 파일명(2025020709291535243254235235234.png)                                       
	private String orgFilename;  // 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
	private String fileSize;     // 파일크기
	

	
	
	
	public MultipartFile getAttach() {
		return attach;
	}
	public String getFileName() {
		return fileName;
	}
	public String getOrgFilename() {
		return orgFilename;
	}
	public String getFileSize() {
		return fileSize;
	}
	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public void setOrgFilename(String orgFilename) {
		this.orgFilename = orgFilename;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getMail_sent_no() {
		return mail_sent_no;
	}
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	public String getMail_title() {
		return mail_title;
	}
	public String getMail_sent_content() {
		return mail_sent_content;
	}
	public String getMail_sent_trashdate() {
		return mail_sent_trashdate;
	}
	public String getMail_sent_trashstatus() {
		return mail_sent_trashstatus;
	}
	public String getMail_sent_important() {
		return mail_sent_important;
	}
	public String getMail_sent_senddate() {
		return mail_sent_senddate;
	}
	public String getMail_sent_file() {
		return mail_sent_file;
	}
	public String getMail_sent_file_origin() {
		return mail_sent_file_origin;
	}
	public String getMail_sent_filesize() {
		return mail_sent_filesize;
	}
	public void setMail_sent_no(String mail_sent_no) {
		this.mail_sent_no = mail_sent_no;
	}
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	public void setMail_title(String mail_title) {
		this.mail_title = mail_title;
	}
	public void setMail_sent_content(String mail_sent_content) {
		this.mail_sent_content = mail_sent_content;
	}
	public void setMail_sent_trashdate(String mail_sent_trashdate) {
		this.mail_sent_trashdate = mail_sent_trashdate;
	}
	public void setMail_sent_trashstatus(String mail_sent_trashstatus) {
		this.mail_sent_trashstatus = mail_sent_trashstatus;
	}
	public void setMail_sent_important(String mail_sent_important) {
		this.mail_sent_important = mail_sent_important;
	}
	public void setMail_sent_senddate(String mail_sent_senddate) {
		this.mail_sent_senddate = mail_sent_senddate;
	}
	public void setMail_sent_file(String mail_sent_file) {
		this.mail_sent_file = mail_sent_file;
	}
	public void setMail_sent_file_origin(String mail_sent_file_origin) {
		this.mail_sent_file_origin = mail_sent_file_origin;
	}
	public void setMail_sent_filesize(String mail_sent_filesize) {
		this.mail_sent_filesize = mail_sent_filesize;
	}
	
	
	
	
}
