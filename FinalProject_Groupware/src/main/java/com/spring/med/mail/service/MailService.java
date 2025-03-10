package com.spring.med.mail.service;

import java.util.List;
import java.util.Map;

import com.spring.med.mail.domain.MailReceiveVO;
import com.spring.med.mail.domain.MailSentVO;


public interface MailService {

	

	// 받은 메일 리스트 보여주기
	List<MailReceiveVO> selectMailReceiveList(String user_id);
	
	// 받은 메일 총 갯수 select 하기
	int getTotalCount(Map<String, String> paraMap);
	
	// 작성된 메일 발신메일 테이블에 insert 하기
	int insertMailWrite(MailSentVO mvo, String fk_member_userid);

	// 작성된 메일 발신메일 테이블에 insert 하기 with 파일첨부
	int insertMailWriteWithFile(MailSentVO mvo, String fk_member_userid);

	
}
