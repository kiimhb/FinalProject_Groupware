package com.spring.med.management.service;

import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

public interface ManagementService {

	ModelAndView login(ModelAndView mav, HttpServletRequest request, Map<String, String> paraMap);

	ModelAndView logout(ModelAndView mav, HttpServletRequest request);

}
