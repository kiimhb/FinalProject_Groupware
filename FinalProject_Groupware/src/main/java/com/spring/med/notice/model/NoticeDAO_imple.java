package com.spring.med.notice.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.notice.domain.NoticeVO;

@Repository
public class NoticeDAO_imple implements NoticeDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	
	// 개인별 총 공지사항 개수 (totalCount)
	@Override
	public int getNoticeCount(Map<String, Object> paraMap) {
		int n = sqlsession.selectOne("hyeyeon.getNoticeCount", paraMap);
		return n;
	}

	// 공지사항 목록
	@Override
	public List<NoticeVO> notice_list(Map<String, Object> paraMap) {
		List<NoticeVO> notice_list = sqlsession.selectList("hyeyeon.notice_list", paraMap);
		return notice_list;
	}

	// 글 1개 조회하기 
	@Override
	public NoticeVO getNoticeView(Map<String, String> paraMap) {
		NoticeVO noticevo = sqlsession.selectOne("hyeyeon.noticeView", paraMap);
		return noticevo;
	}

	// 글조회수 1증가 하기 
	@Override
	public int increase_notice_readCount(String notice_no) {
		int n = sqlsession.update("hyeyeon.increase_notice_readCount", notice_no);
		return n;
	}

	// 첨부파일이 없는 글쓰기
	@Override
	public int notice_write(NoticeVO noticevo) {
		int n = sqlsession.insert("hyeyeon.notice_write", noticevo);
		return n;
	}

	// 첨부파일이 있는 글쓰기
	@Override
	public int notice_file_write(NoticeVO noticevo) {
		int n =sqlsession.insert("hyeyeon.notice_file_write", noticevo);
		return n;
	}

	// 1개글 삭제할 때 먼저 사진이미지파일명 및 첨부파일명을 알아오기 위한 것
	@Override
	public Map<String, String> getNotice_delete(String notice_no) {
		Map<String, String> getNotice_delete = sqlsession.selectOne("hyeyeon.getNotice_delete", notice_no);
		return getNotice_delete;
	}

	// 첨부파일 및 사진이미지가 있는 경우의 글삭제
	@Override
	public int notice_del(String notice_no) {
		int n = sqlsession.delete("hyeyeon.notice_del", notice_no);
		return n;
	}

	// 공지사항수정하기
	@Override
	public int notice_update(Map<String, String> paraMap) {
		int n = sqlsession.update("hyeyeon.notice_update", paraMap);
		return n;
	}

	// 부서별 사원 아이디 조회하기 
	@Override
	public List<String> selectMemberId(List<String> fk_child_dept_no) {
		List<String> selectMemberId = sqlsession.selectList("hyeyeon.selectMemberId", fk_child_dept_no);
		return selectMemberId;
	}

	// 제목으로 공지사항 번호 알아오기 
	@Override
	public String selectNoticeNo(String notice_title) {
		String selectNoticeNo = sqlsession.selectOne("hyeyeon.selectNoticeNo", notice_title);
		return selectNoticeNo;
	}

	// 공지사항이 작성되면 알림 테이블에 입력해준다. 
	@Override
	public void insertNoticeAlarm(Map<String, String> paraMap) {
		sqlsession.insert("hyeyeon.insertNoticeAlarm", paraMap);
	}

	
}
