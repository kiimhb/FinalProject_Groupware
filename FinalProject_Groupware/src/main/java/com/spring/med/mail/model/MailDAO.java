package com.spring.med.mail.model;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.spring.med.mail.domain.MailReceiveVO;
import com.spring.med.mail.domain.MailSentVO;

public interface MailDAO {

	

	// 받은 메일 리스트 보여주기
	List<MailReceiveVO> selectMailReceiveList(String user_id);
	
	// 받은 메일 총 갯수 select 하기
	int getTotalCount(Map<String, String> paraMap);
	
	// 작성된 메일 발신메일 테이블에 insert 하기 (트랜잭션)
	int insertMailWrite(MailSentVO mvo);

	// 작성된 메일 발신메일 테이블에 insert 하기 with 파일첨부 (트랜잭션)
	int insertMailWriteWithFile(MailSentVO mvo);
	
	// 작성된 메일 수신메일 테이블에 insert 하기 (트랜잭션)
	int insertMailReceive(Map<String, String> paraMap);



}
