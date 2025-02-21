package com.spring.med.board.domain;

import org.springframework.web.multipart.MultipartFile;

// === #57. 댓글용 VO 생성하기 ===
//     먼저, 오라클에서 tbl_comment 테이블을 생성한다.
//     또한 tbl_board 테이블에 commentCount 컬럼을 추가한다. ===== 
public class CommentVO {

	private String comment_no;        		// 댓글번호
	private String fk_member_userid;  	// 사용자ID
	private String comment_name;      		// 성명
	private String comment_content;   		// 댓글내용
	private String comment_regDate;    	// 작성일자
	private String comment_parentSeq;  	// 원게시물 글번호
	private String comment_status;     	// 글삭제여부
	
    // === #175. 댓글쓰기에 있어서 파일첨부가 있는 것 시작 === //
    // !!! 먼저, 오라클에서 tbl_board 테이블에 3개 컬럼(fileName, orgFilename, fileSize)을 추가한 다음에
    // 아래의 작업을 한다.
    private MultipartFile attach;
    /*
       form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 진짜파일 ==> WAS(톰캣) 디스크에 저장됨. 조심할것은
       MultipartFile attach 는 오라클 데이터베이스 tbl_comment 테이블의 컬럼이 아니다.
       /myspring/src/main/webapp/WEB-INF/views/mycontent1/board/view.jsp 파일에서 input
       type="file" 인 name 의 이름(#170 - attach) 과 동일해야만 파일첨부가 가능해진다.!!!!
    */
    private String comment_fileName; // WAS(톰캣)에 저장될 파일명(2025021109291535243254235235234.png)
    private String comment_orgFilename; // 진짜 파일명(강아지.png) // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명
    private String comment_fileSize; // 파일크기
    // === 댓글쓰기에 있어서 파일첨부가 있는 것 끝 === // 
    
    
	public String getComment_no() {
		return comment_no;
	}
	
	public void setComment_no(String comment_no) {
		this.comment_no = comment_no;
	}
	
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	
	public String getComment_name() {
		return comment_name;
	}
	
	public void setComment_name(String comment_name) {
		this.comment_name = comment_name;
	}
	
	public String getComment_content() {
		return comment_content;
	}
	
	public void setComment_content(String comment_content) {
		this.comment_content = comment_content;
	}
	
	public String getComment_regDate() {
		return comment_regDate;
	}
	
	public void setComment_regDate(String comment_regDate) {
		this.comment_regDate = comment_regDate;
	}
	
	public String getComment_parentSeq() {
		return comment_parentSeq;
	}
	
	public void setComment_parentSeq(String comment_parentSeq) {
		this.comment_parentSeq = comment_parentSeq;
	}
	
	public String getComment_status() {
		return comment_status;
	}
	
	public void setComment_status(String comment_status) {
		this.comment_status = comment_status;
	}
	
	public MultipartFile getAttach() {
		return attach;
	}
	
	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	
	public String getComment_fileName() {
		return comment_fileName;
	}
	
	public void setComment_fileName(String comment_fileName) {
		this.comment_fileName = comment_fileName;
	}
	
	public String getComment_orgFilename() {
		return comment_orgFilename;
	}
	
	public void setComment_orgFilename(String comment_orgFilename) {
		this.comment_orgFilename = comment_orgFilename;
	}
	
	public String getComment_fileSize() {
		return comment_fileSize;
	}
	
	public void setComment_fileSize(String comment_fileSize) {
		this.comment_fileSize = comment_fileSize;
	}

	
	
}
