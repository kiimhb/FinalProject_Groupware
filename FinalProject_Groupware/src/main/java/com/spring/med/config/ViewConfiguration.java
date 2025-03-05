package com.spring.med.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.web.servlet.ViewResolver;
// import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

// import com.spring.med.excel.ExcelDownloadView;

@Configuration  
public class ViewConfiguration {

	@Bean
	@Order(0)
	ViewResolver viewResolver() {
		InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
		viewResolver.setOrder(0);
		viewResolver.setViewClass(JstlView.class);
		viewResolver.setPrefix("/WEB-INF/views/");	// 접두어
		viewResolver.setSuffix(".jsp");				// 접미어

		return viewResolver;
	}

}
