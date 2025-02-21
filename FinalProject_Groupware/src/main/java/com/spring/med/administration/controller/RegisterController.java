package com.spring.med.administration.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.spring.med.administration.service.RegisterService;
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
									  @RequestParam(defaultValue = "1") String currentShowPageNo) {
		
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

		///////////////////////////////////////////////////////////
		
		mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		mav.setViewName("content/administration/register");
		return mav;
	}
	
	// 수술예약
	@GetMapping("surgery/{order_no}")
	@ResponseBody
	public ModelAndView surgery_form(HttpServletRequest request, ModelAndView mav,
									 @PathVariable String order_no,
									 @RequestParam Map<String, String> paraMap) {
		
		String name = service.getPatientName(order_no); // 환자명 알아오기
		List<SurgeryroomVO> surgeryroom = service.getSurgeryRoom();

		mav.addObject("surgeryroom", surgeryroom);
		mav.addObject("order_no", order_no);
		mav.addObject("name", name);
		
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
	
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("surgery_surgeryroom_name", surgery_surgeryroom_name);
		paraMap.put("surgery_day", surgery_day);

		// 예약 가능한 시간찾기
		return service.oktime(paraMap);
	}
	
	
	
	// 예약하기 
	@PostMapping("/success")
	public ResponseEntity<String> registerSuccess(@ModelAttribute SurgeryVO surgeryvo) {
		// System.out.println(surgeryvo.toString());
		
		//service.surgeryRegister(surgeryvo); // 예약하기 insert
		
		return ResponseEntity.ok("수술 예약이 완료되었습니다.");
	}
	
	// 입원예약
	@GetMapping("hospitalization")
	public ModelAndView hospitalization_form(HttpServletRequest request, ModelAndView mav) {
		mav.setViewName("content/administration/hospitalRegister");
		return mav;
	}
	
}
