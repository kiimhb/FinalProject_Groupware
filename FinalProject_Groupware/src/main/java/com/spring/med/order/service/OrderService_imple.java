package com.spring.med.order.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.med.order.domain.OrderVO;
import com.spring.med.order.model.OrderDAO;
import com.spring.med.patient.model.TreatPatientDAO;

@Service
public class OrderService_imple implements OrderService {

	
	@Autowired
	private OrderDAO odao;
	
	
	// === 환자 클릭하지않고 바로 진료 정보 입력 들어갔을시 첫 대기 환자 정보 select하기 === //
	@Override
	public Map<String, String> orderEnterandView(Map<String, String> paraMap) {

		Map<String, String> map = odao.orderEnterandView(paraMap);
			
		return map;
	}


	// === 대기환자 명에서 환자를 클릭하여 진료정보 입력 들어갔을시 환자 정보 select하기 === //
	@Override
	public Map<String, String> orderClickEnterandView(Map<String, String> paraMap) {
		
		Map<String, String> map = odao.orderClickEnterandView(paraMap);
		
		return map;
	}
	
	// 클릭하여 진료정보입력 진입시 빈 오더 생성하기
	@Override
	public int createEmptyOrder(Map<String, String> paraMap) {
		int n = odao.createEmptyOrder(paraMap);
		return n;
	}


	// === 진료정보입력에서 환자의 오더 기록 select하기 === //
	@Override
	public List<Map<String, String>> orderList(Map<String, String> paraMap) {
		List<Map<String, String>> mapList = odao.orderList(paraMap);
		return mapList;
	}

	// === 질병 검색어 입력시 질병 자동 완성하기 3 === //
	@Override
	public List<String> deseaseSearchShow(Map<String, String> paraMap) {
		List<String> deseaseList = odao.deseaseSearchShow(paraMap);
		return deseaseList;
	}	

	// <%-- 질병 검색후 클릭해서 질병이름 보여주기--%> //
	@Override
	public String showDeseaseName(Map<String, String> paraMap) {
		String deseaseName = odao.showDeseaseName(paraMap);		
		return deseaseName;
	}

	// === 약 검색어 입력시 약 자동 완성하기 3 === //
	@Override
	public List<String> medicineSearchShow(Map<String, String> paraMap) {
		List<String> medicineList = odao.medicineSearchShow(paraMap);
		return medicineList;
	}


	// <%-- 약 검색후 클릭해서 약이름이랑 약처방 보여주기--%> //
	@Override
	public String showMedicineName(Map<String, String> paraMap) {		
		String medicineName = odao.showMedicineName(paraMap);		
		return medicineName;
	}


	// <%-- 약 약처방 확정후 처방테이블로 insert하기 --%> //
	@Override
	public int medicineSubmit(List<Map<String, String>> mapList) {		
		int n = odao.medicineSubmit(mapList);		
		return n;
	}


	// 생성된 빈 오더번호 가져오기
	@Override
	public String newOrderNo(Map<String, String> paraMap) {		
		String newOrderNo = odao.newOrderNo(paraMap);		
		return newOrderNo;
	}


	// 수술 리스트 가져오기
	@Override
	public List<Map<String, String>> surgeryList() {		
		List<Map<String, String>> surgeryList = odao.surgeryList();		
		return surgeryList;		
	}


	// 입원 요청하여 입원테이블에 insert 하기 
	@Override
	@Transactional(value="transactionManager_mymvc_user", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int requestHosp(Map<String, String>paraMap) {
		
		int n=0, result=0;		
		n = odao.requestHosp(paraMap);		
		if(n==1) {			
			result= odao.requestHosp2(paraMap);			
		}		
		
		return result;
	}

	// 수술 요청하여 수술테이블에 insert 하기 (트랜잭션)
	@Override
	@Transactional(value="transactionManager_mymvc_user", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int surgeryConfirm(Map<String, String> paraMap) {
		
		int n=0, result=0;		
		n = odao.surgeryConfirm(paraMap);		
		if(n==1) {			
			result= odao.surgeryConfirm2(paraMap);			
		}		
		
		return result;
	}


	// 질병 고르고 확정눌러서 질병테이블에 insert 하기
	@Override
	public int orderDesease(Map<String, String> paraMap) {
		
		int n = odao.orderDesease(paraMap);		
		return n;
		
	}









	
	
	
	
	
	
}


