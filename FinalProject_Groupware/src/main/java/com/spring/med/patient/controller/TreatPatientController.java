package com.spring.med.patient.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.patient.domain.TreatPatientVO;
import com.spring.med.patient.service.TreatPatientService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@Controller
@RequestMapping(value="/patient/*")
public class TreatPatientController {
	/*
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private TreatPatientService service;
	*/
	
	
	@GetMapping("patientWaiting")
	public ModelAndView selectPatientWaiting(HttpServletRequest request, ModelAndView mav) {
		
		// List<TreatPatientVO> patientList = null;
		
		
		//patientList = service.selectPatientWaiting();

		// mav.addObject(patientList);
		mav.setViewName("content/patient/patientWaiting");
		
		return mav;
	}
	
	

}
