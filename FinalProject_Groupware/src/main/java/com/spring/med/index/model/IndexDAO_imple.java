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

	@Override
	public int get_alarm_totalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("index.get_alarm_totalCount", paraMap);
		return n;
	}

	@Override
	public List<Map<String, String>> get_alarm_view(String member_userid) {
		List<Map<String, String>> get_alarm_view = sqlsession.selectList("index.get_alarm_view", member_userid);
		return get_alarm_view;
	}

	@Override
	public int alarm_is_read_1(int alarm_no) {
		int n = sqlsession.update("index.alarm_is_read_1",alarm_no);
		return n;
	}

	@Override
	public List<Map<String, String>> patientList() {
		List<Map<String, String>> patientList = sqlsession.selectList("index.patientList");
		return patientList;
	}

	@Override
	public List<Map<String, String>> approvalPendingList(String member_userid) {
		List<Map<String, String>> PendingList = sqlsession.selectList("index.approvalPendingList",member_userid);
		return PendingList;
	}

}
