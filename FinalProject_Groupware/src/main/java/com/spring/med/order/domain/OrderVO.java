package com.spring.med.order.domain;

public class OrderVO {
	
	// 오더T
	private String order_no;					// 오더번호
	private String fk_member_userid;			// 의사사번
	private String fk_patient_no;				// 환자번호
	private String fk_desease_no;				// 질병번호
	private String fk_surgeryType_no;			// 수술번호
	private String order_ishosp;				// 입원여부
	private String order_howlonghosp;			// 총 입원일
	private String order_issurg;				// 수술여부
	private String order_symptom_detail;		// 상세증상
	
	// 약T
	private String medicine_no;					// 약 번호
	private String medicine_name;				// 약 이름
	
	// 약 처방 T
	private String fk_order_no;					// 오더번호
	private String prescribe_name;				// 약 번호
	private String prescribe_beforeafter;		// 복용시간
	private String prescribe_morning;			// 아침
	private String prescribe_afternoon;			// 점심
	private String prescribe_night;				// 저녁
	private String prescribe_perday;			// 복용일자
	

	// 수술종류 T
	private String surgeryType_no;				// 수술번호
	private String surgeryType_name;			// 수술명
	
	// 질병 T
	private String desease_no;					// 질병번호
	private String desease_name;				// 질병이름
	
	
	
	
	
	
	
	
	public String getOrder_no() {
		return order_no;
	}
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	public String getFk_patient_no() {
		return fk_patient_no;
	}
	public String getFk_desease_no() {
		return fk_desease_no;
	}
	public String getFk_surgeryType_no() {
		return fk_surgeryType_no;
	}
	public String getOrder_ishosp() {
		return order_ishosp;
	}
	public String getOrder_howlonghosp() {
		return order_howlonghosp;
	}
	public String getOrder_issurg() {
		return order_issurg;
	}
	public String getOrder_symptom_detail() {
		return order_symptom_detail;
	}
	public String getMedicine_no() {
		return medicine_no;
	}
	public String getMedicine_name() {
		return medicine_name;
	}
	public String getFk_order_no() {
		return fk_order_no;
	}
	public String getSurgeryType_no() {
		return surgeryType_no;
	}
	public String getSurgeryType_name() {
		return surgeryType_name;
	}
	public String getDesease_no() {
		return desease_no;
	}
	public String getDesease_name() {
		return desease_name;
	}
	public void setOrder_no(String order_no) {
		this.order_no = order_no;
	}
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	public void setFk_patient_no(String fk_patient_no) {
		this.fk_patient_no = fk_patient_no;
	}
	public void setFk_desease_no(String fk_desease_no) {
		this.fk_desease_no = fk_desease_no;
	}
	public void setFk_surgeryType_no(String fk_surgeryType_no) {
		this.fk_surgeryType_no = fk_surgeryType_no;
	}
	public void setOrder_ishosp(String order_ishosp) {
		this.order_ishosp = order_ishosp;
	}
	public void setOrder_howlonghosp(String order_howlonghosp) {
		this.order_howlonghosp = order_howlonghosp;
	}
	public void setOrder_issurg(String order_issurg) {
		this.order_issurg = order_issurg;
	}
	public void setOrder_symptom_detail(String order_symptom_detail) {
		this.order_symptom_detail = order_symptom_detail;
	}
	public void setMedicine_no(String medicine_no) {
		this.medicine_no = medicine_no;
	}
	public void setMedicine_name(String medicine_name) {
		this.medicine_name = medicine_name;
	}
	public void setFk_order_no(String fk_order_no) {
		this.fk_order_no = fk_order_no;
	}
	public void setSurgeryType_no(String surgeryType_no) {
		this.surgeryType_no = surgeryType_no;
	}
	public void setSurgeryType_name(String surgeryType_name) {
		this.surgeryType_name = surgeryType_name;
	}
	public void setDesease_no(String desease_no) {
		this.desease_no = desease_no;
	}
	public void setDesease_name(String desease_name) {
		this.desease_name = desease_name;
	}
	
	
	public String getPrescribe_name() {
		return prescribe_name;
	}
	public String getPrescribe_beforeafter() {
		return prescribe_beforeafter;
	}
	public String getPrescribe_morning() {
		return prescribe_morning;
	}
	public String getPrescribe_afternoon() {
		return prescribe_afternoon;
	}
	public String getPrescribe_night() {
		return prescribe_night;
	}
	public String getPrescribe_perday() {
		return prescribe_perday;
	}
	public void setPrescribe_name(String prescribe_name) {
		this.prescribe_name = prescribe_name;
	}
	public void setPrescribe_beforeafter(String prescribe_beforeafter) {
		this.prescribe_beforeafter = prescribe_beforeafter;
	}
	public void setPrescribe_morning(String prescribe_morning) {
		this.prescribe_morning = prescribe_morning;
	}
	public void setPrescribe_afternoon(String prescribe_afternoon) {
		this.prescribe_afternoon = prescribe_afternoon;
	}
	public void setPrescribe_night(String prescribe_night) {
		this.prescribe_night = prescribe_night;
	}
	public void setPrescribe_perday(String prescribe_perday) {
		this.prescribe_perday = prescribe_perday;
	}
	


	
	
	
	
	
	
	
	
	
	
}
