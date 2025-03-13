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
	// >>> 1. (TBL_DRAFT)기안문서 테이블에 insert <<<  //
	int insertToTemporaryStored_TBL_DRAFT(Map<String, Object> paraMap);
	int insertToTemporaryStored_TBL_DRAFT_Submit(Map<String, Object> paraMap);
	// >>> 1. (TBL_DRAFT)기안문서 테이블에 insert_withFile <<<  //
	int insertToTemporaryStored_TBL_DRAFT_withFile(Map<String, Object> paraMap);
	int insertToTemporaryStored_TBL_DRAFT_withFile_Submit(Map<String, Object> paraMap);
	
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
	

	// >>> 4. (결재요청 버튼)알림 테이블에 데이터 넣기 <<< 
	int insert_approvalLine1_To_TBL_ALARM(Map<String, String> approvalLineMap);
	int insert_approvalLine2_To_TBL_ALARM(Map<String, String> approvalLineMap);
	int insert_approvalLine3_To_TBL_ALARM(Map<String, String> approvalLineMap);
	/////////////////////////////////////////////////
	
	// >>> 1. (TBL_DRAFT)기안문서 테이블에 update <<<  //
	int updateToTemporaryStored_TBL_DRAFT(Map<String, Object> paraMap);
	int updateToTemporaryStored_TBL_DRAFT_Submit(Map<String, Object> paraMap);
	// >>> 1. (TBL_DRAFT)기안문서 테이블에 update_withFile <<<  //
	int updateToTemporaryStored_TBL_DRAFT_withFile(Map<String, Object> paraMap);
	int updateToTemporaryStored_TBL_DRAFT_withFile_Submit(Map<String, Object> paraMap);

	// >>> 2. 기안문 양식 테이블에 update <<<
	// [휴가신청서] 테이블에 update
	int updateToTemporaryStored_TBL_DAY_LEAVE(Map<String, Object> paraMap);
	
	// >>> 3. (TBL_APPROVAL)기안결재 테이블에 insert <<<
	// 기존 결재선 및 참조자 삭제 
	int deleteToTemporaryStored_TBL_APPROVAL(String draft_no);
	/////////////////////////////////////////////////	
	
	// ==== 임시저장함 기안문 불러오기 ==== //
	List<ApprovalVO> selectTemporaryList(Map<String, String> paraMap);

	// ==== 임시저장함 총 게시물 건수 구하기 ==== ///
	int getTotalCount(Map<String, String> paraMap);

	// ==== 임시저장함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
	HashMap<String, String> approvalTemporaryDetail(String draft_no);

	// ==== 임시저장한 내용 중 결재선/참조자 목록 불러오기 ==== //
	List<Map<String, String>> getTempApprovalRefer(String draft_no);
	
	/////////////////////////////////////////////////	
	
	// ==== 내가 결재할 대기문서 및 결재/반려 등 처리가 된 문서 불러오기 ==== //
	List<Map<String, String>> approvalPendingList(Map<String, String> paraMap);
	
	// ==== 결재문서함 총 게시물 건수 구하기 ==== //
	int getTotalCount_approvalPending(Map<String, String> paraMap);

	// ==== 결재문서함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
	HashMap<String, String> approvalPendingListDetail(Map<String, String> map);
	
	// ==== 결재 의견 불러오기 ==== //
	List<Map<String, String>> getApprovalFeedback(String draft_no);
	
	// ==== 결재선 결재순위 지정(결재 한 경우 사인 이미지) ==== // 
	List<HashMap<String, String>> orderByApprovalStep_withSign(String draft_no);
	
	/////////////////////////////////////////////////	
	// >>> 1-1. (TBL_APPROVAL) 결재의견 있을 경우 update 및 현재 결재자 상태 update <<<
	int updateToApprovalFirst_TBL_APPROVAL_withFeedback(Map<String, String> map);
	
	// >>> 1-2. (TBL_APPROVAL) 결재의견 없을 경우 update 및 현재 결재자 상태 update <<<
	int updateToApprovalFirst_TBL_APPROVAL(Map<String, String> map);

	// >>> 2-1. (TBL_APPROVAL)다음 결재자가 있는지 확인 <<<
	String selectNextApproverMember(Map<String, String> map);

	// >>> 2-2. (TBL_APPROVAL)다음 결재자가 있을 경우 다음 결재자 상태 update <<<
	int updateToApprovalSecond_TBL_APPROVAL(Map<String, String> map);

	// >>> 3-1. (TBL_DRAFT) 다음 결재자 있으면 결재상태[draft_status]를 "진행중"으로 update <<<
	int updateToApprovalThird_TBL_DRAFT_ongoing(Map<String, String> map);

	// >>> 3-2. (TBL_DRAFT) 다음 결재자 없으면 결재상태[draft_status]를 "승인완료"으로 update <<<
	int updateToApprovalThird_TBL_DRAFT_end(Map<String, String> map);
	/////////////////////////////////////////////////	

	// >>> 1. (TBL_APPROVAL) 현재 결재자 상태 "반려'로 update <<<
	int updateToSendBackFirst_TBL_APPROVAL_withFeedback(Map<String, String> map);

	// >>> 2. (TBL_DRAFT) 결재상태[draft_status]를 "반려완료"으로 update <<<
	int updateToSendBackSecond_TBL_DRAFT_end(Map<String, String> map);
	/////////////////////////////////////////////////	

	// ==== 내가 작성한(결재요청한) 기안문 리스트 불러오기 ==== //
	List<ApprovalVO> approvalRequestList(Map<String, String> paraMap);

	// ==== 결재상신함 총 게시물 건수 구하기 ==== //
	int getTotalCount_approvalRequest(Map<String, String> paraMap);
	
	/////////////////////////////////////////////////	
	
	// ==== 참조문서함 목록 불러오기 ==== //
	List<ApprovalVO> selectreferenceApprovalList(Map<String, String> paraMap);

	// ==== 참조문서함 총 게시물 건수 구하기 ==== //
	int getTotalCount_referenceApproval(Map<String, String> paraMap);





























	


}
