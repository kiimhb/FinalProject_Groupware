package com.spring.med.index.service;

import java.util.List;
import java.util.Map;

import com.spring.med.notice.domain.NoticeVO;

public interface IndexService {

//	출퇴근 현황 = 출근
	Map<String, String> getTodayStartRecord(String member_userid);

//	출퇴근 현황 = 퇴근
	Map<String, String> getTodayEndRecord(String member_userid);
	
//	공지사항
	List<NoticeVO> notice_list(Map<String, Object> paraMap);

//	알람 총개수
	int get_alarm_totalCount(Map<String, String> paraMap);

//	알람 가져오기
	List<Map<String, String>> get_alarm_view(String member_userid);



	
}
