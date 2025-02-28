package com.spring.med.board.service;

import java.util.List;
import java.util.Map;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.domain.CommentVO;

public interface BoardService {

	// 파일첨부가 없는 글쓰기
	int add(BoardVO boardvo);

	// 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기
	List<BoardVO> boardListNoSearch();

	// 글 조회수 증가와 함께 글 1개를 조회를 해오는 것
	BoardVO getView(Map<String, String> paraMap);

	// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
	BoardVO getView_no_increase_readCount(Map<String, String> paraMap);

	// 1개글 수정하기
	int edit(BoardVO boardvo);

	// 1개글 삭제하기
//	int del(String board_no);	// 첨부파일 및 사진이미지가 없는 경우의 글 삭제
	Map<String, String> getView_delete(String board_no);  // 1개글 삭제할 때 먼저 사진이미지파일명 및 첨부파일명을 알아오기 위한 것
	int del(Map<String, String> paraMap);  // 첨부파일 및 사진이미지가 있는 경우의 글 삭제

	// 댓글쓰기(Transaction 처리)
	int addComment(CommentVO commentvo);

	// 원게시물에 딸린 댓글들을 조회해오기
	List<CommentVO> getCommentList(String parentSeq);

	// 댓글 수정(Ajax 로 처리)
	int updateComment(Map<String, String> paraMap);

	// 댓글 삭제(Ajax 로 처리)
	int deleteComment(Map<String, String> paraMap);

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
	int getCommentTotalCount(String parentSeq);

	// 글쓰기(파일첨부가 있는 글쓰기)
	int add_withFile(BoardVO boardvo);

	// 파일첨부가 되어진 댓글 1개에서 서버에 업로드 되어진 파일명과 오리지널파일명을 조회해주는 것
	CommentVO getCommentOne(String comment_no);

	
	
	////////////////////////////////////////////////////////////////////////// 즐겨찾기
	
	// 즐겨찾기 테이블에 insert(한 행 추가)
	void insertBookmark(Map<String, String> paraMap);

	

	

	




	
	
	
	
	
	
	
	
	

}
