package com.spring.med.board.domain;

public class MyboardVO {

	private String fk_member_userid;  	// 사용자ID
	private String fk_board_no;  		// 글번호
	
	
	
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	
	public String getFk_board_no() {
		return fk_board_no;
	}
	
	public void setFk_board_no(String fk_board_no) {
		this.fk_board_no = fk_board_no;
	}
	
	
}
