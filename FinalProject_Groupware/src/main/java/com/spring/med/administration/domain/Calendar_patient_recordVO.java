package com.spring.med.administration.domain;

public class Calendar_patient_recordVO {

	// 환자 상세조회에서 사용할 캘린더 데이터 조회 내용이다. 
	
	// 진료관련
	private String order_no;
	private String order_createTime;
	private String order_desease_name;
	
	// 입원관련
	private String hospitalize_start_day;
	private String hospitalize_end_day;
	private String fk_hospitalizeroom_no;
	
	// 수술관련
	private String surgery_day;
	private String surgery_start_time;
	private String surgery_end_time;
	private String surgery_surgeryroom_name;
	
	
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
	public String getOrder_desease_name() {
		return order_desease_name;
	}
	public void setOrder_desease_name(String order_desease_name) {
		this.order_desease_name = order_desease_name;
	}
	public String getSurgery_surgeryroom_name() {
		return surgery_surgeryroom_name;
	}
	public void setSurgery_surgeryroom_name(String surgery_surgeryroom_name) {
		this.surgery_surgeryroom_name = surgery_surgeryroom_name;
	}
	public String getSurgery_end_time() {
		return surgery_end_time;
	}
	public void setSurgery_end_time(String surgery_end_time) {
		this.surgery_end_time = surgery_end_time;
	}
	public String getFk_hospitalizeroom_no() {
		return fk_hospitalizeroom_no;
	}
	public void setFk_hospitalizeroom_no(String fk_hospitalizeroom_no) {
		this.fk_hospitalizeroom_no = fk_hospitalizeroom_no;
	}

	
}
