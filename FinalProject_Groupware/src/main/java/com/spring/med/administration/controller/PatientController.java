package com.spring.med.administration.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.administration.domain.Calendar_patient_recordVO;
import com.spring.med.administration.service.PatientService;
import com.spring.med.patient.domain.PatientVO;
import com.spring.med.surgery.domain.SurgeryroomVO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/patient/*")
public class PatientController {
	
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private PatientService service;
	
	// 환자조회 + 페이징 처리
	@GetMapping("list")
	public ModelAndView patientList(HttpServletRequest request, ModelAndView mav
								   ,@RequestParam(defaultValue = "") String patientname
								   ,@RequestParam(defaultValue = "1") String currentShowPageNo) {
		
		// List<PatientVO> patientList = null;
		
		patientname = patientname.trim(); // 공백제거
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("patientname", patientname);
		
		int totalCount = 0;          // 총 게시물 건수
		int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int n_currentShowPageNo = 0;
		
		totalCount = service.getTotalCount(paraMap); // 진료기록이 있는 총 환자수 (totalCount)
		// System.out.println("totalCount" + totalCount);
		
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
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		List<Map<String, String>> patientList = service.patientList(paraMap);
		
		mav.addObject("patientList", patientList);
		
		// 페이지바 만들기 //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "list";
		
		pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&currentShowPageNo=1'><<</a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>"+pageNo+"</li>"; 
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while-------------------------------
		
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
		}
		
		pageBar += "<li style='display:inline-block; width:70px;  font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&currentShowPageNo="+totalPage+"'>>></a></li>";
					
		pageBar += "</ul>";	
		
		mav.addObject("pageBar", pageBar);
		 
		
		///////////////////////////////////////////////////////////

		mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		
		mav.setViewName("content/administration/patient"); 
		return mav;
		 
	}
	
	
	// 환자상세조회 
	@GetMapping("detail/{seq}")
	public ModelAndView detail_patient(HttpServletRequest request, ModelAndView mav,
									   @PathVariable String seq) { // seq = 환자번호 patient_no
		
		String jubun = service.getJubun(seq); // 주민번호로 환자 구분 하기위함
		
		Map<String, String> detail_patient = service.detail_patient(seq); // 환자 기본 정보
		List<Map<String, String>> order_list = service.order_list(jubun); // 개인별 환자 진료목록
		List<Map<String, Object>> surgery_list = service.surgery_list(jubun); // 환자 수술기록
		List<SurgeryroomVO> surgeryroom = service.getSurgeryRoom(); // 수술실 목록 불러오기 (select)
		List<Map<String, Object>> hospitalize_list = service.hospitalize_list(jubun); // 환자 입원기록 
		
		if (surgery_list == null || surgery_list.isEmpty()) {
	        mav.addObject("surgeryMessage", "수술 기록이 없습니다.");
	    }
		if (hospitalize_list == null || hospitalize_list.isEmpty()) {
	        mav.addObject("hospitalizeMessage", "입원 기록이 없습니다.");
	    }
			
		mav.addObject("detail_patient", detail_patient);
		mav.addObject("order_list", order_list);
		mav.addObject("surgery_list", surgery_list);
		mav.addObject("surgeryroom", surgeryroom);
		mav.addObject("patient_no", seq);
		mav.addObject("hospitalize_list", hospitalize_list);
		mav.addObject("jubun", jubun);
		
		mav.setViewName("content/administration/detailPatient");
		return mav;
	}
	
	// 환자별 일정 조회하기 (진료, 수술, 입원)
	@ResponseBody
	@GetMapping(value="selectSchedule", produces="text/plain;charset=UTF-8")
	public String selectSchedule(HttpServletRequest request) {
		
		// 등록된 일정 가져오기
		String jubun = request.getParameter("jubun");
		
		List<Calendar_patient_recordVO> scheduleList = service.selectSchedule(jubun);
		
		JSONArray jsArr = new JSONArray();
		
		if(scheduleList != null && scheduleList.size() > 0) {
			
			for(Calendar_patient_recordVO cvo : scheduleList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("order_no", cvo.getOrder_no());
				jsObj.put("patient_visitdate", cvo.getPatient_visitdate());
				jsObj.put("hospitalize_start_day", cvo.getHospitalize_start_day());
				jsObj.put("hospitalize_end_day", cvo.getHospitalize_end_day());
				jsObj.put("surgery_day", cvo.getSurgery_day());
				jsObj.put("surgery_start_time", cvo.getSurgery_start_time());
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		}

		return jsArr.toString();
	}
	
}
