package com.spring.med.notice.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.med.common.FileManager;
import com.spring.med.notice.domain.NoticeVO;
import com.spring.med.notice.model.NoticeDAO;

@Service
public class NoticeService_imple implements NoticeService {

	@Autowired
	private NoticeDAO dao;
	
	@Autowired
	private FileManager fileManager;
	
	
	// 개인별 총 공지사항 개수 (totalCount)
	@Override
	public int getNoticeCount(Map<String, Object> paraMap) {
		int n = dao.getNoticeCount(paraMap);
		return n;
	}

	// 부서별 공지사항 목록
	@Override
	public List<NoticeVO> notice_list(Map<String, Object> paraMap) {
		List<NoticeVO> notice_list = dao.notice_list(paraMap);
		return notice_list;
	}

	// 글 조회수 증가와 함께 글 1개를 조회를 해오는 것
	@Override
	@Transactional
	public NoticeVO getNoticeView(Map<String, String> paraMap) {
		
		NoticeVO noticevo = dao.getNoticeView(paraMap); // 글 1개 조회하기
		
		String login_userid = paraMap.get("login_userid");
		
		if(login_userid != null &&
				noticevo != null &&
		  !login_userid.equals(noticevo.getFk_member_userid() )) { // 로그인을 한 경우에 조회수 증가 
			
		  int n = dao.increase_notice_readCount(paraMap.get("notice_no")); // 글조회수 1증가 하기 
		
		  if(n==1) {
			  noticevo.setNotice_view_cnt((noticevo.getNotice_view_cnt() + 1));
		  }
		}
		
		return noticevo;
	}

	
	// 조회수 증가 없이 단순히 글 조회만 해오기 
	@Override
	public NoticeVO getView_no_increase_readCount(Map<String, String> paraMap) {
		NoticeVO noticevo = dao.getNoticeView(paraMap); // 글 1개 조회하기	
		return noticevo;
	}

	// 첨부파일이 없는 글쓰기
	@Override
	public int notice_write(NoticeVO noticevo) {
		int n = dao.notice_write(noticevo);
		return n;
	}

	// 첨부파일이 있는 글쓰기
	@Override
	public int notice_file_write(NoticeVO noticevo) {
		int n = dao.notice_file_write(noticevo);
		return n;
	}

	// 1개글 삭제할 때 먼저 사진이미지파일명 및 첨부파일명을 알아오기 위한 것
	@Override
	public Map<String, String> getNotice_delete(String notice_no) {
		Map<String, String> notice_delete = dao.getNotice_delete(notice_no);
		return notice_delete;
	}

	// 첨부파일 및 사진이미지가 있는 경우의 글삭제
	@Override
	public int notice_del(Map<String, String> paraMap) {
		
		int n = dao.notice_del(paraMap.get("notice_no"));	// 테이블에서 행 삭제하기
		
		// === 첨부파일 및 사진이미지 파일 삭제하기 시작 === // 
		if(n==1) {
			String filepath = paraMap.get("filepath");  // 삭제해야할 첨부파일이 저장된 경로
			String filename = paraMap.get("filename");  // 삭제해야할 첨부파일명 
			
			if(filename != null && !"".equals(filename)) {
				try {
					fileManager.doFileDelete(filename, filepath);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return n;
	}
	
	

}
