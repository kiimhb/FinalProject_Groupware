package com.spring.med.patient.domain;

public class PrescribeVO {

	private String fk_order_no;
	private String prescribe_name;
	private int prescribe_beforeafter;   
	private int prescribe_morning;       
	private int prescribe_afternoon;       
	private int prescribe_night;       
	private int prescribe_perday;
	public String getFk_order_no() {
		return fk_order_no;
	}
	public void setFk_order_no(String fk_order_no) {
		this.fk_order_no = fk_order_no;
	}
	public String getPrescribe_name() {
		return prescribe_name;
	}
	public void setPrescribe_name(String prescribe_name) {
		this.prescribe_name = prescribe_name;
	}
	public int getPrescribe_beforeafter() {
		return prescribe_beforeafter;
	}
	public void setPrescribe_beforeafter(int prescribe_beforeafter) {
		this.prescribe_beforeafter = prescribe_beforeafter;
	}
	public int getPrescribe_morning() {
		return prescribe_morning;
	}
	public void setPrescribe_morning(int prescribe_morning) {
		this.prescribe_morning = prescribe_morning;
	}
	public int getPrescribe_afternoon() {
		return prescribe_afternoon;
	}
	public void setPrescribe_afternoon(int prescribe_afternoon) {
		this.prescribe_afternoon = prescribe_afternoon;
	}
	public int getPrescribe_night() {
		return prescribe_night;
	}
	public void setPrescribe_night(int prescribe_night) {
		this.prescribe_night = prescribe_night;
	}
	public int getPrescribe_perday() {
		return prescribe_perday;
	}
	public void setPrescribe_perday(int prescribe_perday) {
		this.prescribe_perday = prescribe_perday;
	}
	

}
