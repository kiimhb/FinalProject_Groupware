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
			String mail_received_important = mvo.getMail_sent_important();
			
			//paraMap.put("fk_mail_sent_no", fk_mail_sent_no);
			
			paraMap.put("fk_member_userid", fk_member_userid);
			paraMap.put("mail_received_important", mail_received_important);
			
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

	
	
	// 받은 메일 리스트 보여주기	
	@Override
	public List<MailReceiveVO> selectMailReceiveList(Map<String, String> paraMap) {
		List<MailReceiveVO> mailReceiveList = mdao.selectMailReceiveList(paraMap);
		return mailReceiveList;
	}
	
	// 받은 메일 총 갯수 select 하기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		
		int n = mdao.getTotalCount(paraMap);
		
		return n;
		
	}
	
	
	// 보낸 메일 리스트 보여주기
	@Override
	public List<MailReceiveVO> selectMailSentList(Map<String, String> paraMap) {
		List<MailReceiveVO> mailSentList = mdao.selectMailSentList(paraMap);
		return mailSentList;
	}

	// 보낸메일 총 갯수 select 하기
	@Override
	public int getTotalCountSent(Map<String, String> paraMap) {
		int n = mdao.getTotalCountSent(paraMap);
		
		return n;
	}

	// 중요메일 유무 알아오기
	@Override
	public List<HashMap<String, String>> isImportantMail(String member_userid) {
		List<HashMap<String, String>> mailNoList = mdao.isImportantMail(member_userid);
		return mailNoList;
	}

	// 받은메일함 중요메일 insert 0->1(트랜잭션)
	//@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	@Override
	public int updateImportant(Map<String, String> paraMap) {
		
		int n = 0 , result = 0;
		
		n = mdao.updateImportant(paraMap);
		/*
		if(n==1) {						
			
			result = mdao.updateImportant2(paraMap);
		}
		*/
		return n;
		
	}

	// 받은메일함 중요메일 insert 1->0(트랜잭션)
	@Override
	//@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int updateImportantreturn(Map<String, String> paraMap) {
		
		int n = 0 , result = 0;
		
		n = mdao.updateImportantreturn(paraMap);
		/*
		if(n==1) {						
			
			result = mdao.updateImportantreturn2(paraMap);
		}
		*/
		return n;

	}

	// 받은메일함 체크한 메일 보관함 옮기기(트랜잭션)
	//@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	@Override
	public int sendMailStorage(List<Integer> mailNos, Map<String, String> paraMap) {
		
		int n = 0 , result = 0;
		
		n = mdao.sendMailStorage(mailNos, paraMap);
		/*
		if(n !=0) {						
			
			result = mdao.sendMailStorage2(mailNos);
		}
		*/
		return n;
	}

	// 받은메일함 체크한 메일 휴지통 옮기기(트랜잭션)
	//@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	@Override
	public int sendMailTrash(List<Integer> mailNos, Map<String, String> paraMap) {
		
		int n = 0 , result = 0;
		
		n = mdao.sendMailTrash(mailNos, paraMap);
		
		//System.out.println("처음거 1임?:" +n);
		/*
		if(n != 0) {						
			
			result = mdao.sendMailTrash2(mailNos);
		}
		*/
		return n;
	}

	// 보낸메일함 중요메일 유무 알아오기
	@Override
	public List<HashMap<String, String>> isImportantMailSent(String member_userid) {
		List<HashMap<String, String>> mailNoList = mdao.isImportantMailSent(member_userid);
		return mailNoList;
	}

	// 보낸메일함 중요메일 insert 0->1(트랜잭션)
	@Override
	//@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int updateImportantSent(Map<String, String> paraMap) {
		
		int n = 0 , result = 0;
		
		n = mdao.updateImportantSent(paraMap);
		/*
		if(n==1) {						
			
			result = mdao.updateImportantSent2(paraMap);
		}
		*/
		return n;
	}

	// 보낸메일함 중요메일 insert 1->0(트랜잭션)
	@Override
	//@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int updateImportantreturnSent(Map<String, String> paraMap) {

		int n = 0 , result = 0;
		
		n = mdao.updateImportantreturnSent(paraMap);
		/*
		if(n==1) {						
			
			result = mdao.updateImportantreturnSent2(paraMap);
		}
		*/
		return n;	
	
	}

	// 보낸메일함 체크한 메일 휴지통
	@Override
	//@Transactional(value="transactionManager_final_orauser4", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int sendMailTrashSent(List<Integer> mailNos, Map<String, String> paraMap) {
		int n = 0 , result = 0;
		
		n = mdao.sendMailTrashSent(mailNos, paraMap);
		
		//System.out.println("처음거 1임?:" +n);
		/*
		if(n != 0) {						
			
			result = mdao.sendMailTrashSent2(mailNos);
		}
		*/
		return n;
	}

	// 휴지통 총 메일함 가져오기
	/*
	@Override
	public int getTrashTotalCount(Map<String, String> paraMap) {
		int n = mdao.getTrashTotalCount(paraMap);
		
		return n;
	}
	 */
	// 휴지통 메일 리스트 select 해오기
	@Override
	public List<MailSentVO> selectMailTrashList(Map<String, String> paraMap) {
		
		List<MailSentVO> mailTrashList = mdao.selectMailTrashList(paraMap);
		return mailTrashList;
	}

	// 보관함 총 메일갯수 가져오기
	@Override
	public int getStorageTotalCount(Map<String, String> paraMap) {
		int n = mdao.getStorageTotalCount(paraMap);
		
		return n;
	}

	// 보관함 메일 리스트 select 해오기
	@Override
	public List<MailReceiveVO> selectMailStorageList(Map<String, String> paraMap) {
		List<MailReceiveVO> mailStorageList = mdao.selectMailStorageList(paraMap);
		return mailStorageList;
	}

	// 보낸메일 휴지통 메일 복구시키기
	@Override
	public int sentMailRestore(List<Integer> mailNos, Map<String, String> paraMap) {
			
		
		
		int n = mdao.sentMailRestore(mailNos, paraMap);

		
		return n;
	}

	// 보낸메일함 휴지통 총갯수 가져오기
	@Override
	public int getSentTrashTotalCount(Map<String, String> paraMap) {
		
		int n = mdao.getSentTrashTotalCount(paraMap);
		
		return n;
	}

	// 받은메일함 휴지통 총갯수 가져오기
	@Override
	public int getReceivedTrashTotalCount(Map<String, String> paraMap) {
		int n = mdao.getReceivedTrashTotalCount(paraMap);
		
		return n;
	}

	// 보낸메일함 휴지통 리스트
	@Override
	public List<MailSentVO> selectReceivedMailTrashList(Map<String, String> paraMap) {
		
		List<MailSentVO> mailReceivedTrashList = mdao.selectReceivedMailTrashList(paraMap);
		return mailReceivedTrashList;
	}

	// 받은메일 휴지통 메일 복구하기 1->0
	@Override
	public int receivedMailRestore(List<Integer> mailNos, Map<String, String> paraMap) {
		
		int n = mdao.receivedMailRestore(mailNos, paraMap);

		
		return n;
	}

	// 휴지통 보낸 메일 영구삭제하기
	@Override
	public int sentMailDelete(List<Integer> mailNos, Map<String, String> paraMap) {
		
		int n = mdao.sentMailDelete(mailNos, paraMap);
		return n;
	}

	// 휴지통 받은 메일 영구삭제하기
	@Override
	public int receivedMailDelete(List<Integer> mailNos, Map<String, String> paraMap) {
		int n = mdao.receivedMailDelete(mailNos, paraMap);
		return n;
	}

	
	
	
	
	
}
