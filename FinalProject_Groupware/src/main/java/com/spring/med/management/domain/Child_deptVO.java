package com.spring.med.management.domain;

public class Child_deptVO {
	
	private String child_dept_no;
	private String fk_parent_dept_no;
	private String child_dept_name;
	
	
	public String getChild_dept_no() {
		return child_dept_no;
	}
	public void setChild_dept_no(String child_dept_no) {
		this.child_dept_no = child_dept_no;
	}
	public String getFk_parent_dept_no() {
		return fk_parent_dept_no;
	}
	public void setFk_parent_dept_no(String fk_parent_dept_no) {
		this.fk_parent_dept_no = fk_parent_dept_no;
	}
	public String getChild_dept_name() {
		return child_dept_name;
	}
	public void setChild_dept_name(String child_dept_name) {
		this.child_dept_name = child_dept_name;
	}
	
	
}
