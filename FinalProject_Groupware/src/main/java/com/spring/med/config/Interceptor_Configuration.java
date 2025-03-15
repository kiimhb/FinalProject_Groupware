package com.spring.med.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.spring.med.interceptor.controller.LoginCheckInterceptor;

@Configuration
public class Interceptor_Configuration implements WebMvcConfigurer {

	// ==== 로그인 Interceptor 설정 ==== //
	@Autowired
	LoginCheckInterceptor loginCheckInterceptor;


	// 그룹웨어와 같이 모든 페이지에 로그인해야 하는 경우 아래처럼 전체경로를 추가하고 특정 경로를 제외시키도록 한다.
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
	     registry.addInterceptor(loginCheckInterceptor)
	             .addPathPatterns("/**/*") // 해당 경로에 접근하기 전에 인터셉터가 가로챈다.
	             .excludePathPatterns("/management/login","/image/**");
	     //  addInterceptor() : 인터셉터를 등록해준다.
	     //   addPathPatterns() : 인터셉터를 호출하는 주소와 경로를 추가한다. 
	     //   excludePathPatterns() : 인터셉터 호출에서 제외하는 주소와 경로를 추가한다. 
	 }


	
}
