package com.spring.med.mypage.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.common.Sha256;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.mypage.model.MypageDAO;

@Service
public class MypageService_imple implements MypageService {
	
	@Autowired
	private MypageDAO dao;

	@Override
	public int mypageEdit_update(ManagementVO_ga managementVO_ga, String member_pwd) {
		
		member_pwd = Sha256.encrypt(member_pwd);
		managementVO_ga.setMember_pwd(member_pwd);
		
		//System.out.println(member_pwd);
		
		int n = dao.mypageEdit_update(managementVO_ga);
		return n;
	}


}
