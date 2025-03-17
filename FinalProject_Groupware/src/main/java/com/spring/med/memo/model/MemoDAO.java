package com.spring.med.memo.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.spring.med.memo.domain.MemoVO;

public interface MemoDAO {
	
	// 메모 작성
	int insertMemo(MemoVO memovo);

	// 메모 목록 보기
	List<MemoVO> memo_list(Map<String, String> paraMap);

	// 메모 수정하기
	int updateMemo(int memo_no, String memo_title, String memo_content);

	// 메모 삭제하기
	int deleteMemo(int memo_no);
	
	
	
	// ================== 휴지통 시작 =================== //
//	int trash(int memo_no); // 일반매모 삭제
	
	// 일반메모, 중요메모 삭제 시 휴지통으로 이동
	int moveToTrash(Map<String, Object> paraMap);
	
	// 휴지통에서 메모 복원
    int restoreMemo(int memo_no);
    
    // 휴지통에서 메모 완전 삭제
    int deleteTrash(int memo_no);
    
    // 30일 이상 지난 메모 삭제
 	void deleteOldTrashMemos();
    
    // 휴지통으로 이동한 메모 조회
	List<MemoVO> trash_list(Map<String, Object> paraMap);
	// ================== 휴지통 끝 =================== //
	

	// ================== 즐겨찾기 시작 =================== //

	// 현재 메모의 중요 메모 여부 확인
	String getMemoImportance(Map<String, String> paraMap);

	// 중요 메모(즐겨찾기) 업데이트
	int updateMemoImportance(Map<String, String> paraMap);

	// 중요 메모(즐겨찾기) 목록 가져오기 
	List<MemoVO> selectImportantMemoList(String member_userid);

	// ================== 즐겨찾기 끝 =================== //

	
	
	
	
	
	
	
	
	
	
	
    
}
