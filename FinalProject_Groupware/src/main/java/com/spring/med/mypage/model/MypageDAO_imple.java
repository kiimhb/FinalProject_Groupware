package com.spring.med.mypage.model;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.med.management.domain.ManagementVO_ga;

@Repository
public class MypageDAO_imple implements MypageDAO {
	
	@Autowired
    private SqlSession sqlSession;

	@Override
	public int mypageEdit_update(ManagementVO_ga managementVO_ga) {
		int n = sqlSession.update("mypage.mypageEdit_update", managementVO_ga);
		return n;
	}

	@Override
	public ManagementVO_ga getView_mypageone(Map<String, String> paramMap) {
		ManagementVO_ga mypageone = sqlSession.selectOne("mypage.getView_mypageone", paramMap);
		return mypageone;
	}

}
