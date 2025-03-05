package com.spring.med.notice.service;

import java.util.ArrayList;
import java.util.HashMap;
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
	// 알람 테이블에도 insert 를 해줘야한다. (공지사항이 작성됐음을 알림)
	@Transactional
	public int notice_write(NoticeVO noticevo) {
		
		// 공지사항 작성이 성공했음
		int n = dao.notice_write(noticevo); 
		String notice_title = noticevo.getNotice_title(); // 방금 작성한 공지사항 번호를 알아오기 위함
		
		// 제목으로 공지사항 번호 알아오기 
		String notice_no = dao.selectNoticeNo(notice_title);
		
		if(n == 1) { // 알림테이블 insert 하기

			List<String> fk_child_dept_no = new ArrayList<>(); // 진료부 1 ~ 7 / 간호부 8 ~ 10 / 경영지원부 11 ~ 13
			
			int notice_dept = noticevo.getNotice_dept(); // 공지대상부서 0,1,2,3
			
			// ==== 부서번호 입력해주기 ==== //
			if(notice_dept == 0) { // notice_dept 0 은 모든 부서이다.
				for(int i=1; i<=13; i++) { 
					fk_child_dept_no.add(String.valueOf(i)); // 1 부터 13 을 넣기  
				}
			}
			else if(notice_dept == 1) { // notice_dept 1은 fk_child_dept_no 1~7 진료부이다.
				for(int i=1; i<=7; i++) { 
					fk_child_dept_no.add(String.valueOf(i)); // 1 부터 7 을 넣기  
				}
			}
			else if(notice_dept == 2) { // notice_dept 2은 fk_child_dept_no 8~10 간호부이다.
				for(int i=8; i<=10; i++) { 
					fk_child_dept_no.add(String.valueOf(i)); // 8 부터 10 을 넣기  
				}
			}
			else  { // notice_dept 3은 fk_child_dept_no 11~13 경영지원부이다.
				for(int i=11; i<=13; i++) { 
					fk_child_dept_no.add(String.valueOf(i)); // 11 부터 13 을 넣기  
				}
			}
			
			// 부서별 사원아이디 목록 알아오기
			List<String> selectMemberIdList = dao.selectMemberId(fk_child_dept_no);
			// System.out.println("selectMemberIdList" + selectMemberIdList);
	
			// 조회된 사원들에게 알림 입력하기 
			for(String fk_member_userid :selectMemberIdList) {
				Map<String, String> paraMap = new HashMap<>();
				paraMap.put("fk_member_userid", fk_member_userid);
				paraMap.put("notice_no", notice_no);
				
				dao.insertNoticeAlarm(paraMap); // 알람 넣기 
			} // end of for(String fk_member_userid :selectMemberIdList)
		}
		
		return n;
	}

	// 첨부파일이 있는 글쓰기
	// 알람 테이블에도 insert 를 해줘야한다. (공지사항이 작성됐음을 알림)
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

	// 공지사항 수정하기
	@Override
	public int notice_update(Map<String, String> paraMap) {
		int n = dao.notice_update(paraMap);
		return n;
	}
	
	

}
