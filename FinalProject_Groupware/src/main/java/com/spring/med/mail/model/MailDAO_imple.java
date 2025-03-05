package com.spring.med.mail.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.mail.domain.MailReceiveVO;
import com.spring.med.mail.domain.MailSentVO;

@Repository
public class MailDAO_imple implements MailDAO {

	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;


	// 받은 메일 리스트 보여주기
	@Override
	public List<MailReceiveVO> selectMailReceiveList(String user_id) {
		List<MailReceiveVO> mailReceiveList = sqlsession.selectList("seonggon_mail.selectMailReceiveList", user_id);
		
		return mailReceiveList;
	}

	
	// 작성된 메일 발신메일 테이블에 insert 하기 (트랜잭션)
	@Override
	public int insertMailWrite(MailSentVO mvo) {
		int n = sqlsession.insert("seonggon_mail.insertMailWrite", mvo);
		
		return n;
	}

	// 작성된 메일 발신메일 테이블에 insert 하기 with 파일첨부 (트랜잭션)
	@Override
	public int insertMailWriteWithFile(MailSentVO mvo) {
		int n = sqlsession.insert("seonggon_mail.insertMailWriteWithFile", mvo);
		
		return n;
	}

	// 작성된 메일 수신메일 테이블에 insert 하기 (트랜잭션)
	@Override
	public int insertMailReceive(Map<String, String> paraMap) {
		int n = sqlsession.insert("seonggon_mail.insertMailReceive", paraMap);
		
		return n;
	}


	// 받은 메일 총 갯수 select 하기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		
		int n = sqlsession.selectOne("seonggon_mail.getTotalCount", paraMap);
		
		return n;
	}
}
