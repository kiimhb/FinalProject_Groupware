package com.spring.med.memo.model;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.med.memo.domain.MemoVO;

@Repository
public class MemoDAO_imple implements MemoDAO{

	@Autowired
    private SqlSession sqlSession;

    @Override
    public List<MemoVO> selectAllMemo() {
        return sqlSession.selectList("minji_memo.selectAllMemo");
    }
}