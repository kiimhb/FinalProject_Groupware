package com.spring.med.order.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.med.order.domain.OrderVO;

@Repository
public class OrderDAO_imple implements OrderDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	
	// === 환자 클릭하지않고 바로 진료 정보 입력 들어갔을시 첫 대기 환자 정보 select하기 === //
	@Override
	public Map<String, String>orderEnterandView(Map<String, String> paraMap) {
				
		Map<String, String> map = sqlsession.selectOne("seonggon_order.orderEnterandView", paraMap);
		
		return map;
	}

	// === 대기환자 명에서 환자를 클릭하여 진료정보 입력 들어갔을시 환자 정보 select하기 === //
	@Override
	public Map<String, String> orderClickEnterandView(Map<String, String> paraMap) {
		
		Map<String, String> map = sqlsession.selectOne("seonggon_order.orderClickEnterandView", paraMap);
		
		return map;
	}

	// === 진료정보입력에서 환자의 오더 기록 select하기 === //
	@Override
	public List<Map<String, String>> orderList(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = sqlsession.selectList("seonggon_order.orderList", paraMap);
		return mapList;
	}

	// === 질병 검색어 입력시 질병 자동 완성하기 3 === //
	@Override
	public List<String> deseaseSearchShow(Map<String, String> paraMap) {
		List<String> deseaseList = sqlsession.selectList("seonggon_order.deseaseSearchShow", paraMap);
		return deseaseList;
	}
	

	// <%-- 질병 검색후 클릭해서 질병이름 보여주기--%> //
	@Override
	public String showDeseaseName(Map<String, String> paraMap) {
		String deseaseName = sqlsession.selectOne("seonggon_order.deseaseName", paraMap);
		return deseaseName;
	}
	
	// === 약 검색어 입력시 약 자동 완성하기 3 === //
	@Override
	public List<String> medicineSearchShow(Map<String, String> paraMap) {
		List<String> medicineList = sqlsession.selectList("seonggon_order.medicineSearchShow", paraMap);
		return medicineList;
	}

	// <%-- 약 검색후 클릭해서 약이름이랑 약처방 보여주기--%> //
	@Override
	public String showMedicineName(Map<String, String> paraMap) {
		String medicineName = sqlsession.selectOne("seonggon_order.medicineName", paraMap);
		return medicineName;
	}

	// <%-- 약 약처방 확정후 처방테이블로 insert하기 --%> //
	@Override
	public int medicineSubmit(List<Map<String, String>> mapList) {		
		int n = sqlsession.insert("seonggon_order.medicineSubmit", mapList);
		return n;
	}

	// 클릭하여 진료정보입력 진입시 빈 오더 생성하기
	@Override
	public int createEmptyOrder(Map<String, String> paraMap) {
		int n = sqlsession.insert("seonggon_order.createEmptyOrder", paraMap);
		return n;
	}

	// 생성된 빈 오더번호 가져오기
	@Override
	public String newOrderNo(Map<String, String> paraMap) {
		
		String newOrderNo = sqlsession.selectOne("seonggon_order.newOrderNo", paraMap);
		return newOrderNo;
	}

	// 수술 리스트 가져오기
	@Override
	public List<Map<String, String>> surgeryList() {
		List<Map<String, String>> surgeryList = sqlsession.selectList("seonggon_order.surgeryList");
		return surgeryList;
	}

	// 입원 요청하여 입원테이블에 insert 하기
	@Override
	public int requestHosp(Map<String, String>paraMap) {
		int n = sqlsession.insert("seonggon_order.requestHosp", paraMap);
		return n;
	}

	@Override
	public int requestHosp2(Map<String, String> paraMap) {
		int n = sqlsession.insert("seonggon_order.requestHosp2", paraMap);
		return n;
	}

	// 수술 요청하여 수술테이블에 insert 하기 (트랜잭션)
	@Override
	public int surgeryConfirm(Map<String, String> paraMap) {
		int n = sqlsession.insert("seonggon_order.surgeryConfirm", paraMap);
		return n;
	}

	@Override
	public int surgeryConfirm2(Map<String, String> paraMap) {
		int n = sqlsession.insert("seonggon_order.surgeryConfirm2", paraMap);
		return n;
	}

	// 질병 고르고 확정눌러서 질병테이블에 insert 하기
	@Override
	public int orderDesease(Map<String, String> paraMap) {
		int n = sqlsession.insert("seonggon_order.orderDesease", paraMap);
		return n;
	}




}
