package com.spring.med.approval.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.spring.med.approval.domain.ApprovalVO;
import com.spring.med.management.domain.ManagementVO_ga;

@Mapper
public interface ApprovalDAO {

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

	/////////////////////////////////////////////////
	// ==== 첨부파일이 없는 경우 기안문 임시저장하기 ==== //
	// >>> 1. (TBL_DRAFT)기안문서 테이블에 insert <<<  //
	int insertToTemporaryStored_TBL_DRAFT(Map<String, Object> paraMap);
	// >>> 1. (TBL_DRAFT)기안문서 테이블에 insert_withFile <<<  //
	int insertToTemporaryStored_TBL_DRAFT_withFile(Map<String, Object> paraMap);
	
	// >>> 2. 기안문 양식 테이블에 insert <<<
	// [휴가신청서] 테이블에 insert
	int insertToTemporaryStored_TBL_DAY_LEAVE(Map<String, Object> paraMap);

	// >>> 3. (TBL_APPROVAL)기안결재 테이블에 insert <<<
	// 결재선 목록에 추가한 유저 insert
	int insertToTemporaryStored_approvalLine1_TBL_APPROVAL(Map<String, String> approvalLineMap);
	int insertToTemporaryStored_approvalLine2_TBL_APPROVAL(Map<String, String> approvalLineMap);
	int insertToTemporaryStored_approvalLine3_TBL_APPROVAL(Map<String, String> approvalLineMap);

	// 참조자 목록에 추가한 유저 insert
	int insertToTemporaryStored_referMember1_TBL_APPROVAL(Map<String, String> referMemberMap);
	int insertToTemporaryStored_referMember2_TBL_APPROVAL(Map<String, String> referMemberMap);
	int insertToTemporaryStored_referMember3_TBL_APPROVAL(Map<String, String> referMemberMap);
	/////////////////////////////////////////////////

	// ==== 임시저장함 기안문 불러오기 ==== //
	List<ApprovalVO> selectTemporaryList(Map<String, String> paraMap);

	// ==== 총 게시물 건수 구하기 ==== ///
	int getTotalCount(Map<String, String> paraMap);

	// ==== 임시저장함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
	ApprovalVO approvalTemporaryDetail(String draft_no);

	


}
