package com.spring.med.approval.domain;

//**** 출장신청서 VO **** //

public class BusinessTripVO {

	// === Field === //
	private String business_trip_no;           // 출장신청번호
	private String fk_draft_no;                // 기안문서번호
	private String business_trip_start;        // 출장시작일
	private String business_trip_end;          // 출장종료일
	private String business_trip_purpose;      // 출장목적
	private String business_trip_loc;          // 출장지
	
	
	// === Method === //
	public String getBusiness_trip_no() {
		return business_trip_no;
	}
	public void setBusiness_trip_no(String business_trip_no) {
		this.business_trip_no = business_trip_no;
	}
	public String getFk_draft_no() {
		return fk_draft_no;
	}
	public void setFk_draft_no(String fk_draft_no) {
		this.fk_draft_no = fk_draft_no;
	}
	public String getBusiness_trip_start() {
		return business_trip_start;
	}
	public void setBusiness_trip_start(String business_trip_start) {
		this.business_trip_start = business_trip_start;
	}
	public String getBusiness_trip_end() {
		return business_trip_end;
	}
	public void setBusiness_trip_end(String business_trip_end) {
		this.business_trip_end = business_trip_end;
	}
	public String getBusiness_trip_purpose() {
		return business_trip_purpose;
	}
	public void setBusiness_trip_purpose(String business_trip_purpose) {
		this.business_trip_purpose = business_trip_purpose;
	}
	public String getBusiness_trip_loc() {
		return business_trip_loc;
	}
	public void setBusiness_trip_loc(String business_trip_loc) {
		this.business_trip_loc = business_trip_loc;
	}
	
	
}
