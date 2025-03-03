package com.spring.med.interceptor.controller;

import java.util.logging.Handler;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@Component
public class LoginCheckInterceptor implements HandlerInterceptor { 	
	
	@Override
	public boolean preHandle(HttpServletRequest request, 
							 HttpServletResponse response, 
							 Object handler) throws Exception { 
		
		/* 
	    	preHandle() 메소드는 지정된 컨트롤러의 동작 이전에 호출된다. 
	        preHandle() 메소드에서 false를 리턴하면 다음 내용(Controller의 동작)을 실행하지 않는다. 
	        true를 리턴하면 다음 내용(Controller의 동작)을 실행하게 된다.
		*/
		
	
		// ==== 로그인 여부 검사 ==== //		
		HttpSession session = request.getSession();
		
		/*if(session.getAttribute("loginuser") == null) {
			
			// 로그인이 되지 않은 상태
			String message = "먼저 로그인 하세요.";
			String loc = request.getContextPath()+"/member/login";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			RequestDispatcher dispatcher =  request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
			dispatcher.forward(request, response);
			
			return false;
		}*/
		
		return true;
	}

	
}
