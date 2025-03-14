package com.spring.med.administration.domain;

public class Calendar_patient_recordVO {

	// 환자 상세조회에서 사용할 캘린더 데이터 조회 내용이다. 
	
	// 진료관련
	private String order_no;
	private String order_createTime;
	private String patient_symptom;
	
	// 입원관련
	private String hospitalize_start_day;
	private String hospitalize_end_day;
	
	// 수술관련
	private String surgery_day;
	private String surgery_start_time;
	
	
	public String getOrder_no() {
		return order_no;
	}
	public void setOrder_no(String order_no) {
		this.order_no = order_no;
	}
	public String getOrder_createTime() {
		return order_createTime;
	}
	public void setOrder_createTime(String order_createTime) {
		this.order_createTime = order_createTime;
	}
	public String getHospitalize_start_day() {
		return hospitalize_start_day;
	}
	public void setHospitalize_start_day(String hospitalize_start_day) {
		this.hospitalize_start_day = hospitalize_start_day;
	}
	public String getHospitalize_end_day() {
		return hospitalize_end_day;
	}
	public void setHospitalize_end_day(String hospitalize_end_day) {
		this.hospitalize_end_day = hospitalize_end_day;
	}
	public String getSurgery_day() {
		return surgery_day;
	}
	public void setSurgery_day(String surgery_day) {
		this.surgery_day = surgery_day;
	}
	public String getSurgery_start_time() {
		return surgery_start_time;
	}
	public void setSurgery_start_time(String surgery_start_time) {
		this.surgery_start_time = surgery_start_time;
	}
	public String getPatient_symptom() {
		return patient_symptom;
	}
	public void setPatient_symptom(String patient_symptom) {
		this.patient_symptom = patient_symptom;
	}
	
	
	
	
}
