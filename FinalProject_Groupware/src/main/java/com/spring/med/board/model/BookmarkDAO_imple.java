package com.spring.med.board.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.board.domain.BoardVO;

@Repository
public class BookmarkDAO_imple implements BookmarkDAO {

    @Autowired
    @Qualifier("sqlsession")
    private SqlSessionTemplate sqlsession;

    // 즐겨찾기 목록 조회
    @Override
    public List<BoardVO> getBookmarks(Integer member_userid) {
        return sqlsession.selectList("minji_myboard.getBookmarks", member_userid);
    }

    // 즐겨찾기 추가
    @Override
    public int insertBookmark(Integer member_userid, int board_no) {
        Map<String, Object> paraMap = new HashMap<>();
        paraMap.put("fk_member_userid", member_userid);
        paraMap.put("fk_board_no", board_no);

        return sqlsession.insert("minji_myboard.insertBookmark", paraMap);
    }

    // 즐겨찾기 삭제
    @Override
    public int deleteBookmark(Integer member_userid, int board_no) {
        Map<String, Object> paraMap = new HashMap<>();
        paraMap.put("fk_member_userid", member_userid);
        paraMap.put("fk_board_no", board_no);

        return sqlsession.delete("minji_myboard.deleteBookmark", paraMap);
    }

	@Override
	public int getBookmarkTotalCount(Map<String, String> paraMap) {
		return sqlsession.selectOne("minji_myboard.getMyTotalCount", paraMap);
	}

	@Override
	public List<BoardVO> getBookmarkList(Map<String, String> paraMap) {
		 return sqlsession.selectList("minji_myboard.getMyBoardList", paraMap);
	}

	// 즐겨찾기된 게시글을 서버에서 가져오기
	@Override
	public List<Integer> getUserBookmarks(Integer member_userid) {
		 return sqlsession.selectList("minji_myboard.getUserBookmarks", member_userid);
	}
}