package com.spring.med.index.model;

import java.util.List;
import java.util.Map;

import com.spring.med.notice.domain.NoticeVO;

public interface IndexDAO {

	Map<String, String> StartRecord(String member_userid);

	Map<String, String> EndRecord(String member_userid);

	List<NoticeVO> notice_list(Map<String, Object> paraMap);

	int get_alarm_totalCount(Map<String, String> paraMap);

	List<Map<String, String>> get_alarm_view(String member_userid);

	int alarm_is_read_1(int alarm_no);

	List<Map<String, String>> patientList();

	List<Map<String, String>> approvalPendingList(String member_userid);

	

}
