package com.spring.med.surgery.domain;

public class SurgeryVO {

	 private int surgery_no;
	 private int  fk_order_no;
	 private String surgery_surgeryroom_name;
	 private String surgery_reserve_date;
	 private String surgery_day;
	 private String surgery_start_time;
	 private String surgery_end_time;
	 private String surgery_description;
	 private int surgery_status;
	 
	public int getSurgery_no() {
		return surgery_no;
	}
	public void setSurgery_no(int surgery_no) {
		this.surgery_no = surgery_no;
	}
	public int getFk_order_no() {
		return fk_order_no;
	}
	public void setFk_order_no(int fk_order_no) {
		this.fk_order_no = fk_order_no;
	}
	public String getSurgery_surgeryroom_name() {
		return surgery_surgeryroom_name;
	}
	public void setSurgery_surgeryroom_name(String surgery_surgeryroom_name) {
		this.surgery_surgeryroom_name = surgery_surgeryroom_name;
	}
	public String getSurgery_reserve_date() {
		return surgery_reserve_date;
	}
	public void setSurgery_reserve_date(String surgery_reserve_date) {
		this.surgery_reserve_date = surgery_reserve_date;
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
	public String getSurgery_description() {
		return surgery_description;
	}
	public void setSurgery_description(String surgery_description) {
		this.surgery_description = surgery_description;
	}
	public int getSurgery_status() {
		return surgery_status;
	}
	public void setSurgery_status(int surgery_status) {
		this.surgery_status = surgery_status;
	}
	 
	// toString() 오버라이드
    @Override
    public String toString() {
    	

    	if("1".equals(surgery_surgeryroom_name)) {
    		surgery_surgeryroom_name = "roomA";
    	}
    	else if("2".equals(surgery_surgeryroom_name)) {
			surgery_surgeryroom_name = "roomB";
		}
    	else if("3".equals(surgery_surgeryroom_name)) {
			surgery_surgeryroom_name = "roomC";
		}
		else if("4".equals(surgery_surgeryroom_name)) {
			surgery_surgeryroom_name = "roomD";
		}
    	
    	
        return "SurgeryVO{" +
                "fk_order_no='" + fk_order_no + '\'' +
                 "surgery_surgeryroom_name='" + surgery_surgeryroom_name + '\'' +
                ", surgery_reserve_date=" + surgery_reserve_date +
                ", surgery_day=" + surgery_day +
                ", surgery_start_time=" + surgery_start_time +
                ", surgery_end_time=" + surgery_end_time +
                ", surgery_description='" + surgery_description + '\'' +
                '}';
    }
	
}
