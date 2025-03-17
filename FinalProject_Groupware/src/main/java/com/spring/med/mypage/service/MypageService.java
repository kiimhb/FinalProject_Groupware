package com.spring.med.mypage.service;

import java.util.Map;

import com.spring.med.management.domain.ManagementVO_ga;

public interface MypageService {

	ManagementVO_ga getView_mypageone(Map<String, String> paramMap);
	
	int mypageEdit_update(ManagementVO_ga managementVO_ga, String member_pwd);


}
