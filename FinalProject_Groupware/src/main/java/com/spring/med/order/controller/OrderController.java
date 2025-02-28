package com.spring.med.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.begin.domain.BeginVO;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.order.domain.OrderVO;
import com.spring.med.order.service.OrderService;
import com.spring.med.patient.domain.TreatPatientVO;
import com.spring.med.patient.service.TreatPatientService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;




@Controller
@RequestMapping(value="/order/*")
public class OrderController {
	
	
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private OrderService service;
	

	// 진료 정보 입력 들어갔을시 환자 정보 select하기 === //
	@GetMapping("orderEnter")
	public ModelAndView orderEnterViewClick(HttpServletRequest request, ModelAndView mav) {

		// 수술리스트 가져오기		
		List<Map<String, String>> surgeryList = service.surgeryList();		
		// System.out.println(surgeryList);
		
		mav.addObject("surgeryList", surgeryList);

		
		
		// 빈 오더 생성위해 담당의사 사번 알아오기
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		// 환자클릭으로 온거
		String nameClickPatient_no = request.getParameter("nameClickPatient_no");		
		// System.out.println("클릭 한번호: "+nameClickPatient_no);
		
		if(nameClickPatient_no != null) {
			
			nameClickPatient_no = request.getParameter("nameClickPatient_no");
			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("patient_no", nameClickPatient_no);			
			
			Map<String, String> clickPatient = service.orderClickEnterandView(paraMap); // 클릭한 환자 정보 진료정보입력에 보여주기
			
			
			// 오더 생성 시작 /////////////////////////////////////////////////////////////////////////////
			/*
			paraMap.put("fk_member_userid", loginuser.getMember_userid());
			int n = service.createEmptyOrder(paraMap); // 클릭하여 진료정보입력 진입시 빈 오더 생성하기
			
			String newOrderNo = service.newOrderNo(paraMap); // 생성된 빈 오더번호 가져오기						
			
			if(n==1) {
				
				String sucMessage = "오더가 생성되었습니다.";
				
				mav.addObject("sucMessage", sucMessage);
				mav.addObject("orderCreate", n);
				mav.addObject("newOrderNo", newOrderNo);
			}
			else {
				String failMessage = "오더가 생성에 실패하였습니다.";
				mav.addObject("failMessage", failMessage);
			}
			*/
			// 오더 생성 끝 /////////////////////////////////////////////////////////////////////////////
			
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
			
			// System.out.println("오니 : "+orderList);
			
			mav.addObject("orderList", orderList);  
			
			
			
			

			
		}
		else {
		
		// 그냥 온거
		Map<String, String> paraMap = new HashMap<>();
			
		Map<String,String> firstPatient = service.orderEnterandView(paraMap);
		
		String status = firstPatient.get("patient_status");
		
		// System.out.println("맞잖아:"+firstPatient);
		
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
	
	// === 질병 검색어 입력시 질병 자동 완성하기 3 === //
	@GetMapping("deseaseSearchShow")
	@ResponseBody
	public List<Map<String, String>> deseaseSearchShow(@RequestParam Map<String, String> paraMap) {
		
		List<String> deseaseList = service.deseaseSearchShow(paraMap); 
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(deseaseList != null) {
			for(String word : deseaseList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				mapList.add(map);
			}// end of for-------------
		}
		
		return mapList;

	}
	
	// <%-- 질병 검색후 클릭해서 질병이름 보여주기--%> //
	@GetMapping("addDesease")
	@ResponseBody
	public String deseaseName(@RequestParam Map<String, String>paraMap) {
				
		String deseaseName = service.showDeseaseName(paraMap);				
		
		// System.out.println("약이름 : "+medicineName);      		
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("deseaseName", deseaseName);				
		
		return jsonObj.toString();
		
	}
	
	// 질병 고르고 확정눌러서 질병테이블에 insert 하기
	@PostMapping("orderDesease")
	@ResponseBody
	public int orderDesease (HttpServletRequest request, @RequestParam Map<String, String> paraMap) {
		
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String fk_member_userid = loginuser.getMember_userid();		
		String orderNo = request.getParameter("orderNo");
		String hiddenPatientNo = request.getParameter("hiddenPatientNo");
		
		paraMap.put("fk_member_userid", fk_member_userid);
		paraMap.put("order_no", orderNo);		
		paraMap.put("fk_patient_no", hiddenPatientNo);
		
		System.out.println("오니 : "+paraMap);
		
		int n = service.orderDesease(paraMap);
		
		return n;
	}
	
	
	
	// === 약 검색어 입력시 약 자동 완성하기 3 === //
	@GetMapping("medicineSearchShow")
	@ResponseBody
	public List<Map<String, String>> medicineSearchShow(@RequestParam Map<String, String> paraMap) {
		
		List<String> medicineList = service.medicineSearchShow(paraMap); 
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(medicineList != null) {
			for(String word : medicineList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				mapList.add(map);
			}// end of for-------------
		}
		
		return mapList;

	}
	
	// <%-- 약 검색후 클릭해서 약이름이랑 약처방 보여주기--%> //
	@GetMapping("addMedicine")
	@ResponseBody
	public String medicineName(@RequestParam Map<String, String>paraMap) {
		
		// System.out.println("맵나오니 : "+paraMap);
		
		String medicineName = service.showMedicineName(paraMap);				
		
		// System.out.println("약이름 : "+medicineName);
		
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("medicineName", medicineName);				
		
		return jsonObj.toString();
		
	}
	
	
	
	// <%-- 약 약처방 확정후 처방테이블로 insert하기 --%> //
	@PostMapping("medicineSubmit")
	@ResponseBody
	public int medicineSubmit(HttpServletRequest request, @RequestBody List<OrderVO> ovo) {
				
		System.out.println("잘오니 : "+ovo);
		
		List<Map<String, String>> mapList = new ArrayList<>();		
				
		for(OrderVO OrderVO : ovo) {
			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("fk_order_no", OrderVO.getFk_order_no());
	        paraMap.put("prescribe_name", OrderVO.getPrescribe_name());
	        paraMap.put("prescribe_beforeafter", OrderVO.getPrescribe_beforeafter());
	        paraMap.put("prescribe_morning", OrderVO.getPrescribe_morning());
	        paraMap.put("prescribe_afternoon", OrderVO.getPrescribe_afternoon());
	        paraMap.put("prescribe_night", OrderVO.getPrescribe_night());
	        paraMap.put("prescribe_perday", OrderVO.getPrescribe_perday());			
			
			mapList.add(paraMap);			
			
		}
		
		System.out.println("맵리스트요: "+mapList);
		
		int n = service.medicineSubmit(mapList);
		
		return n ;
	}
	
	
	
	// 처방전 페이지 보여주기 보류중 @@@@@@@@@@@@@@@@@@@@@@
	@GetMapping("orderNpay")
	public ModelAndView orderNpayView(HttpServletRequest request, ModelAndView mav) {		
		
	
		
		mav.setViewName("content/order/orderNpay");
		
		return mav;
	}
	
	// 입원 요청하여 입원테이블에 insert 하기 (트랜잭션)
	@PostMapping("requestHosp")
	@ResponseBody
	public int requestHosp(HttpServletRequest request, Map<String, String> paraMap) {
			
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String fk_member_userid = loginuser.getMember_userid();		
		String orderNo = request.getParameter("orderNo");
		String hiddenPatientNo = request.getParameter("hiddenPatientNo");
		
		// System.out.println("맞잖아요"+hiddenPatienNo);
		
		paraMap.put("fk_member_userid", fk_member_userid);
		paraMap.put("orderNo", orderNo);		
		paraMap.put("hiddenPatientNo", hiddenPatientNo);
		
		int n = service.requestHosp(paraMap); // 입원 요청하여 입원테이블에 insert 하기
		
		if(n==1) {
			System.out.println("되쓰");
		}
		else {
			System.out.println("?");
		}
		
		return n;
		
	}
	
	// 수술 요청하여 수술테이블에 insert 하기 (트랜잭션)
	@PostMapping("surgeryConfirm")
	@ResponseBody
	public int surgeryConfirm(HttpServletRequest request, Map<String, String> paraMap) {
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String fk_member_userid = loginuser.getMember_userid();		
		String orderNo = request.getParameter("orderNo");
		String hiddenPatientNo = request.getParameter("hiddenPatientNo");
		String surgeryType_name = request.getParameter("surgeryType_name");
		String surgery_description = request.getParameter("surgery_description");
		
		paraMap.put("fk_member_userid", fk_member_userid);
		paraMap.put("orderNo", orderNo);		
		paraMap.put("hiddenPatientNo", hiddenPatientNo);
		paraMap.put("surgeryType_name", surgeryType_name);
		paraMap.put("surgery_description", surgery_description);
		
		int n = service.surgeryConfirm(paraMap);
		
		return n;
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
