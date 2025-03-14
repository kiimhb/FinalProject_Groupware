package com.spring.med.memo.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.memo.domain.MemoVO;
import com.spring.med.notice.domain.NoticeVO;

@Repository
public class MemoDAO_imple implements MemoDAO{

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 메모 쓰기
	@Override
	public int insertMemo(MemoVO memovo) {
	    int n = sqlsession.insert("minji_memo.insertMemo", memovo);
		return n;
	}

	// 메모 목록 보기
	@Override
	public List<MemoVO> memo_list(Map<String, String> paraMap) {
		List<MemoVO> memo_list = sqlsession.selectList("minji_memo.memo_list", paraMap);
		return memo_list;
	}

	// 메모 수정하기
	@Override
	public int updateMemo(int memo_no, String memo_title, String memo_contents) {
		 MemoVO memo = new MemoVO();
         memo.setMemo_no(memo_no);
         memo.setMemo_title(memo_title);
         memo.setMemo_contents(memo_contents);
         return sqlsession.update("minji_memo.updateMemo", memo);
	}

	// 메모 삭제하기
	@Override
	public int deleteMemo(int memo_no) {
		return sqlsession.delete("minji_memo.deleteMemo", memo_no);
	}
	
	
	
	// ================== 휴지통 시작 =================== //
	@Override
    public int trash(int memo_no) {
        return sqlsession.update("minji_memo.trash", memo_no);
    }

    @Override
    public int restoreMemo(int memo_no) {
        return sqlsession.update("minji_memo.restoreMemo", memo_no);
    }

    @Override
    public int deleteTrash(int memo_no) {
        return sqlsession.delete("minji_memo.deleteTrash", memo_no);
    }

    
    // 30일 이상 지난 메모 삭제
    @Override
	public void deleteOldTrashMemos() {
    	sqlsession.delete("minji_memo.deleteOldTrashMemos");
	}

    // 휴지통으로 이동한 메모 조회
	@Override
	public List<MemoVO> trash_list(Map<String, Object> paraMap) {
		List<MemoVO> trash_list = sqlsession.selectList("minji_memo.trash_list", paraMap);
		return trash_list;
	}
	
	// ================== 휴지통 끝 =================== //

	
	
	// ================== 즐겨찾기 시작 =================== //
	
	// 현재 메모의 중요 메모 여부 확인
	@Override
    public String getMemoImportance(Map<String, String> paraMap) {
        return sqlsession.selectOne("minji_memo.getMemoImportance", paraMap);
    }

	// 중요 메모(즐겨찾기) 업데이트
    @Override
    public void updateMemoImportance(Map<String, String> paraMap) {
        sqlsession.update("minji_memo.updateMemoImportance", paraMap);
    }

    // 중요 메모(즐겨찾기) 목록 가져오기 
    @Override
    public List<MemoVO> selectImportantMemoList(String member_userid) {
        return sqlsession.selectList("minji_memo.selectImportantMemoList", member_userid);
    }
	
    // 중요 메모(즐겨찾기) 목록 가져오기 
/*    
    @Override
    public List<Map<String, String>> selectImportantMemo(String member_userid) {
        return sqlsession.selectList("minji_memo.selectImportantMemo", member_userid);
    }
*/	
	
	
	// ================== 즐겨찾기 끝 =================== //
	
	
	
	
	
	
	
	
	
	
	

}