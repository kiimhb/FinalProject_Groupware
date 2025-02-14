package com.spring.med.board.domain;

import org.springframework.web.multipart.MultipartFile;

// === #57. 댓글용 VO 생성하기 ===
//     먼저, 오라클에서 tbl_comment 테이블을 생성한다.
//     또한 tbl_board 테이블에 commentCount 컬럼을 추가한다. ===== 
public class CommentVO {

	private String memo_no;        		// 댓글번호
	private String fk_member_userid;  	// 사용자ID
	private String memo_name;      		// 성명
	private String memo_content;   		// 댓글내용
	private String memo_regDate;    	// 작성일자
	private String memo_parentSeq;  	// 원게시물 글번호
	private String memo_status;     	// 글삭제여부
	
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

	
	
	public String getMemo_no() {
		return memo_no;
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

	public void setMemo_no(String memo_no) {
		this.memo_no = memo_no;
	}
	
	public String getFk_member_userid() {
		return fk_member_userid;
	}
	
	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}
	
	public String getMemo_name() {
		return memo_name;
	}
	
	public void setMemo_name(String memo_name) {
		this.memo_name = memo_name;
	}
	
	public String getMemo_content() {
		return memo_content;
	}
	
	public void setMemo_content(String memo_content) {
		this.memo_content = memo_content;
	}
	
	public String getMemo_regDate() {
		return memo_regDate;
	}
	
	public void setMemo_regDate(String memo_regDate) {
		this.memo_regDate = memo_regDate;
	}
	
	public String getMemo_parentSeq() {
		return memo_parentSeq;
	}
	
	public void setMemo_parentSeq(String memo_parentSeq) {
		this.memo_parentSeq = memo_parentSeq;
	}
	
	public String getMemo_status() {
		return memo_status;
	}
	
	public void setMemo_status(String memo_status) {
		this.memo_status = memo_status;
	}

	
	
}
