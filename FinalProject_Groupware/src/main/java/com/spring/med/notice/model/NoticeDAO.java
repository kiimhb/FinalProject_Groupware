package com.spring.med.notice.model;

import java.util.List;
import java.util.Map;

import com.spring.med.notice.domain.NoticeVO;

public interface NoticeDAO {
	
	// 개인별 총 공지사항 개수 (totalCount)
	int getNoticeCount(Map<String, Object> paraMap);
	
	// 공지사항 목록
	List<NoticeVO> notice_list(Map<String, Object> paraMap);

	// 글 1개 조회하기 
	NoticeVO getNoticeView(Map<String, String> paraMap);

	// 글조회수 1증가 하기 
	int increase_notice_readCount(String notice_no);

	// 첨부파일이 없는 글쓰기
	int notice_write(NoticeVO noticevo);

	// 첨부파일이 있는 글쓰기
	int notice_file_write(NoticeVO noticevo);

	// 1개글 삭제할 때 먼저 사진이미지파일명 및 첨부파일명을 알아오기 위한 것
	Map<String, String> getNotice_delete(String notice_no);

	// 첨부파일 및 사진이미지가 있는 경우의 글삭제
	int notice_del(String notice_no);

}
