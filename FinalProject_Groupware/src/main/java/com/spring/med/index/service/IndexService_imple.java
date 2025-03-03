package com.spring.med.index.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.attendance.model.AttendanceRecordDAO;
import com.spring.med.index.model.IndexDAO;
import com.spring.med.notice.domain.NoticeVO;

@Service
public class IndexService_imple implements IndexService {

	@Autowired
	IndexDAO indexdao;

	// 출근 기록 List
	@Override
	public Map<String, String> getTodayStartRecord(String member_userid) {
		Map<String, String> StartRecord = indexdao.StartRecord(member_userid);
		return StartRecord;
	}

	// 퇴근 기록 List
	@Override
	public Map<String, String> getTodayEndRecord(String member_userid) {
		Map<String, String> EndRecord = indexdao.EndRecord(member_userid);
		return EndRecord;
	}

	// 부서별 공지사항 목록
	@Override
	public List<NoticeVO> notice_list(Map<String, Object> paraMap) {
		List<NoticeVO> notice_list = indexdao.notice_list(paraMap);
		return notice_list;
	}

}
