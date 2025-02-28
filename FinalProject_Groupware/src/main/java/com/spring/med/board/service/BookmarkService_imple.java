package com.spring.med.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.model.BookmarkDAO;

@Service
public class BookmarkService_imple implements BookmarkService {

    @Autowired
    private BookmarkDAO dao;

    @Override
    public List<BoardVO> getBookmarks(Integer member_userid) {
        return dao.getBookmarks(member_userid);
    }

    @Override
    public boolean addBookmark(Integer member_userid, int board_no) {
        return dao.insertBookmark(member_userid, board_no) > 0;
    }

    @Override
    public boolean removeBookmark(Integer member_userid, int board_no) {
        return dao.deleteBookmark(member_userid, board_no) > 0;
    }

	@Override
	public int getBookmarkTotalCount(Map<String, String> paraMap) {
		return dao.getBookmarkTotalCount(paraMap);
	}

	@Override
	public List<BoardVO> getBookmarkList(Map<String, String> paraMap) {
		return dao.getBookmarkList(paraMap);
	}

	
	// 즐겨찾기된 게시글을 서버에서 가져오기
	@Override
	public List<Integer> getUserBookmarks(Integer member_userid) {
		return dao.getUserBookmarks(member_userid);
	}
}
