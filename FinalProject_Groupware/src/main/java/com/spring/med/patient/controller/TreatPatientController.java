package com.spring.med.patient.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.MyUtil;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.patient.domain.TreatPatientVO;
import com.spring.med.patient.service.TreatPatientService;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/patient/*")
public class TreatPatientController {
	
	
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private TreatPatientService service;
	
	
	// 접수 후 대기하고 있는 환자 리스트 페이징 하여 보기
	@GetMapping("patientWaiting")
	public ModelAndView selectPatientWaiting(HttpServletRequest request, HttpServletResponse response, ModelAndView mav,@RequestParam(defaultValue = "1") String currentShowPageNo) {
						
		HttpSession session = request.getSession();		
		// System.out.println("세션 : "+session.getAttribute("loginuser"));
						
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		if(session.getAttribute("loginuser") == null) {
			
			mav.setViewName("content/management/login");
		}
		else {				
		
		String member_userid = loginuser.getMember_userid();
	
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("member_userid", member_userid);
		
		int totalCount = 0;          // 총 게시물 건수
		int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int n_currentShowPageNo = 0;
		
		totalCount = service.getTotalCount(paraMap); // 진료기록이 있는 총 환자수 (totalCount)
		
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
		
		//System.out.println("startRno : "+startRno);
		//System.out.println("endRno : "+endRno);
		
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		//System.out.println("paraMap : "+paraMap);
		
		List<Map<String, String>> patientList = service.selectPatientWaiting(paraMap);
		
		//System.out.println(patientList);
		
		mav.addObject("patientList", patientList);
		
		// 페이지바 만들기 //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "patientWaiting";
		
		pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?currentShowPageNo=1'>[맨처음]</a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>"; 
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
		
		pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
					
		pageBar += "</ul>";	
		
		mav.addObject("pageBar", pageBar);
		 
		
		///////////////////////////////////////////////////////////

		mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		
		mav.setViewName("content/patient/patientWaiting");
		}
		return mav;
	}
	
	
	// === 신규, 기존환자 등록및 접수 페이지 보여주기 
	@GetMapping("patientReg")
	public ModelAndView patientReg(HttpServletRequest request, ModelAndView mav, String patient_jubun) {
		
		
		HttpSession session = request.getSession();		
		// System.out.println("세션 : "+session.getAttribute("loginuser"));						
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		if(session.getAttribute("loginuser") == null) {

			
			mav.setViewName("content/management/login");
		}
		else {
	
		mav.setViewName("content/patient/patientReg");
		}
		
		return mav;
	}
	
	// === 검색어 입력시 자동글 완성하기 3 === //
	@GetMapping("wordSearchShow")
	@ResponseBody
	public List<Map<String, String>> wordSearchShow(@RequestParam Map<String, String> paraMap) {
		
		List<String> wordList = service.wordSearchShow(paraMap); 
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(wordList != null) {
			for(String word : wordList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				mapList.add(map);
			}// end of for-------------
		}
		
		return mapList;

	}
	
	
	// === 진료- 기존환자 조회에서 검색된 환자 정보 보여주기 
	@GetMapping("existPatientShow")
	@ResponseBody
	public List<TreatPatientVO> existPatientShow(HttpServletRequest request, String patient_jubun){
		
		patient_jubun = request.getParameter("searchWord");
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("patient_jubun", patient_jubun);
		
		// System.out.println(paraMap);
		
		List<TreatPatientVO> existPatientList = service.existPatientShow(paraMap);		
		
		// System.out.println(existPatientList);
				
		return existPatientList;
	}
	
	
	// === 기존환자 조회에서 등록 및 접수 update 하기
	@PostMapping("submitNcheck2")
	@ResponseBody
	public void submitNcheck2 (HttpServletRequest request) {
		
		String patient_symptom = request.getParameter("patient_symptom");
		String patient_no = request.getParameter("patient_no");
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("patient_symptom", patient_symptom);
		paraMap.put("patient_no", patient_no);
		
		// System.out.println(paraMap);
		
		int n = service.submitNcheck2(paraMap);
		
		if(n==1) {
			System.out.println("데이터 전송 성공");
		}

	}
	
	// === 신규환자 정보 입력하여 등록 및 접수 insert 하기
	@PostMapping("submitNcheck1")
	@ResponseBody
	public Map<String, Object> submitNcheck1(TreatPatientVO tpvo) {
		
	
		int n = service.submitNcheck1(tpvo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("patient_name", tpvo.getPatient_name());
		map.put("patient_jubun", tpvo.getPatient_jubun());
		map.put("fk_child_dept_no", tpvo.getFk_child_dept_no());
		map.put("patient_gender", tpvo.getPatient_gender());
		map.put("patient_symptom", tpvo.getPatient_symptom());

		
		System.out.println(map);
		
		return map;
		
		
	
	}
	
	
	
	
	
	

}
