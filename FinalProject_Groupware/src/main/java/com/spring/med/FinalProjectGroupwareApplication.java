package com.spring.med;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@SpringBootApplication
@EnableAspectJAutoProxy  // AOP(Aspect Oriented Programming)클래스를 사용 ==> com.spring.med.aop.CommonAop 이 AOP 클래스
public class FinalProjectGroupwareApplication {

	public static void main(String[] args) {
		SpringApplication.run(FinalProjectGroupwareApplication.class, args);
	}

}
