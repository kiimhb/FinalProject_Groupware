package com.spring.med.board.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.board.domain.BoardVO;

@Repository
public class BoardDAO_imple implements BoardDAO  {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// === #05. 파일첨부가 없는 글쓰기 ===
	@Override
	public int add(BoardVO boardvo) {
		int n = sqlsession.insert("board.add", boardvo);
		return n;
	}

	// 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 
	@Override
	public List<BoardVO> boardListNoSearch() {
		List<BoardVO> boardList = sqlsession.selectList("board.boardListNoSearch");
		return boardList;
	}

}
