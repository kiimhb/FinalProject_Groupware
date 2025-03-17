package com.spring.med.mypage.model;

import java.util.Map;

import com.spring.med.management.domain.ManagementVO_ga;

public interface MypageDAO {
	
	ManagementVO_ga getView_mypageone(Map<String, String> paramMap);
	
	int mypageEdit_update(ManagementVO_ga managementVO_ga);

	

}
