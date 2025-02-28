package com.spring.med.board.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.board.domain.BoardVO;

@Repository
public class MyboardDAO_imple implements MyboardDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	@Override
    public int getMyBoardTotalCount(Map<String, String> paraMap) {
        return sqlsession.selectOne("minji_myboard.getMyTotalCount", paraMap);
    }

    @Override
    public List<BoardVO> getMyBoardList(Map<String, String> paraMap) {
        return sqlsession.selectList("minji_myboard.getMyBoardList", paraMap);
    }

    @Override
    public BoardVO getMyBoardView(Map<String, String> paraMap) {
        return sqlsession.selectOne("board.getMyBoardView", paraMap);
    }
	
	
}
