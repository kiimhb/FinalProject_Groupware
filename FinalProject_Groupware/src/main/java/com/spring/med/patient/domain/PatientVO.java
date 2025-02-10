package com.spring.med.patient.domain;

public class PatientVO {

	
	
	private String patient_no;				// 환자 번호
	private String fk_team_no;				// 담당 부서 번호
	private String patient_name;			// 이름	
	private String patient_jubun;			// 주민번호
	private String patient_gender;			// 성별
	private String patient_symptom;			// 접수 증상
	private String patient_status;			// 초진 재진
	private String patient_visitdate;		// 내원일
	private String patient_wating;			// 진료 대기
	
	
	
	
	
	
	
	
	public String getPatient_no() {
		return patient_no;
	}
	public void setPatient_no(String patient_no) {
		this.patient_no = patient_no;
	}
	public String getFk_team_no() {
		return fk_team_no;
	}
	public void setFk_team_no(String fk_team_no) {
		this.fk_team_no = fk_team_no;
	}
	public String getPatient_name() {
		return patient_name;
	}
	public void setPatient_name(String patient_name) {
		this.patient_name = patient_name;
	}
	public String getPatient_jubun() {
		return patient_jubun;
	}
	public void setPatient_jubun(String patient_jubun) {
		this.patient_jubun = patient_jubun;
	}
	public String getPatient_gender() {
		return patient_gender;
	}
	public void setPatient_gender(String patient_gender) {
		this.patient_gender = patient_gender;
	}
	public String getPatient_symptom() {
		return patient_symptom;
	}
	public void setPatient_symptom(String patient_symptom) {
		this.patient_symptom = patient_symptom;
	}
	public String getPatient_status() {
		return patient_status;
	}
	public void setPatient_status(String patient_status) {
		this.patient_status = patient_status;
	}
	public String getPatient_visitdate() {
		return patient_visitdate;
	}
	public void setPatient_visitdate(String patient_visitdate) {
		this.patient_visitdate = patient_visitdate;
	}
	public String getPatient_wating() {
		return patient_wating;
	}
	public void setPatient_wating(String patient_wating) {
		this.patient_wating = patient_wating;
	}
	
	
	
}
