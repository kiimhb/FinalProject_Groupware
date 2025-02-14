package com.spring.med.board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.board.model.BoardDAO;
import com.spring.med.board.domain.BoardVO;

@Service
public class BoardService_imple implements BoardService {
	
	@Autowired
	private BoardDAO dao;
	
	// === #04. 첨부파일 없는 글쓰기 
	@Override
	public int add(BoardVO boardvo) {
		int n = dao.add(boardvo); // 구분지어서 boardvo에 보냄
		return n;
	}

	// 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기
	@Override
	public List<BoardVO> boardListNoSearch() {
		List<BoardVO> boardList = dao.boardListNoSearch();
		return boardList;
	}

}
