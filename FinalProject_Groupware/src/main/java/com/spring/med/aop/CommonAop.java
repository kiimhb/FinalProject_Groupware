package com.spring.med.aop;

import java.io.IOException;
import java.util.Map;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.spring.med.board.service.BoardService;
import com.spring.med.common.MyUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


// AOP (Aspect Oriented Programming)
@Aspect
@Component
public class CommonAop {

	// === Pointcut(주업무) 설정 === //
	@Pointcut("execution(public * com.spring.med..*Controller.requiredLogin_*(..) )")	
	public void requiredLogin() {}
	
	// === Before Advice(공통관심사, 보조업무) 구현 === //
	@Before("requiredLogin()")
	public void loginCheck(JoinPoint joinpoint) {	// 로그인 유무 검사를 하는 메소드

		HttpServletRequest request = (HttpServletRequest)joinpoint.getArgs()[0];	// 주업무 메소드의 첫번째 파라미터 
		HttpServletResponse response = (HttpServletResponse)joinpoint.getArgs()[1];	// 주업무 메소드의 두번째 파라미터
		/*
			// pointcut(주업무) 파라미터 순서
			public ModelAndView requiredLogin_???(HttpServletRequest request, HttpServletResponse response, ...)          
		*/
		
		HttpSession session = request.getSession();


		if(session.getAttribute("loginuser") == null) {
			
			String message = "먼저 로그인 하세요~~ (AOP Before Advice 활용)";
			String loc = request.getContextPath() + "/member/login";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
		
			// === 로그인 성공 후에는 로그인 하기 전 페이지로 돌아가는 작업 만들기 === //
			String url =MyUtil.getCurrentURL(request);
			session.setAttribute("goBackURL", url);   // 세션에 url 정보를 저장
			
			RequestDispatcher dispatcher =  request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
			try {
				dispatcher.forward(request, response);
			} catch (ServletException | IOException e) {
				e.printStackTrace();
			}	
		}
		
		
	}// end of public void loginCheck(JoinPoint joinpoint) {}-------------------------------------------
	
	
		
		
		
		// ===== Around Advice(보조업무) 만들기 ====== // 
		
		
		
		
		
		
	}
