package com.spring.med.index.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

	// 알람 총개수
	@Override
	public int get_alarm_totalCount(Map<String, String> paraMap) {
		
		int member_userid = Integer.parseInt(paraMap.get("member_userid"));
		paraMap.put("member_userid", String.valueOf(member_userid));
		
		int n = indexdao.get_alarm_totalCount(paraMap);
		return n;
	}

	//알람 가져오기
	@Override
	public List<Map<String, String>> get_alarm_view(String member_userid) {
		
		List<Map<String, String>> alarm_view = indexdao.get_alarm_view(member_userid);
		return alarm_view;
	}

	//알람 업데이트
	@Override
	public int alarm_is_read_1(int alarm_no) {
		int n = indexdao.alarm_is_read_1(alarm_no);
		return n;
	}

	//오늘 진료환자 목록
	@Override
	public List<Map<String, String>> patientList() {
		List<Map<String, String>> patientList = indexdao.patientList();
		return patientList;
	}

	//결재문서함
	@Override
	public List<Map<String, String>> approvalPendingList(String member_userid) {
		List<Map<String, String>> pendingList =  indexdao.approvalPendingList(member_userid);
		return pendingList;
	}


}
