package com.spring.med.board.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.domain.CommentVO;

public interface BoardDAO {

	// 파일첨부가 없는 글쓰기
	int add(BoardVO boardvo);

	// 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 
	List<BoardVO> boardListNoSearch();

	// 글 1개 조회하기
	BoardVO getView(Map<String, String> paraMap);

	// 글조회수 1증가 하기
	int increase_readCount(String board_no);

	// 글 1개 수정하기
	int edit(BoardVO boardvo);

	// 글 1개 삭제하기
	Map<String, String> getView_delete(String board_no);  // 1개글 삭제할 때 먼저 사진이미지파일명 및 첨부파일명을 알아오기 위한 것
	int del(String board_no);

	////////////////////////////////////////////////////////////////////
	int addComment(CommentVO commentvo);       // 댓글쓰기(tbl_comment 테이블에 insert)
	int updateCommentCount(String comment_parentSeq);  // tbl_board 테이블에 commentCount 컬럼이 1증가(update)
//	int updateMemberPoint(Map<String, String> paraMap);  // tbl_member 테이블의 point 컬럼의 값을 50점을 증가(update)
    ////////////////////////////////////////////////////////////////////

	// 원게시물에 딸린 댓글들을 조회해오기
	List<CommentVO> getCommentList(String comment_parentSeq);

	// 댓글 수정(Ajax 로 처리)
	int updateComment(Map<String, String> paraMap);

	// 댓글 삭제(Ajax 로 처리)
	int deleteComment(String comment_no);

	// 댓글삭제시 tbl_board 테이블에 commentCount 컬럼이 1감소(update)
	int updateCommentCount_decrease(String comment_parentSeq);

	// CommonAop 클래스에서 사용하는 것으로 특정 회원에게 특정 점수만큼 포인트를 증가하기 위한 것 
//	void pointPlus(Map<String, String> paraMap);

	// 페이징 처리를 안한 검색어가 있는 전체 글목록 보여주기
	List<BoardVO> boardListSearch(Map<String, String> paraMap);

	// 검색어 입력시 자동글 완성하기
	List<String> wordSearchShow(Map<String, String> paraMap);

	// 총 게시물 건수(totalCount) 구하기 --> 검색이 있을 때와 검색이 없을 때로 나뉜다.
	int getTotalCount(Map<String, String> paraMap);

	// 글목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.)
	List<BoardVO> boardListSearch_withPaging(Map<String, String> paraMap);

	// 원게시물에 딸린 댓글내용들을 페이징 처리하기
	List<CommentVO> getCommentList_Paging(Map<String, String> paraMap);

	// 페이징 처리시 보여주는 순번을 나타내기 위한 것(몇 개인지)
	int getCommentTotalCount(String comment_parentSeq);

	// tbl_board 테이블에서 groupno 컬럼의 최대값 알아오기 
//	int getGroupnoMax();
	int getBoard_groupnoMax();

	// 글쓰기(파일첨부가 있는 글쓰기)
	int add_withFile(BoardVO boardvo);

	// 파일첨부가 되어진 댓글 1개에서 서버에 업로드 되어진 파일명과 오리지널파일명을 조회해주는 것
	CommentVO getCommentOne(String comment_no);

	
	
	
	//////////////////////////////////////////////////////////////////////  즐겨찾기
	// 즐겨찾기 테이블에 insert(한 행 추가)
	void insertBookmark(Map<String, String> paraMap);

	// 즐겨찾기 해제
	void deleteBookmark(Map<String, String> paraMap);

	// 즐겨찾기 중복 확인
	int checkBookmark(Map<String, String> paraMap);

	// 즐겨찾기 한 게시물 조회
	List<BoardVO> getBookmarkList(String member_userid);

	// 검색 포함된 게시물 개수 조회 (페이징)
	int getBookmarkCountWithSearch(Map<String, Object> paraMap);

	// 검색 적용된 게시물 목록 조회 (페이징)
	List<BoardVO> getBookmarkListPagedWithSearch(Map<String, Object> paraMap);

	
	
	
	////////////////////////////////////////////////////////////////////////// 내가 쓴 글 조회 
	// 내가 쓴 글 조회
	List<BoardVO> getMyboard(Map<String, String> paraMap);

	// 검색 포함된 게시물 개수 조회 (페이징)
	int getMyBoardCountWithSearch(Map<String, Object> paraMap);
	
	// 검색 적용된 게시물 목록 조회 (페이징)
	List<BoardVO> getMyboardPagedWithSearch(Map<String, Object> paraMap);

	// 처음 페이ㅣㅈ 로딩
	List<HashMap<String, String>> selectBookmark(String member_userid);


	


	
	
	
	
	
	
	
	
	
	

}
