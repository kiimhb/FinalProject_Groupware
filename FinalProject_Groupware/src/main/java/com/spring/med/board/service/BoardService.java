package com.spring.med.board.service;

import java.util.List;

import com.spring.med.board.domain.BoardVO;

public interface BoardService {

	// 첨부파일 없는 글쓰기 
	int add(BoardVO boardvo);

	// 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기
	List<BoardVO> boardListNoSearch();

}
