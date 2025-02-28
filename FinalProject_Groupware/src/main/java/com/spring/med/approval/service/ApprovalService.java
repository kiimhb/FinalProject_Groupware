package com.spring.med.approval.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.spring.med.approval.domain.ApprovalVO;

public interface ApprovalService {

	// ==== 결재선 목록에 선택한 사원 추가하기 ==== //
	ApprovalVO insertToApprovalLine(String member_userid);

	// ==== 결재선 결재순위 지정 ==== // 
	List<HashMap<String, String>> orderByApprovalStep(String[] arr_approvalLineMembers);
	
	// ==== 참조자 목록 순서 지정 ==== //
	List<HashMap<String, String>> orderByReferenceMembers(String[] arr_referenceMembers);

	// ==== 기존에 추가했던 결재선 사원을 목록에 불러오기 ==== //
	List<ApprovalVO> insertToApprovalLine_Arr(String[] arr_approvalLineMembers);

	// ==== 기존에 추가했던 참조자 사원을 목록에 불러오기 ==== //
	List<ApprovalVO> insertToReferenceMember_Arr(String[] arr_referenceMembers);

	// ==== 문서번호 생성 ==== //
	String createDraftNo();

	// ==== 잔여 연차 조회 ==== //
	String leftoverYeoncha(String member_userid);

	// ==== 첨부파일이 없는 경우 기안문 임시저장하기 ==== // 
	int insertToTemporaryStored(Map<String, Object> paraMap);

	// ==== 첨부파일이 있는 경우 기안문 임시저장하기 ==== //
	int insertToTemporaryStored_withFile(Map<String, Object> paraMap);





}
