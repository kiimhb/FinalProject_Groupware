package com.spring.med.order.domain;

public class CostVO {

	// 비용 T
	private String fk_order_no;			// 오더번호
	private String cost_item;			// 항목		
	private String cost_item_name;		// 상세항목명
	private String cost;				// 비용
	
	
	
	
	
	
	
	public String getFk_order_no() {	
		return fk_order_no;
	}
	public String getCost_item() {
		return cost_item;
	}
	public String getCost_item_name() {
		return cost_item_name;
	}
	public String getCost() {
		return cost;
	}
	public void setFk_order_no(String fk_order_no) {
		this.fk_order_no = fk_order_no;
	}
	public void setCost_item(String cost_item) {
		this.cost_item = cost_item;
	}
	public void setCost_item_name(String cost_item_name) {
		this.cost_item_name = cost_item_name;
	}
	public void setCost(String cost) {
		this.cost = cost;
	}

	
	
}
