package com.spring.med.board.service;

import java.util.List;
import java.util.Map;

import com.spring.med.board.domain.BoardVO;

public interface MyboardService {
	
    int getMyBoardTotalCount(Map<String, String> paraMap);  			// 내가 쓴 글 개수 가져오기
    
    List<BoardVO> getMyBoardList(Map<String, String> paraMap);  // 내가 쓴 글 목록 가져오기 (페이징 적용)

	BoardVO getMyBoardView(Map<String, String> paraMap);		// 내가 쓴 1개의 글 조회

}
