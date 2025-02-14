package com.spring.med.approval.domain;

//**** 지출결의서 VO **** //

public class ExpenseReportVO {

	// === Field === //
	private String expense_report_no;             // 지출결의서번호
	private String fk_draft_no;                   // 기안문서번호
	private String expense_report_date;           // 지출일자
	private String expense_report_detail;         // 지출내역
	private String expense_report_count;          // 수량
	private String expense_report_amount;         // 금액
	private String expense_report_total;          // 총금액
	private String expense_report_reason;         // 지출사유
	
	
	// === Method === //
	public String getExpense_report_no() {
		return expense_report_no;
	}
	public void setExpense_report_no(String expense_report_no) {
		this.expense_report_no = expense_report_no;
	}
	public String getFk_draft_no() {
		return fk_draft_no;
	}
	public void setFk_draft_no(String fk_draft_no) {
		this.fk_draft_no = fk_draft_no;
	}
	public String getExpense_report_date() {
		return expense_report_date;
	}
	public void setExpense_report_date(String expense_report_date) {
		this.expense_report_date = expense_report_date;
	}
	public String getExpense_report_detail() {
		return expense_report_detail;
	}
	public void setExpense_report_detail(String expense_report_detail) {
		this.expense_report_detail = expense_report_detail;
	}
	public String getExpense_report_count() {
		return expense_report_count;
	}
	public void setExpense_report_count(String expense_report_count) {
		this.expense_report_count = expense_report_count;
	}
	public String getExpense_report_amount() {
		return expense_report_amount;
	}
	public void setExpense_report_amount(String expense_report_amount) {
		this.expense_report_amount = expense_report_amount;
	}
	public String getExpense_report_total() {
		return expense_report_total;
	}
	public void setExpense_report_total(String expense_report_total) {
		this.expense_report_total = expense_report_total;
	}
	public String getExpense_report_reason() {
		return expense_report_reason;
	}
	public void setExpense_report_reason(String expense_report_reason) {
		this.expense_report_reason = expense_report_reason;
	}
	
	
}
