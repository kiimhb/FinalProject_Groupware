package com.spring.med.approval.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.approval.domain.ApprovalVO;
import com.spring.med.approval.model.ApprovalDAO;

@Service
public class ApprovalService_imple implements ApprovalService {

	@Autowired
	private ApprovalDAO mapper_approvalDAO;
	
	
	// ==== 결재선 목록에 선택한 사원 추가하기 ==== //
	@Override
	public ApprovalVO insertToApprovalLine(String member_userid) {
		
		ApprovalVO member = mapper_approvalDAO.insertToApprovalLine(member_userid);
		return member;
	}


	// ==== 결재선 결재순위 지정 ==== // 
	@Override
	public List<HashMap<String, String>> orderByApprovalStep(String[] arr_approvalLineMembers) {
		
		List<HashMap<String, String>> memberList = mapper_approvalDAO.orderByApprovalStep(arr_approvalLineMembers);
		return memberList;
	}

	
	// ==== 기존에 추가했던 결재선 사원을 목록에 불러오기 ==== //
	@Override
	public List<ApprovalVO> insertToApprovalLine_Arr(String[] arr_member_userid) {
		
		List<ApprovalVO> memberList = mapper_approvalDAO.insertToApprovalLine_Arr(arr_member_userid);
		return memberList;
	}

}
