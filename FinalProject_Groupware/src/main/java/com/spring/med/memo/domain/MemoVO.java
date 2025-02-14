package com.spring.med.memo.domain;

public class MemoVO {

	private String memo_no;             	// 메모번호
	private String fk_member_userid;		// 사번
	private String memo_title;				// 메모제목
	private String memo_contents;			// 메모내용
	private String memo_importance;			// 중요메모여부(중요:1, 중요x:0)
	private String memo_deletestatus;		// 삭제여부
	private String memo_registerday;		// 생성날짜
	private String memo_trash_deleteday;	// 삭제된 날짜
	
	
	
	public String getMemo_no() {
		return memo_no;
	}
	
	public void setMemo_no(String memo_no) {
		this.memo_no = memo_no;
	}
	
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	
	public String getMemo_title() {
		return memo_title;
	}
	
	public void setMemo_title(String memo_title) {
		this.memo_title = memo_title;
	}
	
	public String getMemo_contents() {
		return memo_contents;
	}
	
	public void setMemo_contents(String memo_contents) {
		this.memo_contents = memo_contents;
	}
	
	public String getMemo_importance() {
		return memo_importance;
	}
	
	public void setMemo_importance(String memo_importance) {
		this.memo_importance = memo_importance;
	}
	
	public String getMemo_deletestatus() {
		return memo_deletestatus;
	}
	
	public void setMemo_deletestatus(String memo_deletestatus) {
		this.memo_deletestatus = memo_deletestatus;
	}
	
	public String getMemo_registerday() {
		return memo_registerday;
	}
	
	public void setMemo_registerday(String memo_registerday) {
		this.memo_registerday = memo_registerday;
	}
	
	public String getMemo_trash_deleteday() {
		return memo_trash_deleteday;
	}
	
	public void setMemo_trash_deleteday(String memo_trash_deleteday) {
		this.memo_trash_deleteday = memo_trash_deleteday;
	}
	
	
	
	
	
	
}



