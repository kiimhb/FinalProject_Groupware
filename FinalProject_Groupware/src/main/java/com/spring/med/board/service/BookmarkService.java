package com.spring.med.board.service;

import java.util.List;
import java.util.Map;

import com.spring.med.board.domain.BoardVO;

public interface BookmarkService {

    // 즐겨찾기 목록 조회
    List<BoardVO> getBookmarks(Integer member_userid);

    // 즐겨찾기 추가
    boolean addBookmark(Integer member_userid, int board_no);

    // 즐겨찾기 삭제
    boolean removeBookmark(Integer member_userid, int board_no);

	int getBookmarkTotalCount(Map<String, String> paraMap);

	List<BoardVO> getBookmarkList(Map<String, String> paraMap);

	// 즐겨찾기된 게시글을 서버에서 가져오기
	List<Integer> getUserBookmarks(Integer member_userid);



}
