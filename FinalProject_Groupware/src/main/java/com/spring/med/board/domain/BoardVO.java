package com.spring.med.board.domain;

import org.springframework.web.multipart.MultipartFile;

// === #02. VO 생성하기 
// 먼저, 오라클에서 tbl_board 테이블을 생성해야 한다.
public class BoardVO {

	private String board_no;          // 글번호 
	private String fk_member_userid;    // 사용자ID
	private String board_name;         // 글쓴이 
	private String board_subject;      // 글제목
	private String board_content;      // 글내용 
	private String board_pw;           // 글암호
	private String board_readCount;    // 글조회수
	private String board_regDate;      // 글쓴시간
	private String board_status;       // 글삭제여부   1:사용가능한 글,  0:삭제된글 
	
	// #109.참고
	private String previousseq;      // 이전글번호
	private String previoussubject;  // 이전글제목
	private String nextseq;          // 다음글번호
	private String nextsubject;      // 다음글제목
	
	// === #56. 댓글형 게시판을 위한 commentCount 필드 추가하기 
	//          먼저 tbl_board 테이블에 commentCount 라는 컬럼이 존재해야 한다.
	private String board_commentCount;     // 댓글수 
	
	// === #131. 답변글쓰기 게시판을 위한 필드 추가하기
    //     먼저, 오라클에서 tbl_comment 테이블과  tbl_board 테이블을 drop 한 이후에 
    //     tbl_board 테이블 및 tbl_comment 테이블을 재생성 한 이후에 아래처럼 해야 한다.
	private String board_groupno;
	/*  
	 	답변글쓰기에 있어서 그룹번호 
	    	원글(부모글)과 답변글은 동일한 groupno 를 가진다.
	    	답변글이 아닌 원글(부모글)인 경우 groupno 의 값은 groupno 컬럼의 최대값(max)+1 로 한다.
	    	 따라서 원글과 그에 대한 답글 게시물을 묶어주기 위한 컬럼
	*/
	
	private String fk_board_no;
	/*  
	 	fk_seq 컬럼은 절대로 foreign key가 아니다.!!!!!!
        fk_seq 컬럼은 자신의 글(답변글)에 있어서 
	    원글(부모글)이 누구인지에 대한 정보값이다.
	    답변글쓰기에 있어서 답변글이라면 fk_seq 컬럼의 값은 
	    원글(부모글)의 seq 컬럼의 값을 가지게 되며,
	    답변글이 아닌 원글일 경우 0 을 가지도록 한다.
	     따라서 원글이 누구인지를 참조하는 것
	     
	     원글이라면 0 값
	     답글이라면 ...?
	 */
	
	private String board_depthno;
	/*  
 		답변글쓰기에 있어서 답변글 이라면
     		원글(부모글)의 depthno + 1 을 가지게 되며,
     		답변글이 아닌 원글일 경우 0 을 가지도록 한다.
     		 원글은 들여쓰기가 없음(0), 답변글이라면 depthno + 1
     	 	 따라서 게시물 목록에서 답글게시물 들여쓰기 위함
	*/
	
	
	/*
	  === #147. 파일을 첨부하도록 VO 만들기
	  	  먼저, 오라클에서 tbl_board 테이블에 3개 컬럼(fileName, orgFilename, fileSize)을 추가한 다음에 아래의 작업을 한다.
	 */
	private MultipartFile attach;
	/*
	  	form 태그에서 type="file" 인 파일을 받아서 저장되는 필드이다. 
         	진짜파일 ==> WAS(톰캣) 디스크에 저장됨.
            	조심할것은 MultipartFile attach 는 오라클 데이터베이스 tbl_board 테이블의 컬럼이 아니다.  
        /myspring/src/main/webapp/WEB-INF/views/mycontent1/board/add.jsp 파일에서 
        input type="file" 인 name 의 이름(attach) 과 동일해야만 파일첨부가 가능해진다.!!!!!
	*/
	
	private String board_fileName;  	  // WAS(톰캣)에 저장될 파일명(2025020709291우파535243254235235234.png)                                       
	private String board_orgFilename;   // 진짜 파일명(강아지.png)  사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명 
	private String board_fileSize; 	  //파일크기
	

	public BoardVO() {}
	
	public BoardVO(String board_no, String fk_member_userid, String board_name, String board_subject, String board_content, String board_pw,
			String board_readCount, String board_regDate, String board_status) {
		this.board_no = board_no;
		this.fk_member_userid = fk_member_userid;
		this.board_name = board_name;
		this.board_subject = board_subject;
		this.board_content = board_content;
		this.board_pw = board_pw;
		this.board_readCount = board_readCount;
		this.board_regDate = board_regDate;
		this.board_status = board_status;
	}

	public String getBoard_no() {
		return board_no;
	}

	public void setBoard_no(String board_no) {
		this.board_no = board_no;
	}

	public String getFk_member_userid() {
		return fk_member_userid;
	}

	public void setFk_member_userid(String fk_member_userid) {
		this.fk_member_userid = fk_member_userid;
	}

	public String getBoard_name() {
		return board_name;
	}

	public void setBoard_name(String board_name) {
		this.board_name = board_name;
	}

	public String getBoard_subject() {
		return board_subject;
	}

	public void setBoard_subject(String board_subject) {
		this.board_subject = board_subject;
	}

	public String getBoard_content() {
		return board_content;
	}

	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}

	public String getBoard_pw() {
		return board_pw;
	}

	public void setBoard_pw(String board_pw) {
		this.board_pw = board_pw;
	}

	public String getBoard_readCount() {
		return board_readCount;
	}

	public void setBoard_readCount(String board_readCount) {
		this.board_readCount = board_readCount;
	}

	public String getBoard_regDate() {
		return board_regDate;
	}

	public void setBoard_regDate(String board_regDate) {
		this.board_regDate = board_regDate;
	}

	public String getBoard_status() {
		return board_status;
	}

	public void setBoard_status(String board_status) {
		this.board_status = board_status;
	}

	public String getPreviousseq() {
		return previousseq;
	}

	public void setPreviousseq(String previousseq) {
		this.previousseq = previousseq;
	}

	public String getPrevioussubject() {
		return previoussubject;
	}

	public void setPrevioussubject(String previoussubject) {
		this.previoussubject = previoussubject;
	}

	public String getNextseq() {
		return nextseq;
	}

	public void setNextseq(String nextseq) {
		this.nextseq = nextseq;
	}

	public String getNextsubject() {
		return nextsubject;
	}

	public void setNextsubject(String nextsubject) {
		this.nextsubject = nextsubject;
	}

	public String getBoard_commentCount() {
		return board_commentCount;
	}

	public void setBoard_commentCount(String board_commentCount) {
		this.board_commentCount = board_commentCount;
	}

	public String getBoard_groupno() {
		return board_groupno;
	}

	public void setBoard_groupno(String board_groupno) {
		this.board_groupno = board_groupno;
	}

	public String getFk_board_no() {
		return fk_board_no;
	}

	public void setFk_board_no(String fk_board_no) {
		this.fk_board_no = fk_board_no;
	}

	public String getBoard_depthno() {
		return board_depthno;
	}

	public void setBoard_depthno(String board_depthno) {
		this.board_depthno = board_depthno;
	}

	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}

	public String getBoard_fileName() {
		return board_fileName;
	}

	public void setBoard_fileName(String board_fileName) {
		this.board_fileName = board_fileName;
	}

	public String getBoard_orgFilename() {
		return board_orgFilename;
	}

	public void setBoard_orgFilename(String board_orgFilename) {
		this.board_orgFilename = board_orgFilename;
	}

	public String getBoard_fileSize() {
		return board_fileSize;
	}

	public void setBoard_fileSize(String board_fileSize) {
		this.board_fileSize = board_fileSize;
	}


	
	
	
}

