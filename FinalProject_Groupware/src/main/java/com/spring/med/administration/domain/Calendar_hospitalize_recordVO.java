package com.spring.med.administration.domain;

public class Calendar_hospitalize_recordVO {

	private String hospitalize_no; // 입원번호
	private String fk_hospitalizeroom_no; // 입원실호수
	private String hospitalize_start_day; // 입원 시작일
	private String hospitalize_end_day;   // 퇴원일
	private String patient_name;
	
	public String getHospitalize_no() {
		return hospitalize_no;
	}
	public void setHospitalize_no(String hospitalize_no) {
		this.hospitalize_no = hospitalize_no;
	}
	public String getFk_hospitalizeroom_no() {
		return fk_hospitalizeroom_no;
	}
	public void setFk_hospitalizeroom_no(String fk_hospitalizeroom_no) {
		this.fk_hospitalizeroom_no = fk_hospitalizeroom_no;
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
	public String getPatient_name() {
		return patient_name;
	}
	public void setPatient_name(String patient_name) {
		this.patient_name = patient_name;
	}

	
	
}
