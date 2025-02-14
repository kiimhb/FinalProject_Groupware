package com.spring.med.hospitalize.domain;

public class HospitalizeVO {
	
	private int hospitalize_no;
	private String fk_hospitalizeroom_no;
	private int fk_order_no;
	private String hospitalize_reserve_date;
	private String hospitalize_start_day;
	private String hospitalize_end_day;
	private int hospitalize_status;
	
	
	public int getHospitalize_no() {
		return hospitalize_no;
	}
	public void setHospitalize_no(int hospitalize_no) {
		this.hospitalize_no = hospitalize_no;
	}
	public String getFk_hospitalizeroom_no() {
		return fk_hospitalizeroom_no;
	}
	public void setFk_hospitalizeroom_no(String fk_hospitalizeroom_no) {
		this.fk_hospitalizeroom_no = fk_hospitalizeroom_no;
	}
	public int getFk_order_no() {
		return fk_order_no;
	}
	public void setFk_order_no(int fk_order_no) {
		this.fk_order_no = fk_order_no;
	}
	public String getHospitalize_reserve_date() {
		return hospitalize_reserve_date;
	}
	public void setHospitalize_reserve_date(String hospitalize_reserve_date) {
		this.hospitalize_reserve_date = hospitalize_reserve_date;
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
	public int getHospitalize_status() {
		return hospitalize_status;
	}
	public void setHospitalize_status(int hospitalize_status) {
		this.hospitalize_status = hospitalize_status;
	}
	
	

}
