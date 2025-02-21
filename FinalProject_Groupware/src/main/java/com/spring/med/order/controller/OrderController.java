package com.spring.med.order.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.order.domain.OrderVO;
import com.spring.med.order.service.OrderService;
import com.spring.med.patient.domain.TreatPatientVO;
import com.spring.med.patient.service.TreatPatientService;

import jakarta.servlet.http.HttpServletRequest;




@Controller
@RequestMapping(value="/order/*")
public class OrderController {
	
	
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private OrderService service;
	

	// 진료 정보 입력 들어갔을시 환자 정보 select하기 === //
	@GetMapping("orderEnter")
	public ModelAndView orderEnterViewClick(HttpServletRequest request, ModelAndView mav) {
				
		// 환자클릭으로 온거
		String nameClickPatient_no = request.getParameter("nameClickPatient_no");		
		System.out.println("클릭 한번호: "+nameClickPatient_no);
		
		if(nameClickPatient_no != null) {
			
			nameClickPatient_no = request.getParameter("nameClickPatient_no");
			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("patient_no", nameClickPatient_no);
			
			Map<String, String> clickPatient = service.orderClickEnterandView(paraMap);
			
			String status = clickPatient.get("patient_status");
			
			// System.out.println("맞잖아:"+clickPatient);
			
			// status에 따른 초진재진 여부 if문
			if(status.equals("1") ) {			
				String Rejin = "재진";			
				clickPatient.put("jin", Rejin);
			} else {
				String Chojin = "초진";
				clickPatient.put("jin", Chojin);
			}
			
			mav.addObject("clickPatient", clickPatient);				
			mav.setViewName("content/order/orderEnter");
			
			// 환자 오더내역 보여주기								
			List<Map<String, String>> orderList = service.orderList(paraMap);	
			
			mav.addObject("orderList", orderList);


			
			
		}
		else {
		
		// 그냥 온거
		Map<String, String> paraMap = new HashMap<>();
			
		Map<String,String> firstPatient = service.orderEnterandView(paraMap);
		
		String status = firstPatient.get("patient_status");
		
		System.out.println("맞잖아:"+firstPatient);
		
		// status에 따른 초진재진 여부 if문
		if(status.equals("1") ) {			
			String Rejin = "재진";			
			firstPatient.put("jin", Rejin);
		} else {
			String Chojin = "초진";
			firstPatient.put("jin", Chojin);
		}
		
		// System.out.println(firstPatient);
		
		mav.addObject("firstPatient", firstPatient);		
		mav.setViewName("content/order/orderEnter");
		}
		

		
		
		
		
		return mav;
	}
		
	/*
	// === 진료정보입력에서 환자의 오더 기록 select하기 (ajax)=== //
	@GetMapping("clickOrderRecord")
	@ResponseBody
	public List<Map<String, String>> orderRecordView(HttpServletRequest request, @RequestParam String clickPatient_no ){
		
		String nameClickPatient_no = request.getParameter("nameClickPatient_no");       
		
		System.out.println("클릭"+nameClickPatient_no); // null
		System.out.println("파람"+clickPatient_no); // 없음
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("patient_no", nameClickPatient_no);
		
		
		List<Map<String, String>> orderList = service.orderList(paraMap);
		
		System.out.println("오리:"+orderList);
		
		return orderList;
	}
	*/
	
	
	
	/*
	// === 대기환자 명에서 환자를 클릭하여 진료정보 입력 들어갔을시 환자 정보 select하기 === //
	@GetMapping("orderEnter?")
	public ModelAndView orderEnterViewnoClick(HttpServletRequest request, ModelAndView mav) {
							
		String patient_no = request.getParameter("nameClickPatient_no");
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("patient_no", patient_no);
		
		Map<String, String> clickPatient = service.orderClickEnterandView(paraMap);
	
		
		
		mav.addObject("clickPatient", clickPatient);				
		mav.setViewName("content/order/orderEnter?");
		
		return mav;
	}
		
	
	/*
	@GetMapping("patientInfoinOrder")
	public ModelAndView patientInfoinOrder (ModelAndView mav,){
		
		TreatPatientVO patientInfo = service.patientInfoinOrder();
		
		return mav;
	}
	
	*/
	
	
	
}
