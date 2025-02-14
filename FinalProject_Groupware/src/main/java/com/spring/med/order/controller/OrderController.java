package com.spring.med.order.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/order/*")
public class OrderController {

	
	@GetMapping("orderEnter")
	public ModelAndView orderEnter(HttpServletRequest request, ModelAndView mav) {
		
		// List<TreatPatientVO> patientList = null;
		
		
		//patientList = service.selectPatientWaiting();

		// mav.addObject(patientList);
		mav.setViewName("content/order/orderEnter");
		
		return mav;
	}
	
	
}
