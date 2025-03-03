package com.spring.med.index.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.notice.domain.NoticeVO;

@Repository
public class IndexDAO_imple implements IndexDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;


	@Override
	public Map<String, String> StartRecord(String member_userid) {
		Map<String, String> StartRecord = sqlsession.selectOne("index.StartRecord", member_userid);
		return StartRecord;
	}

	@Override
	public Map<String, String> EndRecord(String member_userid) {
		Map<String, String> EndRecord = sqlsession.selectOne("index.EndRecord", member_userid);
		return EndRecord;
	}

	@Override
	public List<NoticeVO> notice_list(Map<String, Object> paraMap) {
		List<NoticeVO> notice_list = sqlsession.selectList("index.notice_list", paraMap);
		return notice_list;
	}

}
