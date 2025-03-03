package com.spring.med.approval.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.med.approval.domain.ApprovalVO;
import com.spring.med.approval.model.ApprovalDAO;
import com.spring.med.management.domain.ManagementVO_ga;

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
	
	// ==== 참조자 목록 순서 지정 ==== //
	@Override
	public List<HashMap<String, String>> orderByReferenceMembers(String[] arr_referenceMembers) {
		
		List<HashMap<String, String>> memberList = mapper_approvalDAO.orderByReferenceMembers(arr_referenceMembers);
		return memberList;
	}

	// ==== 기존에 추가했던 결재선 사원을 목록에 불러오기 ==== //
	@Override
	public List<ApprovalVO> insertToApprovalLine_Arr(String[] arr_approvalLineMembers) {
		
		List<ApprovalVO> memberList = mapper_approvalDAO.insertToApprovalLine_Arr(arr_approvalLineMembers);
		return memberList;
	}

	// ==== 기존에 추가했던 참조자 사원을 목록에 불러오기 ==== //
	@Override
	public List<ApprovalVO> insertToReferenceMember_Arr(String[] arr_referenceMembers) {

		List<ApprovalVO> memberList = mapper_approvalDAO.insertToReferenceMember_Arr(arr_referenceMembers);
		return memberList;
	}

	// ==== 문서번호 생성 ==== //
	@Override
	public String createDraftNo() {
		String draft_no = mapper_approvalDAO.createDraftNo();
		return draft_no;
	}

	// ==== 잔여 연차 조회 ==== //
	@Override
	public String leftoverYeoncha(String member_userid) {
		String member_yeoncha = mapper_approvalDAO.leftoverYeoncha(member_userid);
		return member_yeoncha;
	}

	// ==== 첨부파일이 없는 경우 기안문 임시저장하기 ==== // 
	@Override
	@Transactional(value="transactionManager_final_orauser4" , propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class}) // 오류가 발생하면 무조건 rollback
	public int insertToTemporaryStored(Map<String, Object> paraMap) {
		
		int n1=0, n2=0, n3=0, n4=0, result=0;
		
		// insert / update 구분용
		String draftMode = (String) paraMap.get("draftMode");
		
		// >>> 1. (TBL_DRAFT)기안문서 테이블에 insert 및 update <<<
		if("insert".equals(draftMode)) {
			n1 = mapper_approvalDAO.insertToTemporaryStored_TBL_DRAFT(paraMap);
		}
		else if ("update".equals(draftMode)) {
			n1 = mapper_approvalDAO.updateToTemporaryStored_TBL_DRAFT(paraMap);
			System.out.println("~~~~확인용 n1 : " + n1);
		}
		
		//////////////////////////////////////////////////////////
		// >>> 2. 기안문 양식 테이블에 insert <<<
		String draft_form_type = (String) paraMap.get("draft_form_type");
		
		if(n1 == 1) {
			
			if("휴가신청서".equals(draft_form_type)) {
				
				if("insert".equals(draftMode)) {
					// [휴가신청서] 테이블에 insert
					n2 = mapper_approvalDAO.insertToTemporaryStored_TBL_DAY_LEAVE(paraMap);
				}
				else if ("update".equals(draftMode)) {
					// [휴가신청서] 테이블에 update
					n2 = mapper_approvalDAO.updateToTemporaryStored_TBL_DAY_LEAVE(paraMap);
					System.out.println("~~~~확인용 n2 : " + n2);
				}
			}
		}
		//////////////////////////////////////////////////////////
		// >>> 3. (TBL_APPROVAL)기안결재 테이블에 insert <<<
		//Object approvalLineMember = paraMap.get("approvalLineMember");
		//Object referMember = paraMap.get("referMember");
		
		boolean exist_line = false;
		boolean exist_refer = false;

		if(n2 == 1) {
			
			if("update".equals(draftMode)) {	
				// 기존 결재선 및 참조자 삭제 
				int del1 = mapper_approvalDAO.deleteToTemporaryStored_TBL_APPROVAL((String) paraMap.get("draft_no"));
				System.out.println("del1 확인 ~~ :" + del1);	
			}

			if(paraMap.get("approvalLineMember") != null && !((Map<?, ?>) paraMap.get("approvalLineMember")).isEmpty()) {
				
				//Map<String, String> approvalLineMap = (Map<String, String>) approvalLineMember;
				
				@SuppressWarnings("unchecked")
				Map<String, String> approvalLineMap = (Map<String, String>) paraMap.get("approvalLineMember");
				
				approvalLineMap.put("draft_no", (String) paraMap.get("draft_no"));
				
				// 결재선 목록에 추가한 유저 insert			
				if(approvalLineMap.get("step1") != null) {n3 = mapper_approvalDAO.insertToTemporaryStored_approvalLine1_TBL_APPROVAL(approvalLineMap);}
				if(approvalLineMap.get("step2") != null) {n3 = mapper_approvalDAO.insertToTemporaryStored_approvalLine2_TBL_APPROVAL(approvalLineMap);}
				if(approvalLineMap.get("step3") != null) {n3 = mapper_approvalDAO.insertToTemporaryStored_approvalLine3_TBL_APPROVAL(approvalLineMap);}
				
				exist_line = true;
				System.out.println("~~~~확인용 n3 : " + n3);	
			}
			
			if(paraMap.get("referMember") != null && !((Map<?, ?>) paraMap.get("referMember")).isEmpty()) {
				
				//Map<String, String> referMemberMap = (Map<String, String>) referMember;
				
				@SuppressWarnings("unchecked")
				Map<String, String> referMemberMap = (Map<String, String>) paraMap.get("referMember");
				referMemberMap.put("draft_no", (String) paraMap.get("draft_no"));
				
				// 참조자 목록에 추가한 유저 insert
				if(referMemberMap.get("step1") != null) {n4 = mapper_approvalDAO.insertToTemporaryStored_referMember1_TBL_APPROVAL(referMemberMap);}
				if(referMemberMap.get("step2") != null) {n4 = mapper_approvalDAO.insertToTemporaryStored_referMember2_TBL_APPROVAL(referMemberMap);}
				if(referMemberMap.get("step3") != null) {n4 = mapper_approvalDAO.insertToTemporaryStored_referMember3_TBL_APPROVAL(referMemberMap);}
				
				exist_refer = true;
				System.out.println("~~~~확인용 n4 : " + n4);
			}	
		}
		
		if(!exist_line  && !exist_refer) {
			result = n1*n2;
		}
		else if (exist_line && !exist_refer) {
			result = n1*n2*n3;
		}
		else if (!exist_line && exist_refer) {
			result = n1*n2*n4;
		}
		else if (exist_line && exist_refer) {
			result = n1*n2*n3*n4;
		}
		System.out.println("~~~~확인용 result : " + result);
		return result;
	}
	
	// ==== 첨부파일이 있는 경우 기안문 임시저장하기 ==== //
	@Override
	@Transactional(value="transactionManager_final_orauser4" , propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class}) // 오류가 발생하면 무조건 rollback
	public int insertToTemporaryStored_withFile(Map<String, Object> paraMap) {
		
		int n1=0, n2=0, n3=0, n4=0, result=0;
		
		// insert / update 구분용
		String draftMode = (String) paraMap.get("draftMode");

		// >>> 1. (TBL_DRAFT)기안문서 테이블에 insert_withFile 및 update_withFile <<<
		if("insert".equals(draftMode)) {
			n1 = mapper_approvalDAO.insertToTemporaryStored_TBL_DRAFT_withFile(paraMap);
		}
		else if ("update".equals(draftMode)) {
			n1 = mapper_approvalDAO.updateToTemporaryStored_TBL_DRAFT_withFile(paraMap);
			System.out.println("~~~~확인용 n1 : " + n1);
		}
		
		
		//////////////////////////////////////////////////////////
		// >>> 2. 기안문 양식 테이블에 insert <<<
		String draft_form_type = (String) paraMap.get("draft_form_type");
		
		if(n1 == 1) {
			
			if("휴가신청서".equals(draft_form_type)) {
				
				if ("insert".equals(draftMode)) {
					// [휴가신청서] 테이블에 insert
					n2 = mapper_approvalDAO.insertToTemporaryStored_TBL_DAY_LEAVE(paraMap);
				}
				else if ("update".equals(draftMode)) {
					// [휴가신청서] 테이블에 update
					n2 = mapper_approvalDAO.updateToTemporaryStored_TBL_DAY_LEAVE(paraMap);
					System.out.println("~~~~확인용 n2 : " + n2);
				}
			}
		}
		//////////////////////////////////////////////////////////
		// >>> 3. (TBL_APPROVAL)기안결재 테이블에 insert <<<
		//Object approvalLineMember = paraMap.get("approvalLineMember");
		//Object referMember = paraMap.get("referMember");
		
		boolean exist_line = false;
		boolean exist_refer = false;
		
		if(n2 == 1) {
			
			if("update".equals(draftMode)) {	
				// 기존 결재선 및 참조자 삭제 
				int del1 = mapper_approvalDAO.deleteToTemporaryStored_TBL_APPROVAL((String) paraMap.get("draft_no"));
				System.out.println("del1 확인 ~~ :" + del1);	
			}

			if(paraMap.get("approvalLineMember") != null && !((Map<?, ?>) paraMap.get("approvalLineMember")).isEmpty()) {
				
				//Map<String, String> approvalLineMap = (Map<String, String>) approvalLineMember;
				
				@SuppressWarnings("unchecked")
				Map<String, String> approvalLineMap = (Map<String, String>) paraMap.get("approvalLineMember");
				
				approvalLineMap.put("draft_no", (String) paraMap.get("draft_no"));
				
				// 결재선 목록에 추가한 유저 insert			
				if(approvalLineMap.get("step1") != null) {n3 = mapper_approvalDAO.insertToTemporaryStored_approvalLine1_TBL_APPROVAL(approvalLineMap);}
				if(approvalLineMap.get("step2") != null) {n3 = mapper_approvalDAO.insertToTemporaryStored_approvalLine2_TBL_APPROVAL(approvalLineMap);}
				if(approvalLineMap.get("step3") != null) {n3 = mapper_approvalDAO.insertToTemporaryStored_approvalLine3_TBL_APPROVAL(approvalLineMap);}
				
				System.out.println("~~~~확인용 n3 : " + n3);	
				exist_line = true;
			}
			
			if(paraMap.get("referMember") != null && !((Map<?, ?>) paraMap.get("referMember")).isEmpty()) {
				
				//Map<String, String> referMemberMap = (Map<String, String>) referMember;
				
				@SuppressWarnings("unchecked")
				Map<String, String> referMemberMap = (Map<String, String>) paraMap.get("referMember");
				referMemberMap.put("draft_no", (String) paraMap.get("draft_no"));
				
				// 참조자 목록에 추가한 유저 insert
				if(referMemberMap.get("step1") != null) {n4 = mapper_approvalDAO.insertToTemporaryStored_referMember1_TBL_APPROVAL(referMemberMap);}
				if(referMemberMap.get("step2") != null) {n4 = mapper_approvalDAO.insertToTemporaryStored_referMember2_TBL_APPROVAL(referMemberMap);}
				if(referMemberMap.get("step3") != null) {n4 = mapper_approvalDAO.insertToTemporaryStored_referMember3_TBL_APPROVAL(referMemberMap);}
				System.out.println("~~~~확인용 n4 : " + n4);
				exist_refer = true;
			}	
		}	
		
		if(!exist_line  && !exist_refer) {
			result = n1*n2;
		}
		else if (exist_line && !exist_refer) {
			result = n1*n2*n3;
		}
		else if (!exist_line && exist_refer) {
			result = n1*n2*n4;
		}
		else if (exist_line && exist_refer) {
			result = n1*n2*n3*n4;
		}
		System.out.println("~~~~확인용 result : " + result);
		return result;

	}

	// ==== 임시저장함 기안문 불러오기 ==== //
	@Override
	public List<ApprovalVO> selectTemporaryList(Map<String, String> paraMap) {
		
		List<ApprovalVO> temporaryList = mapper_approvalDAO.selectTemporaryList(paraMap);
		return temporaryList;
	}

	// ==== 총 게시물 건수 구하기 ==== ///
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		
		int totalCount = mapper_approvalDAO.getTotalCount(paraMap);
		return totalCount;
	}

	// ==== 임시저장함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
	@Override
	public HashMap<String, String> approvalTemporaryDetail(String draft_no) {
		
		HashMap<String, String> approvalvo = mapper_approvalDAO.approvalTemporaryDetail(draft_no);
		System.out.println("확인2 : " + approvalvo);
		return approvalvo;
	}

	// ==== 임시저장한 내용 중 결재선/참조자 목록 불러오기 ==== //
	@Override
	public List<Map<String, String>> getTempApprovalRefer(String draft_no) {
		
		List<Map<String, String>> mapList = mapper_approvalDAO.getTempApprovalRefer(draft_no);
		return mapList;
	}






}
