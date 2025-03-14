package com.spring.med.mail.model;

import java.util.HashMap;
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
	public List<MailReceiveVO> selectMailReceiveList(Map<String, String> paraMap) {
		List<MailReceiveVO> mailReceiveList = sqlsession.selectList("seonggon_mail.selectMailReceiveList", paraMap);
		
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


	// 보낸 메일 리스트 보여주기
	@Override
	public List<MailReceiveVO> selectMailSentList(Map<String, String> paraMap) {
		
		List<MailReceiveVO> mailSentList = sqlsession.selectList("seonggon_mail.selectMailSentList", paraMap);
		
		return mailSentList;
	}


	// 보낸 메일 총 갯수 select 하기
	@Override
	public int getTotalCountSent(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("seonggon_mail.getTotalCountSent", paraMap);
		
		return n;
	}


	// 중요메일 유무 알아오기
	@Override
	public List<HashMap<String, String>> isImportantMail(String member_userid) {
		
		List<HashMap<String, String>> mailNoList = sqlsession.selectList("seonggon_mail.isImportantMail", member_userid);
		return mailNoList;
	}


	// 받은메일함 중요메일 update 0->1 (트랜잭션)
	@Override
	public int updateImportant(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_mail.updateImportant", paraMap);
		
		return n;
		
	}

	// 중요메일 update 0->1 (트랜잭션)
	/*
	@Override
	public int updateImportant2(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_mail.updateImportant2", paraMap);
		
		return n;
	}
	*/


	// 받은 메일함 중요메일 update 1->0 (트랜잭션)
	@Override
	public int updateImportantreturn(Map<String, String> paraMap) {
		
		int n = sqlsession.update("seonggon_mail.updateImportantreturn", paraMap);
		
		return n;
	}
	
	// 중요메일 update 1->0 (트랜잭션)
	/*
	@Override
	public int updateImportantreturn2(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_mail.updateImportantreturn2", paraMap);
		
		return n;
	}
	*/

	// 받은메일함 체크한 메일 보관함 옮기기 (트랜잭션)
	@Override
	public int sendMailStorage(List<Integer> mailNos, Map<String, String> paraMap) {
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.sendMailStorage", paramMap);
		return n;
	}

	// 체크한 메일 보관함 옮기기 (트랜잭션)
	/*
	@Override
	public int sendMailStorage2(List<Integer> mailNos) {
		int n = sqlsession.update("seonggon_mail.sendMailStorage2", mailNos);
		return n;
	}
	*/

	// 받은메일함 체크한 메일 휴지통 옮기기(트랜잭션)
	@Override
	public int sendMailTrash(List<Integer> mailNos, Map<String, String> paraMap) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.sendMailTrash", paramMap);
		return n;
	}

	// 체크한 메일 휴지통 옮기기(트랜잭션)
	/*
	@Override
	public int sendMailTrash2(List<Integer> mailNos) {
		int n = sqlsession.update("seonggon_mail.sendMailTrash2", mailNos);
		
		System.out.println("맵퍼들어가니 : "+n);
		return n;
	}
	*/

	// 보낸메일함 중요메일 유무 알아오기
	@Override
	public List<HashMap<String, String>> isImportantMailSent(String member_userid) {
		List<HashMap<String, String>> mailNoList = sqlsession.selectList("seonggon_mail.isImportantMailSent", member_userid);
		return mailNoList;
	}

	
	// 보낸 메일함 중요메일 update 0->1 (트랜잭션)
	@Override
	public int updateImportantSent(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_mail.updateImportantSent", paraMap);
		
		return n;
	}

	
	// 보낸 메일함 중요메일 update 0->1 (트랜잭션)
	/*
	@Override
	public int updateImportantSent2(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_mail.updateImportantSent2", paraMap);
		
		return n;
	}
	*/

	// 보낸 메일함 중요메일 update 1->0 (트랜잭션)
	@Override
	public int updateImportantreturnSent(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_mail.updateImportantreturnSent", paraMap);
		
		return n;
	}


	// 보낸 메일함 중요메일 update 1->0 (트랜잭션)
	/*
	@Override
	public int updateImportantreturnSent2(Map<String, String> paraMap) {
		int n = sqlsession.update("seonggon_mail.updateImportantreturnSent2", paraMap);
		
		return n;
	}
	*/


	// 보낸메일함 체크한 메일 휴지통 (트랜잭션)
	@Override
	public int sendMailTrashSent(List<Integer> mailNos, Map<String, String> paraMap) {
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.sendMailTrashSent", paramMap);
		return n;
	}

	/*
	@Override
	public int sendMailTrashSent2(List<Integer> mailNos) {
		int n = sqlsession.update("seonggon_mail.sendMailTrashSent2", mailNos);
		return n;
	}
	*/

	// 휴지통 총 메일갯수 가져오기
	@Override
	public int getTrashTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("seonggon_mail.getTrashTotalCount", paraMap);
		
		return n;
	}

	// 휴지통 메일 리스트 select 해오기
	@Override
	public List<MailSentVO> selectMailTrashList(Map<String, String> paraMap) {
		
		List<MailSentVO> mailTrashList = sqlsession.selectList("seonggon_mail.selectMailTrashList", paraMap);
		
		return mailTrashList;
	}


	// 보관함 총 메일갯수 가져오기
	@Override
	public int getStorageTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("seonggon_mail.getStorageTotalCount", paraMap);
		
		return n;
	}


	// 보관함 메일 리스트 select 해오기
	@Override
	public List<MailReceiveVO> selectMailStorageList(Map<String, String> paraMap) {
		
		List<MailReceiveVO> mailStorageList = sqlsession.selectList("seonggon_mail.selectMailStorageList", paraMap);
		
		return mailStorageList;
	}


	// 보낸메일함 휴지통 메일 복구시키기
	@Override
	public int sentMailRestore(List<Integer> mailNos, Map<String, String> paraMap) {
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.sentMailRestore", paramMap);
		return n;
	}
	/*
	@Override
	public int sendMailRestoreReceived(List<Integer> mailNos, Map<String, String> paraMap) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.sendMailRestoreReceived", paramMap);
		return n;
	}
	*/

	// 보낸메일함 휴지통 총갯수 가져오기
	@Override
	public int getSentTrashTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("seonggon_mail.getSentTrashTotalCount", paraMap);
		return n;
	}

	// 받은메일함 휴지통 총갯수 가져오기
	@Override
	public int getReceivedTrashTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("seonggon_mail.getReceivedTrashTotalCount", paraMap);
		return n;
	}


	// 보낸메일함 휴지통 리스트
	@Override
	public List<MailSentVO> selectReceivedMailTrashList(Map<String, String> paraMap) {
		
		List<MailSentVO> mailReceivedTrashList = sqlsession.selectList("seonggon_mail.selectReceivedMailTrashList", paraMap);
		
		return mailReceivedTrashList;
	}


	// 받은메일 휴지통 메일 복구하기 1->0
	@Override
	public int receivedMailRestore(List<Integer> mailNos, Map<String, String> paraMap) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.receivedMailRestore", paramMap);
		return n;
	}


	// 휴지통 보낸메일 영구삭제하기
	@Override
	public int sentMailDelete(List<Integer> mailNos, Map<String, String> paraMap) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.sentMailDelete", paramMap);
		return n;
	}


	// 휴지통 받은 메일 영구삭제하기
	@Override
	public int receivedMailDelete(List<Integer> mailNos, Map<String, String> paraMap) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mailNos", mailNos);
		paramMap.putAll(paraMap);
		
		int n = sqlsession.update("seonggon_mail.receivedMailDelete", paramMap);
		return n;
	}


	// 보낸 메일 클릭하면 메일내용 보여주기
	@Override
	public Map<String, String> mailView(String mail_sent_no) {
		
		Map<String, String> sentMap = sqlsession.selectOne("seonggon_mail.mailView", mail_sent_no);
		
		return sentMap;
	}


	// 받은 메일 클릭하면 메일내용 보여주기
	@Override
	public Map<String, String> receivedMailView(String fk_mail_sent_no) {
		Map<String, String> receivedMap = sqlsession.selectOne("seonggon_mail.receivedMailView", fk_mail_sent_no);
		
		return receivedMap;
	}


	// 첨부파일 다운로드위한 1개메일 가져오기
	@Override
	public MailSentVO mailViewFile(String mail_sent_no) {
		MailSentVO mvo = sqlsession.selectOne("seonggon_mail.mailViewFile", mail_sent_no);
		
		return mvo;
	}
}
