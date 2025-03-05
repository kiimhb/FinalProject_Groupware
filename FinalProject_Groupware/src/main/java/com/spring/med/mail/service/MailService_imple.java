package com.spring.med.mail.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.med.common.FileManager;
import com.spring.med.mail.domain.MailReceiveVO;
import com.spring.med.mail.domain.MailSentVO;
import com.spring.med.mail.model.MailDAO;

@Service
public class MailService_imple implements MailService {



	@Autowired
	private MailDAO mdao;
	
	
	@Autowired   // Type 에 따라 알아서 Bean 을 주입해준다.
	private FileManager fileManager;
	
	
	// 받은 메일 리스트 보여주기	
	@Override
	public List<MailReceiveVO> selectMailReceiveList(String user_id) {
		List<MailReceiveVO> mailReceiveList = mdao.selectMailReceiveList(user_id);
		return mailReceiveList;
	}
	
	
	// 작성된 메일 발신메일 테이블에 insert 하기 (트랜잭션)
	@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	@Override
	public int insertMailWrite(MailSentVO mvo, String fk_member_userid) {
		
		int n = 0 , result = 0;
		n  = mdao.insertMailWrite(mvo);
		
		//System.out.println("트랜잭션 전 n값 : " + n);
		
		if(n==1) {
			//String fk_mail_sent_no = mvo.getMail_sent_no();
			Map<String, String> paraMap = new HashMap<>();
			
			//paraMap.put("fk_mail_sent_no", fk_mail_sent_no);
			paraMap.put("fk_member_userid", fk_member_userid);
			
			//System.out.println("트랜잭션 맵보여주기 : "+paraMap);
			
			result = mdao.insertMailReceive(paraMap);
		}
		return result;
	}

	// 작성된 메일 발신메일 테이블에 insert 하기 with 파일첨부 (트랜잭션)
	@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	@Override
	public int insertMailWriteWithFile(MailSentVO mvo, String fk_member_userid) {
		
		int n = 0 , result = 0;
		
		n  = mdao.insertMailWriteWithFile(mvo);
		
		if(n==1) {
			
			//String fk_mail_sent_no = mvo.getMail_sent_no();
			Map<String, String> paraMap = new HashMap<>();
			
			//paraMap.put("fk_mail_sent_no", fk_mail_sent_no);
			paraMap.put("fk_member_userid", fk_member_userid);
			

			
			result = mdao.insertMailReceive(paraMap);
		}
		return result;
	}
}
