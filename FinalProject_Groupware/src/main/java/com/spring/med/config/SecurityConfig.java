package com.spring.med.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

import jakarta.servlet.DispatcherType;

// ===== (#스프링보안05) Spring Security ===== 

@Configuration        // Spring 컨테이너가 처리해주는 클래스로서, 클래스내에 하나 이상의 @Bean 메소드를 선언만 해주면 런타임시 해당 빈에 대해 정의되어진 대로 요청을 처리해준다. 
@EnableWebSecurity    // SecurityConfig 클래스로 시큐리티를 제어하고 싶다면 @EnableWebSecurity 어노테이션을 해주어야 한다. 
                      // 만약에 @EnableWebSecurity을 어노테이션을 붙이지 않으면 인덱스 홈페이지가 "/login"으로 리다이렉션된다. 
@EnableMethodSecurity
public class SecurityConfig { 

   @Bean
   public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
   
      http
          .csrf((csrfConfig) -> csrfConfig
             .disable()
          );
      
      http
           .authorizeHttpRequests((auth) -> auth
                    .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()  // DispatcherType 을 import 시 jakarta.servlet.DispatcherType 으로 함.
                    .requestMatchers("/**").permitAll()
                    .anyRequest().permitAll()     // 위에서 설정한 페이지를 제외한 나머지 다른 모든 페이지는 허용한다. 즉, 로그인을 하지 않아도 접속이 된다.  
           );
      
      http
         .headers((headerConfig) -> headerConfig
                  .frameOptions((frameOptionsConfig) -> frameOptionsConfig
                        .sameOrigin())
         ); 
      
      return http.build(); // 메소드로 빈을 생성하는 것이므로 return 해줘야 한다.
   }
   
   @Bean
   public HttpFirewall httpFirewall() {
       StrictHttpFirewall strictHttpFirewall = new StrictHttpFirewall();
       strictHttpFirewall.setAllowUrlEncodedDoubleSlash(true);
       return strictHttpFirewall;
   }
  
}
