package com.spring.med.board.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.domain.CommentVO;

// ==== #24. Repository(DAO) 선언 ====
@Repository
public class BoardDAO_imple implements BoardDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	
	// === #30. 파일첨부가 없는 글쓰기 ===
	@Override
	public int add(BoardVO boardvo) {
		int n = sqlsession.insert("minji_board.add", boardvo);
		return n;
	}


	// === #34. 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 ===
	@Override
	public List<BoardVO> boardListNoSearch() {
		List<BoardVO> boardList = sqlsession.selectList("minji_board.boardListNoSearch");
		return boardList;
	}


	// === #38. 글 1개 조회하기 === 
	@Override
	public BoardVO getView(Map<String, String> paraMap) {
		BoardVO boardvo = sqlsession.selectOne("minji_board.getView", paraMap);
		return boardvo;
	}

	// === #40. 글조회수 1증가 하기 ===
	@Override
	public int increase_readCount(String board_no) {
		int n = sqlsession.update("minji_board.increase_readCount", board_no);
		return n;
	}
	
	// === #49. 1개글 수정하기 === //
	@Override
	public int edit(BoardVO boardvo) {
		int n = sqlsession.update("minji_board.edit", boardvo);
		return n;
	}
	
	
	// === #165. 1개글 삭제할 때 먼저 첨부파일명을 알아오기 위한 것 === //
	@Override
	public Map<String, String> getView_delete(String board_no) {
		Map<String, String> boardmap = sqlsession.selectOne("minji_board.getView_delete", board_no);
		return boardmap;
	}

		
	// === #54. 1개글 삭제하기 === //
	@Override
	public int del(String board_no) {
		int n = sqlsession.delete("minji_board.del", board_no);
		return n;
	}

    // === #61.1  댓글쓰기(tbl_comment 테이블에 insert) === //
	@Override
	public int addComment(CommentVO commentvo) {
/*		
		System.out.println("getFk_member_userid" +commentvo.getFk_member_userid());
		System.out.println("getComment_name" +commentvo.getComment_name());
		System.out.println("getComment_content" +commentvo.getComment_content());
		System.out.println("getComment_regDate" +commentvo.getComment_regDate());
		System.out.println("getComment_parentSeq" +commentvo.getComment_parentSeq());
		System.out.println("getComment_status" +commentvo.getComment_status());
*/		
		int n = sqlsession.insert("minji_board.addComment", commentvo);
		return n;
	}

	// === #61.2  tbl_board 테이블에 commentCount 컬럼이 1증가(update) === //
	@Override
	public int updateCommentCount(String comment_parentSeq) {
		int n = sqlsession.update("minji_board.updateCommentCount", comment_parentSeq);
		return n;
	}


	// === #65. 원게시물에 딸린 댓글들을 조회해오기 === //
	@Override
	public List<CommentVO> getCommentList(String comment_parentSeq) {
		List<CommentVO> commentList = sqlsession.selectList("minji_board.getCommentList", comment_parentSeq);
		return commentList;
	}


	// === #70. 댓글 수정(Ajax 로 처리) === //
	@Override
	public int updateComment(Map<String, String> paraMap) {

		int n = sqlsession.update("minji_board.updateComment", paraMap);
		return n;
	}


	// === #74.1 댓글 삭제(Ajax 로 처리) === //
	@Override
	public int deleteComment(String comment_no) {
		int n = sqlsession.delete("minji_board.deleteComment", comment_no);
		return n;
	}


	// === #74.2 댓글삭제시 tbl_board 테이블에 commentCount 컬럼이 1감소(update) === //
	@Override
	public int updateCommentCount_decrease(String comment_parentSeq) {
		int n = sqlsession.update("minji_board.updateCommentCount_decrease", comment_parentSeq);
		return n;
	}


	// === #85. 페이징 처리를 안한 검색어가 있는 전체 글목록 보여주기 === //
	@Override
	public List<BoardVO> boardListSearch(Map<String, String> paraMap) {
		List<BoardVO> boardList = sqlsession.selectList("minji_board.boardListSearch", paraMap);
		return boardList;
	}


	// === #91. 검색어 입력시 자동글 완성하기 5 === //
	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = sqlsession.selectList("minji_board.wordSearchShow", paraMap);
		return wordList;
	}


	// === #97. 총 게시물 건수(totalCount) 구하기 --> 검색이 있을 때와 검색이 없을 때로 나뉜다. === //
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = sqlsession.selectOne("minji_board.getTotalCount", paraMap);
		return totalCount;
	}

	
	// === #100. 글목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.) === //
	@Override
	public List<BoardVO> boardListSearch_withPaging(Map<String, String> paraMap) {
		List<BoardVO> boardList = sqlsession.selectList("minji_board.boardListSearch_withPaging", paraMap);
		return boardList;
	}


	// === #120. 원게시물에 딸린 댓글내용들을 페이징 처리하기 === //
	@Override
	public List<CommentVO> getCommentList_Paging(Map<String, String> paraMap) {
		List<CommentVO> commentList = sqlsession.selectList("minji_board.getCommentList_Paging", paraMap);
		return commentList;
	}


	// === #.123 페이징 처리시 보여주는 순번을 나타내기 위한 것(몇 개인지) === //
	@Override
	public int getCommentTotalCount(String comment_parentSeq) {
		int totalCount = sqlsession.selectOne("minji_board.getCommentTotalCount", comment_parentSeq);
		return totalCount;
	}


	// === #.138 tbl_board 테이블에서 groupno 컬럼의 최대값 알아오기 === //
/*	
	@Override
	public int getGroupnoMax() {
		int maxgroupno = sqlsession.selectOne("minji_board.getGroupnoMax");
		return maxgroupno;
	}
*/
	@Override
	public int getBoard_groupnoMax() {
		int maxboard_groupno = sqlsession.selectOne("minji_board.getBoard_groupnoMax");
		return maxboard_groupno;
	}
	
	// === #154. 글쓰기(파일첨부가 있는 글쓰기) ===
	@Override
	public int add_withFile(BoardVO boardvo) {
		int n = sqlsession.insert("minji_board.add_withFile", boardvo);
		return n;
	}


	// === #182. 파일첨부가 되어진 댓글 1개에서 서버에 업로드 되어진 파일명과 오리지널파일명을 조회해주는 것
	@Override
	public CommentVO getCommentOne(String comment_no) {
		CommentVO commentvo = sqlsession.selectOne("minji_board.getCommentOne", comment_no);
		return commentvo;
	}





	
	/////////////////////////////////////////////////////////////////////////////////////////    즐겨찾기
	// 즐겨찾기 테이블에 insert(한 행 추가)
	@Override
	public void insertBookmark(Map<String, String> paraMap) {
		sqlsession.insert("minji_board.insertBookmark", paraMap);
	}


	// 즐겨찾기 해제
	@Override
	public void deleteBookmark(Map<String, String> paraMap) {
		sqlsession.delete("minji_board.deleteBookmark", paraMap);
		
	}


	// 즐겨찾기 중복 확인
	@Override
	public int checkBookmark(Map<String, String> paraMap) {
	    return sqlsession.selectOne("minji_board.checkBookmark", paraMap);
	}

	
	// 즐겨찾기 한 게시물 조회
	@Override
	public List<BoardVO> getBookmarkList(String member_userid) {
		return sqlsession.selectList("minji_board.getBookmarkList", member_userid);
	}

	// 검색 포함된 게시물 개수 조회 (페이징)
    @Override
    public int getBookmarkCountWithSearch(Map<String, Object> paraMap) {
        return sqlsession.selectOne("minji_board.getBookmarkCountWithSearch", paraMap);
    }

    // 검색 적용된 게시물 목록 조회 (페이징)
    @Override
    public List<BoardVO> getBookmarkListPagedWithSearch(Map<String, Object> paraMap) {
        return sqlsession.selectList("minji_board.getBookmarkListPagedWithSearch", paraMap);
    }

    // 처음 페이지 로딩
 	@Override
 	public List<HashMap<String, String>> selectBookmark(String member_userid) {
 		return sqlsession.selectList("minji_board.selectBookmark", member_userid);
 	}
    
    
    
	////////////////////////////////////////////////////////////////////////// 내가 쓴 글 조회 
    // 내가 쓴 글 조회
	@Override
	public List<BoardVO> getMyboard(Map<String, String> paraMap) {
		return sqlsession.selectList("minji_board.getMyboard", paraMap);
	}


	@Override
	public int getMyBoardCountWithSearch(Map<String, Object> paraMap) {
		return sqlsession.selectOne("minji_board.getMyBoardCountWithSearch", paraMap);
	}


	@Override
	public List<BoardVO> getMyboardPagedWithSearch(Map<String, Object> paraMap) {
		 return sqlsession.selectList("minji_board.getMyboardPagedWithSearch", paraMap);
	}


	



}
