package com.spring.med.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.model.BoardDAO;
import com.spring.med.board.model.MyboardDAO;

@Service
public class MyboardService_imple implements MyboardService {
	
	@Autowired
    private MyboardDAO dao;

    @Override
    public int getMyBoardTotalCount(Map<String, String> paraMap) {
        return dao.getMyBoardTotalCount(paraMap);
    }

    @Override
    public List<BoardVO> getMyBoardList(Map<String, String> paraMap) {
        return dao.getMyBoardList(paraMap);
    }

    @Override
    public BoardVO getMyBoardView(Map<String, String> paraMap) {
        return dao.getMyBoardView(paraMap);
    }
	
	
	
	
}
