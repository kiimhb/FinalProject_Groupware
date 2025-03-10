package com.spring.med.mail.domain;

public class MailReceiveVO {
	
	private String fk_mail_sent_no;					//메일번호
	private String fk_member_userid;				//수신자 사번
	private String mail_received_status;			//수신여부 (SHA-256 암호화 대상)
	private String mail_received_saved;				//보관여부(수신)
	private String mail_received_trashdate;			//휴지통 날짜(수신)
	private String mail_received_trashstatus;		//휴지통 여부(수신)
	private String mail_received_important;			//중요여부(수신)
	
	
	
	
	
	
	public String getFk_mail_sent_no() {
		return fk_mail_sent_no;
	}
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	public String getMail_received_status() {
		return mail_received_status;
	}
	public String getMail_received_saved() {
		return mail_received_saved;
	}
	public String getMail_received_trashdate() {
		return mail_received_trashdate;
	}
	public String getMail_received_trashstatus() {
		return mail_received_trashstatus;
	}
	public String getMail_received_important() {
		return mail_received_important;
	}
	public void setFk_mail_sent_no(String fk_mail_sent_no) {
		this.fk_mail_sent_no = fk_mail_sent_no;
	}
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	public void setMail_received_status(String mail_received_status) {
		this.mail_received_status = mail_received_status;
	}
	public void setMail_received_saved(String mail_received_saved) {
		this.mail_received_saved = mail_received_saved;
	}
	public void setMail_received_trashdate(String mail_received_trashdate) {
		this.mail_received_trashdate = mail_received_trashdate;
	}
	public void setMail_received_trashstatus(String mail_received_trashstatus) {
		this.mail_received_trashstatus = mail_received_trashstatus;
	}
	public void setMail_received_important(String mail_received_important) {
		this.mail_received_important = mail_received_important;
	}
	
}
