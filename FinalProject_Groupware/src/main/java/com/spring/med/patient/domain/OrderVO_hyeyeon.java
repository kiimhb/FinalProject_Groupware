package com.spring.med.patient.domain;

public class OrderVO_hyeyeon {
	
	
	private int order_no;
	private int fk_member_userid;
	private int fk_patient_no;
	private String order_desease_name;
	private String  order_surgeryType_name;
	private int order_ishosp;
	private int order_howlonghosp;
	private int order_issurg;
	private String order_symptom_detail;
	private int order_status;
 
	public int getOrder_no() {
		return order_no;
	}
	public void setOrder_no(int order_no) {
		this.order_no = order_no;
	}
	public int getFk_member_userid() {
		return fk_member_userid;
	}
	public void setFk_member_userid(int fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	public int getFk_patient_no() {
		return fk_patient_no;
	}
	public void setFk_patient_no(int fk_patient_no) {
		this.fk_patient_no = fk_patient_no;
	}
	public String getOrder_desease_name() {
		return order_desease_name;
	}
	public void setOrder_desease_name(String order_desease_name) {
		this.order_desease_name = order_desease_name;
	}
	public String getOrder_surgeryType_name() {
		return order_surgeryType_name;
	}
	public void setOrder_surgeryType_name(String order_surgeryType_name) {
		this.order_surgeryType_name = order_surgeryType_name;
	}
	public int getOrder_ishosp() {
		return order_ishosp;
	}
	public void setOrder_ishosp(int order_ishosp) {
		this.order_ishosp = order_ishosp;
	}
	public int getOrder_howlonghosp() {
		return order_howlonghosp;
	}
	public void setOrder_howlonghosp(int order_howlonghosp) {
		this.order_howlonghosp = order_howlonghosp;
	}
	public int getOrder_issurg() {
		return order_issurg;
	}
	public void setOrder_issurg(int order_issurg) {
		this.order_issurg = order_issurg;
	}
	public String getOrder_symptom_detail() {
		return order_symptom_detail;
	}
	public void setOrder_symptom_detail(String order_symptom_detail) {
		this.order_symptom_detail = order_symptom_detail;
	}
	public int getOrder_status() {
		return order_status;
	}
	public void setOrder_status(int order_status) {
		this.order_status = order_status;
	}
 
	 
}
