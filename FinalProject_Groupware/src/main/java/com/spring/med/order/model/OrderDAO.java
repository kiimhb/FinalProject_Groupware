package com.spring.med.order.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.spring.med.order.domain.OrderVO;

public interface OrderDAO {

	
	// === 환자 클릭하지않고 바로 진료 정보 입력 들어갔을시 첫 대기 환자 정보 select하기 === //
	Map<String, String> orderEnterandView(Map<String, String> paraMap);

	// === 대기환자 명에서 환자를 클릭하여 진료정보 입력 들어갔을시 환자 정보 select하기 === //
	Map<String, String> orderClickEnterandView(Map<String, String> paraMap);

	// === 진료정보입력에서 환자의 오더 기록 select하기 === //
	List<Map<String, String>> orderList(Map<String, String> paraMap);

	// === 질병 검색어 입력시 질병 자동 완성하기 3 === //
	List<String> deseaseSearchShow(Map<String, String> paraMap);
	
	// <%-- 질병 검색후 클릭해서 질병이름 보여주기--%> //
	String showDeseaseName(Map<String, String> paraMap);
	
	// === 약 검색어 입력시 약 자동 완성하기 3 === //
	List<String> medicineSearchShow(Map<String, String> paraMap);

	// <%-- 약 검색후 클릭해서 약이름이랑 약처방 보여주기--%> //
	String showMedicineName(Map<String, String> paraMap);

	// <%-- 약 약처방 확정후 처방테이블로 insert하기 --%> //
	int medicineSubmit(@Param("mapList") List<Map<String, String>> mapList);

	// 클릭하여 진료정보입력 진입시 빈 오더 생성하기
	int createEmptyOrder(Map<String, String> paraMap);

	// 생성된 빈 오더번호 가져오기
	String newOrderNo(Map<String, String> paraMap);

	// 수술 리스트 가져오기
	List<Map<String, String>> surgeryList();

	// 입원 요청하여 입원테이블에 insert 하기 (트랜잭션)
	int requestHosp(Map<String, String>paraMap);
	int requestHosp2(Map<String, String> paraMap);

	// 수술 요청하여 수술테이블에 insert 하기 (트랜잭션)
	int surgeryConfirm(Map<String, String> paraMap);
	int surgeryConfirm2(Map<String, String> paraMap);

	// 질병 고르고 확정눌러서 질병테이블에 insert 하기
	int orderDesease(Map<String, String> paraMap);




}
