package com.spring.med.config;

import java.io.UnsupportedEncodingException;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.spring.med.common.AES256;

@Configuration   
public class AES256_Configuration {
    
	@Bean 
    AES256 aes() { 
    	AES256 aes;
		try {
			aes = new AES256("abcd0070#gclass$");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
		return aes;
	}

}
