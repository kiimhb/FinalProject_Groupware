package com.spring.med.index.model;

import java.util.List;
import java.util.Map;

import com.spring.med.notice.domain.NoticeVO;

public interface IndexDAO {

	Map<String, String> StartRecord(String member_userid);

	Map<String, String> EndRecord(String member_userid);

	List<NoticeVO> notice_list(Map<String, Object> paraMap);

}
