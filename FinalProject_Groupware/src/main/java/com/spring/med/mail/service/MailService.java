package com.spring.med.mail.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.spring.med.mail.domain.MailReceiveVO;
import com.spring.med.mail.domain.MailSentVO;


public interface MailService {

	

	// 받은 메일 리스트 보여주기
	List<MailReceiveVO> selectMailReceiveList(Map<String, String> paraMap);
	
	// 받은메일 총 갯수 select 하기
	int getTotalCount(Map<String, String> paraMap);
	
	// 보낸메일 총 갯수 select 하기
	int getTotalCountSent(Map<String, String> paraMap);
	
	// 작성된 메일 발신메일 테이블에 insert 하기
	int insertMailWrite(MailSentVO mvo, String fk_member_userid);

	// 작성된 메일 발신메일 테이블에 insert 하기 with 파일첨부
	int insertMailWriteWithFile(MailSentVO mvo, String fk_member_userid);

	// 보낸 메일 리스트 보여주기
	List<MailReceiveVO> selectMailSentList(Map<String, String> paraMap);

	// 중요메일 유무 알아오기
	List<HashMap<String, String>> isImportantMail(String member_userid);

	// 받은메일함 중요메일 update 0->1(트랜잭션)
	int updateImportant(Map<String, String> paraMap);

	// 받은메일함 중요메일 update 1->0(트랜잭션)
	int updateImportantreturn(Map<String, String> paraMap);

	// 받은메일함 체크한 메일 보관함 옮기기
	int sendMailStorage(List<Integer> mailNos, Map<String, String> paraMap);

	// 받은메일함 체크한 메일 휴지통 옮기기
	int sendMailTrash(List<Integer> mailNos, Map<String, String> paraMap);

	// 보낸메일함 중요메일 유무 알아오기
	List<HashMap<String, String>> isImportantMailSent(String member_userid);

	// 보낸메일함 update 0->1(트랜잭션)
	int updateImportantSent(Map<String, String> paraMap);

	// 보낸메일함 update 1->0(트랜잭션)
	int updateImportantreturnSent(Map<String, String> paraMap);

	// 보낸메일함 체크한 메일 휴지통 옮기기
	int sendMailTrashSent(List<Integer> mailNos, Map<String, String> paraMap);

	// 휴지통 총 메일갯수 가져오기
	//int getTrashTotalCount(Map<String, String> paraMap);

	// 휴지통 보낸 메일함 메일 리스트 select 해오기
	List<MailSentVO> selectMailTrashList(Map<String, String> paraMap);

	// 보관함 총 메일갯수 가져오기
	int getStorageTotalCount(Map<String, String> paraMap);

	// 보관함 메일 리스트 select 해오기
	List<MailReceiveVO> selectMailStorageList(Map<String, String> paraMap);

	// 보낸휴지통 메일 복구시키기
	int sentMailRestore(List<Integer> mailNos, Map<String, String> paraMap);

	// 보낸메일함 휴지통 총갯수 가져오기
	int getSentTrashTotalCount(Map<String, String> paraMap);

	// 받은메일함 휴지통 총갯수 가져오기
	int getReceivedTrashTotalCount(Map<String, String> paraMap);

	// 보낸메일함 휴지통 리스트
	List<MailSentVO> selectReceivedMailTrashList(Map<String, String> paraMap);

	// 받은메일 휴지통 메일 복구하기 1->0
	int receivedMailRestore(List<Integer> mailNos, Map<String, String> paraMap);

	// 휴지통 메일 영구삭제하기
	int sentMailDelete(List<Integer> mailNos, Map<String, String> paraMap);

	// 휴지통 받은 메일 영구삭제하기
	int receivedMailDelete(List<Integer> mailNos, Map<String, String> paraMap);

	// 발신메일인지 수신메일인지 구별
	//List<Map<String, String>> isSR(List<Integer> mailNos, Map<String, String> paraMap);



	

	
}
