package com.spring.med.memo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.med.memo.domain.MemoVO;
import com.spring.med.memo.model.MemoDAO;

@Service
public class MemoService_imple implements MemoService  {

	@Autowired
    private MemoDAO dao;

	// 메모 쓰기
	@Override
	public int insertMemo(MemoVO memovo) {
	    return dao.insertMemo(memovo); 
	}

	// 메모 목록 보기
	@Override
	public List<MemoVO> memo_list(Map<String, String> paraMap) {
		return dao.memo_list(paraMap);
	}

	// 메모 수정하기
	@Override
	public int updateMemo(int memo_no, String memo_title, String memo_content) {
		return dao.updateMemo(memo_no, memo_title, memo_content);
	}

	// 메모 삭제하기
	@Override
	public int deleteMemo(int memo_no) {
		return dao.deleteMemo(memo_no);
	}
	
	
	
	// ================== 휴지통 끝 =================== //
/*	
	public int trash(int memo_no) { // 일반 메모에서 삭제할 경우
        return dao.trash(memo_no);
    }
*/
	
	// 일반메모, 중요메모 삭제 시 휴지통으로 이동
	@Override
	public int moveToTrash(Map<String, Object> paraMap) {
	    return dao.moveToTrash(paraMap);
	}
	
	// 휴지통에서 메모 복원
    @Override
    public int restoreMemo(int memo_no) {
        return dao.restoreMemo(memo_no);
    }

    // 휴지통에서 메모 완전 삭제
    @Override
    public int deleteTrash(int memo_no) {
        return dao.deleteTrash(memo_no);
    }

    
    // 30일 이상 지난 메모 자동 삭제
    @Override
    @Scheduled(cron = "0 30 14 * * *")
	public void deleteOldTrashMemos() {
		dao.deleteOldTrashMemos();
	}

    // 휴지통 목록 조회 
	@Override
	public List<MemoVO> trash_list(Map<String, Object> paraMap) {
		
		//System.out.println("확인용~~~~~ : " + paraMap);
		return dao.trash_list(paraMap);
	}

	// ================== 휴지통 끝 =================== //
	
	

	// ================== 즐겨찾기 시작 =================== //
	// 현재 메모의 중요 메모 여부 확인
	@Override
    public String getMemoImportance(Map<String, String> paraMap) {
        return dao.getMemoImportance(paraMap);
    }
	
	
	// 중요 메모(즐겨찾기) 업데이트
	@Override
	public int updateMemoImportance(Map<String, String> paraMap, String status) {
	    paraMap.put("importance", status);
	    return dao.updateMemoImportance(paraMap); // 변경된 행의 개수를 반환
	}


	// 중요 메모(즐겨찾기) 목록 가져오기 
	@Override
	public List<MemoVO> getImportantMemoList(String member_userid) {
		return dao.selectImportantMemoList(member_userid);
	}

	// ================== 즐겨찾기 끝 =================== //

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	
}