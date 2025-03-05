package com.spring.med.administration.domain;

public class Calendar_surgery_recordVO {

	private String surgery_no; // 
	private String surgery_surgeryroom_name;
	private String surgery_day;
	private String surgery_start_time;
	private String surgery_end_time;
	
	
	public String getSurgery_no() {
		return surgery_no;
	}
	public void setSurgery_no(String surgery_no) {
		this.surgery_no = surgery_no;
	}
	public String getSurgery_surgeryroom_name() {
		return surgery_surgeryroom_name;
	}
	public void setSurgery_surgeryroom_name(String surgery_surgeryroom_name) {
		this.surgery_surgeryroom_name = surgery_surgeryroom_name;
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
	public String getSurgery_end_time() {
		return surgery_end_time;
	}
	public void setSurgery_end_time(String surgery_end_time) {
		this.surgery_end_time = surgery_end_time;
	}

}
