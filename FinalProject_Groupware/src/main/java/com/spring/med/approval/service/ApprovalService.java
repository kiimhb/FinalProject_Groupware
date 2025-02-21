package com.spring.med.approval.service;

import java.util.HashMap;
import java.util.List;

import com.spring.med.approval.domain.ApprovalVO;

public interface ApprovalService {

	// ==== 결재선 목록에 선택한 사원 추가하기 ==== //
	ApprovalVO insertToApprovalLine(String member_userid);

	// ==== 결재선 결재순위 지정 ==== // 
	List<HashMap<String, String>> orderByApprovalStep(String[] arr_approvalLineMembers);

	// ==== 기존에 추가했던 결재선 사원을 목록에 불러오기 ==== //
	List<ApprovalVO> insertToApprovalLine_Arr(String[] arr_member_userid);

}
