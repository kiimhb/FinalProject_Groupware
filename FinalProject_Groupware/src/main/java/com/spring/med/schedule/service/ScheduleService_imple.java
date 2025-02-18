package com.spring.med.schedule.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.schedule.domain.*;
import com.spring.med.schedule.model.*;

@Service
public class ScheduleService_imple implements ScheduleService {

	@Autowired
	private ScheduleDAO dao;

	
	// 사내 캘린더에 캘린더 소분류 추가하기
	@Override
	public int addComCalendar(Map<String, String> paraMap) throws Throwable {
		
		int n=0;
		String com_small_category_name = paraMap.get("com_small_category_name");
		
		// 사내 캘린더에 캘린더 소분류 명 존재 여부 알아오기
		int m = dao.existComCalendar(com_small_category_name);
		
		if(m==0) {
			n = dao.addComCalendar(paraMap);
		}
		
		return n;
	}

	
	// 내 캘린더에 캘린더 소분류 추가하기
	@Override
	public int addMyCalendar(Map<String, String> paraMap) throws Throwable {
		
		int n=0;
		
		// 내 캘린더에 캘린더 소분류 명 존재 여부 알아오기
		int m = dao.existMyCalendar(paraMap);
		
		if(m==0) {
			n = dao.addMyCalendar(paraMap);
		}
		
		return n;
	}


	// 사내 캘린더에서 사내캘린더 소분류  보여주기 
	@Override
	public List<Calendar_small_category_VO> showCompanyCalendar() {
		List<Calendar_small_category_VO> calendar_small_category_VO_CompanyList = dao.showCompanyCalendar(); 
		return calendar_small_category_VO_CompanyList;
	}


	// 내 캘린더에서 내캘린더 소분류  보여주기
	@Override
	public List<Calendar_small_category_VO> showMyCalendar(String fk_member_userid) {
		List<Calendar_small_category_VO> calendar_small_category_VO_MyList = dao.showMyCalendar(fk_member_userid); 
		return calendar_small_category_VO_MyList;
	}


	// 일정 등록시 내캘린더,사내캘린더 선택에 따른 서브캘린더 종류를 알아오기 
	@Override
	public List<Calendar_small_category_VO> selectSmallCategory(Map<String, String> paraMap) {
		List<Calendar_small_category_VO> small_category_VOList = dao.selectSmallCategory(paraMap);
		return small_category_VOList;
	}


	
   // 공유자를 찾기 위한 특정글자가 들어간 회원명단 불러오기
   @Override public List<ManagementVO_ga> searchJoinUserList(String joinUserName) {
	   List<ManagementVO_ga> joinUserList = dao.searchJoinUserList(joinUserName); return
	   joinUserList; 
   }
	 


	// 일정 등록하기
	@Override
	public int registerSchedule_end(Map<String, String> paraMap) throws Throwable {
		int n = dao.registerSchedule_end(paraMap);
		return n;
	}


	// 등록된 일정 가져오기
	@Override
	public List<Calendar_schedule_VO> selectSchedule(String fk_member_userid) {
		List<Calendar_schedule_VO> scheduleList = dao.selectSchedule(fk_member_userid);
		return scheduleList;
	}


	// 일정 상세 보기 
	@Override
	public Map<String,String> detailSchedule(String schedule_no) {
		Map<String,String> map = dao.detailSchedule(schedule_no);
		return map;
	}


	// 일정삭제하기 
	@Override
	public int deleteSchedule(String schedule_no) throws Throwable {
		int n = dao.deleteSchedule(schedule_no);
		return n;
	}


	// 일정수정하기
	@Override
	public int editSchedule_end(Calendar_schedule_VO svo) throws Throwable {
		int n = dao.editSchedule_end(svo);
		return n;
	}


	// (사내캘린더 또는 내캘린더)속의  소분류 카테고리인 서브캘린더 삭제하기 
	@Override
	public int deleteSubCalendar(String small_category_no) throws Throwable {
		int n = dao.deleteSubCalendar(small_category_no);
		return n;
	}


	// (사내캘린더 또는 내캘린더)속의 소분류 카테고리인 서브캘린더 수정하기 
	@Override
	public int editCalendar(Map<String, String> paraMap) throws Throwable {
		int n = 0;
		
		int m = dao.existsCalendar(paraMap); 
		// 수정된 (사내캘린더 또는 내캘린더)속의 소분류 카테고리명이 이미 해당 사용자가 만든 소분류 카테고리명으로 존재하는지 유무 알아오기  
		
		if(m==0) {
			n = dao.editCalendar(paraMap);	
		}
		
		return n;
	}


	// 총 일정 검색 건수(totalCount)
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = dao.getTotalCount(paraMap);
		return n;
	}


	// 페이징 처리한 캘린더 가져오기(검색어가 없다라도 날짜범위 검색은 항시 포함된 것임)
	@Override
	public List<Map<String,String>> scheduleListSearchWithPaging(Map<String, String> paraMap) {
		List<Map<String,String>> scheduleList = dao.scheduleListSearchWithPaging(paraMap);
		return scheduleList;
	}
	
	
	
	
}
