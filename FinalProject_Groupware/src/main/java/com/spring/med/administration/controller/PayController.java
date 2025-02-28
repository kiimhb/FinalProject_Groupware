package com.spring.med.administration.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.administration.service.PayService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/pay/*")
public class PayController {
	
	@Autowired
	private PayService service;
	
	// 수납대기조회 (페이징 처리하기)
	@GetMapping("wait")
	public ModelAndView pay_wait(HttpServletRequest request, ModelAndView mav,
								 @RequestParam(defaultValue = "1") String currentShowPageNo,
								 @RequestParam(defaultValue = "0") String order_status,
								 @RequestParam(defaultValue = "") String patientname) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("order_status", order_status);
		paraMap.put("patientname", patientname);
		

		int totalCount = 0;          // 총 게시물 건수
		int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int n_currentShowPageNo = 0;
		
		totalCount = service.getTotalCount(paraMap); // 수납상태와 검색어에 따른 총 수납개수
		
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
		
		// 수납대기 또는 수납 완료 목록 
		List<Map<String, String>> pay_list = service.pay_list(paraMap);
		
		mav.addObject("pay_list", pay_list);

		// 페이지바 만들기 //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "wait";
		
		pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&order_status="+order_status+"&currentShowPageNo=1'><<</a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&order_status="+order_status+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>"+pageNo+"</li>"; 
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&order_status="+order_status+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while-------------------------------
		
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&order_status="+order_status+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
		}
		
		pageBar += "<li style='display:inline-block; width:70px;  font-size:12pt;'><a href='"+url+"?patientname="+patientname+"&order_status="+order_status+"&currentShowPageNo="+totalPage+"'>>></a></li>";
					
		pageBar += "</ul>";	
		
		mav.addObject("pageBar", pageBar);
		mav.addObject("order_status", order_status);
		
		///////////////////////////////////////////////////////////

		mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		
		mav.setViewName("content/administration/pay");
		return mav;
	}
	
	// 수납처리완료
	@PostMapping("success")
	public String pay_success(ModelAndView mav,
									@RequestParam List<String> order_no) {	
		// 수납처리하기
		service.pay_success(order_no);
		
		return "redirect:/pay/wait";
	}	 
	

	
}
