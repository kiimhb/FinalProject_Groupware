package com.spring.med.board.model;

import java.util.List;
import java.util.Map;

import com.spring.med.board.domain.BoardVO;

public interface MyboardDAO {
	
    int getMyBoardTotalCount(Map<String, String> paraMap);
    
    List<BoardVO> getMyBoardList(Map<String, String> paraMap);
    
	BoardVO getMyBoardView(Map<String, String> paraMap);
}

