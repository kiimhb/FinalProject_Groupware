package com.spring.med.administration.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.administration.domain.Calendar_hospitalize_recordVO;
import com.spring.med.administration.domain.Calendar_patient_recordVO;
import com.spring.med.administration.domain.Calendar_surgery_recordVO;
import com.spring.med.administration.service.RegisterService;
import com.spring.med.hospitalize.domain.HospitalizeVO;
import com.spring.med.hospitalize.domain.HospitalizeroomVO;
import com.spring.med.surgery.domain.*;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/register/*")
public class RegisterController {
	
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private RegisterService service;
	
	// 환자조회 
	@GetMapping("list")
	public ModelAndView register_list(HttpServletRequest request, ModelAndView mav,
									  @RequestParam(defaultValue = "1") String currentShowPageNo,
									  @RequestParam(defaultValue = "1") String currentShowPageNo2) {
		
		// ***** 수술 대기 목록 조회 시작 ***** //
		int totalCount = 0;          // 총 게시물 건수
		int sizePerPage = 5;         // 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int n_currentShowPageNo = 0;
		
		totalCount = service.getTotalCount(); // 진료기록이 있는 총 환자수 (totalCount)
		// System.out.println("totalCount"+totalCount);
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage); // 총 페이지수
		
		try {
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				n_currentShowPageNo = 1;
			}
		} catch(NumberFormatException e) {
			n_currentShowPageNo = 1;
		}
		
		int startRno = ((n_currentShowPageNo - 1) * sizePerPage) + 1;
		int endRno = startRno + sizePerPage - 1;
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		List<Map<String, String>> register_list = service.register_list(paraMap);
		
		mav.addObject("register_list", register_list);
		
		// 페이지바 만들기 //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "list";
		
		pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?currentShowPageNo=1'><<</a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>"+pageNo+"</li>"; 
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while-------------------------------
		
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
		}
		
		pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?currentShowPageNo="+totalPage+"'>>></a></li>";
					
		pageBar += "</ul>";	
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		// ***** 수술 대기 목록 조회 끝 ***** //
		
		
		///////////////////////////////////////////////////////////
		
		// ***** 입원 대기 목록 조회 시작 ***** //
		int totalCount2 = 0;          // 총 게시물 건수
		int sizePerPage2 = 5;         // 한 페이지당 보여줄 게시물 건수
		int totalPage2 = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int n_currentShowPageNo2 = 0;
		
		totalCount2 = service.getTotalCount2(); // 진료기록이 있는 총 입원대기 환자수 (totalCount)
		
		totalPage2 = (int) Math.ceil((double)totalCount2/sizePerPage2); // 총 페이지수
		
		try {
			n_currentShowPageNo2 = Integer.parseInt(currentShowPageNo2);
			
			if(n_currentShowPageNo2 < 1 || n_currentShowPageNo2 > totalPage2) {
				n_currentShowPageNo2 = 1;
			}
		} catch(NumberFormatException e) {
			n_currentShowPageNo2 = 1;
		}
		
		int startRno2 = ((n_currentShowPageNo2 - 1) * sizePerPage2) + 1;
		int endRno2 = startRno2 + sizePerPage2 - 1;
		
		Map<String, String> paraMap2 = new HashMap<>();
		paraMap2.put("startRno2", String.valueOf(startRno2));
		paraMap2.put("endRno2", String.valueOf(endRno2));
		paraMap2.put("currentShowPageNo2", currentShowPageNo2);
		
		// 입원 대기 목록 리스트
		List<Map<String, String>> hospitalize_list = service.hospitalize_list(paraMap2);
		
		mav.addObject("hospitalize_list", hospitalize_list);
		
		// 페이지바 만들기 //
		int blockSize2 = 10;
		
		int loop2 = 1;
		
		int pageNo2 = ((n_currentShowPageNo2 - 1)/blockSize2) * blockSize2 + 1;
		
		String pageBar2 = "<ul style='list-style:none;'>";
		String url2 = "list";
		
		pageBar2 += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url2+"?currentShowPageNo2=1'><<</a></li>";
		
		if(pageNo2 != 1) {
			pageBar2 += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url2+"?currentShowPageNo2="+(pageNo2-1)+"'>[이전]</a></li>"; 
		}
		
		
		while( !(loop2 > blockSize2 || pageNo2 > totalPage2) ) {
			
			if(pageNo2 == Integer.parseInt(currentShowPageNo2)) {
				pageBar2 += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>"+pageNo2+"</li>"; 
			}
			else {
				pageBar2 += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url2+"?currentShowPageNo2="+pageNo2+"'>"+pageNo2+"</a></li>"; 
			}
			
			loop2++;
			pageNo2++;
		}// end of while-------------------------------
		
		
		// === [다음][마지막] 만들기 === //
		if(pageNo2 <= totalPage2) {
			pageBar2 += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url2+"?currentShowPageNo2="+pageNo2+"'>[다음]</a></li>"; 	
		}
		
		pageBar2 += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url2+"?currentShowPageNo2="+totalPage2+"'>>></a></li>";
					
		pageBar2 += "</ul>";	
		
		mav.addObject("pageBar2", pageBar2);
		
		mav.addObject("totalCount2", totalCount2);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("currentShowPageNo2", currentShowPageNo2); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("sizePerPage2", sizePerPage2); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임		
		// ***** 입원 대기 목록 조회 끝***** //

		mav.setViewName("content/administration/register");
		return mav;
	}
	
	// 수술 예약 페이지 보여주기 
	@GetMapping("surgery/{order_no}")
	@ResponseBody
	public ModelAndView surgery_form(HttpServletRequest request, ModelAndView mav,
									 @PathVariable String order_no) {
		
		String name = service.getPatientName(order_no); // 환자명 알아오기
		String surgery_description = service.surgery_description(order_no); // 수술 설명 불러오기 
		List<SurgeryroomVO> surgeryroom = service.getSurgeryRoom(); // 수술실 목록 불러오기 (select)
		
		mav.addObject("surgeryroom", surgeryroom);
		mav.addObject("order_no", order_no);
		mav.addObject("name", name);
		mav.addObject("surgery_description", surgery_description);
		
		mav.setViewName("content/administration/surgeryRegister");
		return mav;
	}
	
	
	// 수술실과 날짜를 받아서 가능한 시간 출력하기
	@GetMapping("oktime")
	@ResponseBody
	public List<String> okTime(@RequestParam int surgeryroom_no, 
							   @RequestParam String surgery_day) {
		
		String surgery_surgeryroom_name = "";
		
		if(surgeryroom_no == 1) {
			surgery_surgeryroom_name = "roomA";
		}
		else if(surgeryroom_no == 2) {
			surgery_surgeryroom_name = "roomB";
		}
		if(surgeryroom_no == 3) {
			surgery_surgeryroom_name = "roomC";
		}
		else if(surgeryroom_no == 4) {
			surgery_surgeryroom_name = "roomD";
		}
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("surgery_surgeryroom_name", surgeryroom_no);
		paraMap.put("surgery_day", surgery_day);
		
		// 예약 가능한 시간찾기
		return service.oktime(paraMap);
	}
	
	// 예약이 있는 시간 모두 가져오기
	@PostMapping("reservedTime")
	@ResponseBody
	public List<Map<String, String>> reservedTime(@RequestParam int surgeryroom_no, 
									 			  										@RequestParam String surgery_day) {
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("surgery_surgeryroom_name", surgeryroom_no);
		paraMap.put("surgery_day", surgery_day);
		
		List<Map<String, String>> reservedTime = service.reservedTime(paraMap);
		// System.out.println("reservedTime"+reservedTime);
		// reservedTime[{surgery_start_time=14:00, surgery_end_time=15:30}]
		return reservedTime;
	}
	
	// 수술 예약하기 클릭 (예약하기) 
	@PostMapping("/success")
	public ResponseEntity<Map<String,String>> registerSuccess(@ModelAttribute SurgeryVO surgeryvo) {
		
		String jubun = service.getJubun(surgeryvo); // 주민번호 알아오기 (환자가 같은 날 한개 이상의 수술을 예약하는 것을 방지하기 위함)
		
		Map<String, String> response = new HashMap<>();
		
		try {
			service.surgeryRegister(surgeryvo, jubun); // 예약하기 insert
			response.put("message", "수술 예약이 완료되었습니다.");
			return ResponseEntity.ok(response);
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", e.getMessage()); // service 단의 예외 메시지 그대로 반환해준다. 
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}
	}
	
	// 수술 일정 수정하기
	@PatchMapping("surgeryUpdate")
	@ResponseBody
	public ResponseEntity<Map<String,String>> surgeryUpdate(@RequestParam("fk_order_no") String fk_order_no,
															@RequestParam("surgery_surgeryroom_name") String surgery_surgeryroom_name,
															@RequestParam("surgery_day") String surgery_day,
															@RequestParam("surgery_start_time") String surgery_start_time,
															@RequestParam("surgery_end_time") String surgery_end_time,
															@RequestParam("jubun") String jubun) { 
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_order_no", fk_order_no);
		paraMap.put("surgery_surgeryroom_name", surgery_surgeryroom_name);
		paraMap.put("surgery_day", surgery_day);
		paraMap.put("surgery_start_time", surgery_start_time);
		paraMap.put("surgery_end_time", surgery_end_time);
		paraMap.put("jubun", jubun);
		
		Map<String, String> response = new HashMap<>();
		
		try {
			service.surgeryUpdate(paraMap); // 새로운 수술일정 update 하기
			response.put("message", "수술 일정이 변경 되었습니다.");
			return ResponseEntity.ok(response);
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", e.getMessage()); // service 단의 예외 메시지 그대로 반환해준다. 
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}
	}
	
	// 수술 스케줄 캘린더 조회
	@ResponseBody
	@GetMapping(value="surgerySchedule", produces="text/plain;charset=UTF-8")
	public String surgerySchedule(HttpServletRequest request) {
		
		// 수술 현황 
		List<Calendar_surgery_recordVO> surgerySchedule = service.surgerySchedule(); 
		
		JSONArray jsArr = new JSONArray();
		
		if(surgerySchedule != null && surgerySchedule.size() > 0) {
			
			for(Calendar_surgery_recordVO svo : surgerySchedule) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("surgery_no", svo.getSurgery_no());
				jsObj.put("surgery_surgeryroom_name", svo.getSurgery_surgeryroom_name());
				jsObj.put("surgery_day", svo.getSurgery_day());
				jsObj.put("surgery_start_time", svo.getSurgery_start_time());
				jsObj.put("surgery_end_time", svo.getSurgery_end_time());
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		}

		return jsArr.toString();
	}
	
	// ************************************************************* //
	// **************************** 입원 **************************** //
	// 입원예약
	@GetMapping("hospitalization/{order_no}")
	@ResponseBody
	public ModelAndView hospitalization_form(HttpServletRequest request, ModelAndView mav,
											 									@PathVariable String order_no) {
		
		String name = service.getPatientName(order_no); // 환자명 알아오기
		String order_howlonghosp = service.order_howlonghosp(order_no); // 입원일수 알아오기 

		mav.addObject("name", name);
		mav.addObject("order_no", order_no); // 차트번호
		mav.addObject("order_howlonghosp", order_howlonghosp); // 입원 일수

		mav.setViewName("content/administration/hospitalRegister");
		return mav;
	}
	
	// 입원일, 퇴원일에 따른 입원실 잔여석 알아오기 
	@GetMapping("okroom")
	@ResponseBody
	public List<Map<String, String>> okroom(@RequestParam String hospitalize_start_day,
										    @RequestParam String hospitalize_end_day) {

		   Map<String, String> paraMap = new HashMap<>();
		   paraMap.put("hospitalize_start_day", hospitalize_start_day);
		   paraMap.put("hospitalize_end_day", hospitalize_end_day);
			
		   List<Map<String, String>> okSeat = service.okSeat(paraMap); // 입원실 잔여석 가져오기
		
		   return okSeat;	
	}
	
	
	// 입원예약완료하기
	@PostMapping("successreserve")
	@ResponseBody
	public ResponseEntity<Map<String,String>> successreserve(@ModelAttribute HospitalizeVO hospitalizevo) {
		
		String jubun = service.jubunGet(hospitalizevo); // 중복 입원 확인을 위해 주민번호 알아오기
		// System.out.println("jubun"+ jubun);
		Map<String, String> response = new HashMap<>();
		
		try {
			service.hospitalizeRegister(hospitalizevo, jubun); // 입원 예약하기 update
			response.put("message", "입원 예약이 완료되었습니다.");
			return ResponseEntity.ok(response);
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", e.getMessage()); // service 단의 예외 메시지 그대로 반환해준다. 
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}

	}
	
	
	
	// 입원 일정 수정하기
	@PatchMapping("hospitalizeUpdate")
	@ResponseBody
	public ResponseEntity<Map<String,String>> hospitalizeUpdate(@RequestParam("fk_order_no") String fk_order_no,
																@RequestParam("hospitalize_no") String hospitalize_no,
																@RequestParam("fk_hospitalizeroom_no") String fk_hospitalizeroom_no,
																@RequestParam("hospitalize_start_day") String hospitalize_start_day,
																@RequestParam("hospitalize_end_day") String hospitalize_end_day,
																@RequestParam("jubun") String jubun) { 
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_order_no", fk_order_no);
		paraMap.put("hospitalize_no", hospitalize_no);
		paraMap.put("hospitalize_start_day", hospitalize_start_day);
		paraMap.put("hospitalize_end_day", hospitalize_end_day);
		paraMap.put("fk_hospitalizeroom_no", fk_hospitalizeroom_no);
		paraMap.put("jubun", jubun);
		
		Map<String, String> response = new HashMap<>();
		
		try {
			service.hospitalizeUpdate(paraMap); // 새로운 입원일정 update 하기
			response.put("message", "입원 일정이 변경 되었습니다.");
			return ResponseEntity.ok(response);
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", e.getMessage()); // service 단의 예외 메시지 그대로 반환해준다. 
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
		}
	}

	// 입원 스케줄 캘린더 조회
	@ResponseBody
	@GetMapping(value="hospitalizeSchedule", produces="text/plain;charset=UTF-8")
	public String hospitalizeSchedule(HttpServletRequest request) {
		
		// 입원실 현황 
		List<Calendar_hospitalize_recordVO> hospitalizeScheduleList = service.hospitalizeScheduleList();
		
		JSONArray jsArr = new JSONArray();
		
		if(hospitalizeScheduleList != null && hospitalizeScheduleList.size() > 0) {
			
			for(Calendar_hospitalize_recordVO hvo : hospitalizeScheduleList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("hospitalize_no", hvo.getHospitalize_no());
				jsObj.put("fk_hospitalizeroom_no", hvo.getFk_hospitalizeroom_no());
				jsObj.put("hospitalize_start_day", hvo.getHospitalize_start_day());
				jsObj.put("hospitalize_end_day", hvo.getHospitalize_end_day());
				jsObj.put("patient_name", hvo.getPatient_name());
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		}

		return jsArr.toString();
	}
	
	
	
	
	
}
