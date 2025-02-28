package com.spring.med.notice.service;

import java.util.List;
import java.util.Map;

import com.spring.med.notice.domain.NoticeVO;

public interface NoticeService {
	
	// 개인별 총 공지사항 개수 (totalCount)
	int getNoticeCount(Map<String, Object> paraMap);

	// 부서별 공지사항 목록
	List<NoticeVO> notice_list(Map<String, Object> paraMap);

	// 글 조회수 증가와 함께 글 1개를 조회를 해오는 것
	NoticeVO getNoticeView(Map<String, String> paraMap);

	// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
	NoticeVO getView_no_increase_readCount(Map<String, String> paraMap);

	// 첨부파일이 없는 글쓰기
	int notice_write(NoticeVO noticevo);

	// 파일첨부가 있는 글쓰기 
	int notice_file_write(NoticeVO noticevo);

	// 1개글 삭제할 때 먼저 사진이미지파일명 및 첨부파일명을 알아오기 위한 것
	Map<String, String> getNotice_delete(String notice_no);

	// 첨부파일 및 사진이미지가 있는 경우의 글삭제
	int notice_del(Map<String, String> paraMap);

}
