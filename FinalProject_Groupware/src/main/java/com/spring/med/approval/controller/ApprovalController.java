package com.spring.med.approval.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.med.approval.domain.ApprovalVO;
import com.spring.med.approval.service.ApprovalService;
import com.spring.med.common.FileManager;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// **** 기안서 및 결재 컨트롤러 **** //

@Controller
@RequestMapping(value="/approval/*")
public class ApprovalController {
	
	@Autowired
	private ApprovalService approvalService;
	
	@Autowired
	private FileManager fileManager; 
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 기안문작성 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ==== 기안문작성 폼페이지 요청 ==== //
	@GetMapping("write")
	public ModelAndView writeDraftForm(ModelAndView mav) {
		mav.setViewName("content/approval/write");
		
		return mav;
	}
	
	// ==== 휴가신청서 양식 예시 ==== //
	@GetMapping("dayLeaveForm")
	public ModelAndView dayLeaveForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/dayLeaveForm");
		return mav;
	}
	
	// ==== 지출결의서 양식 예시 ==== //
	@GetMapping("expenseReportForm")
	public ModelAndView expenseReportForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/expenseReportForm");
		return mav;
	}
	
	// ==== 근무 교대 신청서 양식 예시 ==== //
	@GetMapping("workChangeForm")
	public ModelAndView workChangeForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/workChangeForm");
		return mav;
	}
	
	// ==== 출장신청서 양식 예시 ==== //
	@GetMapping("businessTripForm")
	public ModelAndView businessTripForm(ModelAndView mav) {
		mav.setViewName("/content/approval/draftExamples/businessTripForm");
		return mav;
	}
	
	
	// ==== 선택한 기안 양식 가져오기 ==== //
	@GetMapping("writeDraft")
	public ModelAndView writeDraft(ModelAndView mav,
								   HttpServletRequest request,
								   @RequestParam String typeSelect
								   ) {
		
		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		Map<String, Object> paraMap = new HashMap<>();
		
		if(loginuser != null) {
			
			// 기안자 정보 불러오기
			ApprovalVO memverInfo = approvalService.insertToApprovalLine(loginuser.getMember_userid());
			
			// 문서번호 생성
			String draft_no = approvalService.createDraftNo();
			
			// 기안일자 
			LocalDate now = LocalDate.now();	// 현재날짜
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
			String now_date = now.format(formatter);

			paraMap.put("memverInfo", memverInfo);
			paraMap.put("draft_no", draft_no);		
			paraMap.put("now_date", now_date);
		}
		
		
		if(typeSelect.equals("휴가신청서")) {
			
			// 잔여 연차 조회
			String member_yeoncha = approvalService.leftoverYeoncha(loginuser.getMember_userid());
			paraMap.put("member_yeoncha", member_yeoncha);	
			
			// 문서 양식
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("지출결의서")) {
			
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("근무 변경 신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");			
		}
		else if(typeSelect.equals("출장신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}

		mav.addObject("paraMap", paraMap);
		
		return mav;
	}
	
	
	// ==== 결재선 목록에 선택한 사원 추가하기 ==== //
	@PostMapping("insertToApprovalLine")
	@ResponseBody
	public ApprovalVO insertToApprovalLine(@RequestParam String member_userid) {

		ApprovalVO member = approvalService.insertToApprovalLine(member_userid);
		
		return member;
	}
	
	
	// ==== 참조자 목록에 선택한 사원 추가하기 ==== //
	@PostMapping("insertToReference")
	@ResponseBody
	public ApprovalVO insertToReference(@RequestParam String member_userid) {

		ApprovalVO member = approvalService.insertToApprovalLine(member_userid);
		
		return member;
	}
	
	
	// ==== 결재선 결재순위 지정 ==== // 
	@PostMapping("orderByApprovalStep")
	@ResponseBody
	public List<HashMap<String, String>> orderByApprovalStep(@RequestParam String[] arr_approvalLineMembers) {
		
		List<HashMap<String, String>> memberList = approvalService.orderByApprovalStep(arr_approvalLineMembers);

		return memberList;
	}
	
	
	// ==== 참조자 목록 순서 지정 ==== // 
	@PostMapping("orderByReferenceMember")
	@ResponseBody
	public List<HashMap<String, String>> orderByReferenceMember(@RequestParam String[] arr_referenceMembers) {
		
		List<HashMap<String, String>> memberList = approvalService.orderByReferenceMembers(arr_referenceMembers);

		return memberList;
	}
	
	
	// ==== 기존에 추가했던 결재선 사원을 목록에 불러오기 ==== //
	@PostMapping("insertToApprovalLine_Arr")
	@ResponseBody
	public List<ApprovalVO> insertToApprovalLine_Arr(@RequestParam String[] arr_approvalLineMembers) {

		List<ApprovalVO> memberList = approvalService.insertToApprovalLine_Arr(arr_approvalLineMembers);
		
		return memberList;
	}
	
	
	// ==== 기존에 추가했던 참조자 사원을 목록에 불러오기 ==== //
	@PostMapping("insertToReferenceMember_Arr")
	@ResponseBody
	public List<ApprovalVO> insertToReferenceMember_Arr(@RequestParam String[] arr_referenceMembers) {

		List<ApprovalVO> memberList = approvalService.insertToReferenceMember_Arr(arr_referenceMembers);
		
		return memberList;
	}

	
	// ==== 기안문 임시저장하기 ==== // 
	@PostMapping("insertToTemporaryStored")
	@ResponseBody
	public int insertToTemporaryStored(MultipartHttpServletRequest mtp_request) {

		Map<String, Object> paraMap = new HashMap<>();
		
		paraMap.put("draftMode", mtp_request.getParameter("draftMode"));
		paraMap.put("fk_member_userid", mtp_request.getParameter("fk_member_userid"));
		paraMap.put("draft_no", mtp_request.getParameter("draft_no"));
		paraMap.put("draft_form_type", mtp_request.getParameter("draft_form_type"));
		paraMap.put("draft_subject", mtp_request.getParameter("draft_subject"));
		paraMap.put("draft_write_date", mtp_request.getParameter("draft_write_date"));
		paraMap.put("draft_urgent", mtp_request.getParameter("draft_urgent"));
		paraMap.put("day_leave_start", mtp_request.getParameter("day_leave_start"));
		paraMap.put("day_leave_end", mtp_request.getParameter("day_leave_end"));
		paraMap.put("day_leave_cnt", mtp_request.getParameter("day_leave_cnt"));
		paraMap.put("day_leave_reason", mtp_request.getParameter("day_leave_reason"));
		
		try {
			String mtp_approvalLineMember = mtp_request.getParameter("approvalLineMember");
			String mtp_referMember = mtp_request.getParameter("referMember");
			
			// >>> JSON 문자열을 Map 으로 변환 <<<
			ObjectMapper objectMapper = new ObjectMapper();
			
			if(mtp_approvalLineMember != null && mtp_referMember == null) {
				Map<String, String> approvalLineMember = objectMapper.readValue(mtp_approvalLineMember, new TypeReference<Map<String, String>>(){});
				paraMap.put("approvalLineMember", approvalLineMember);
			}
			else if(mtp_approvalLineMember == null && mtp_referMember != null) {
				Map<String, String> referMember = objectMapper.readValue(mtp_referMember, new TypeReference<Map<String, String>>(){});
				paraMap.put("referMember", referMember);
			}
			else if(mtp_approvalLineMember != null && mtp_referMember != null) {
				Map<String, String> approvalLineMember = objectMapper.readValue(mtp_approvalLineMember, new TypeReference<Map<String, String>>(){});
				Map<String, String> referMember = objectMapper.readValue(mtp_referMember, new TypeReference<Map<String, String>>(){});
				paraMap.put("approvalLineMember", approvalLineMember);
				paraMap.put("referMember", referMember);
			}
			else {
				paraMap.put("approvalLineMember", mtp_request.getParameter("approvalLineMember"));
				paraMap.put("referMember", mtp_request.getParameter("referMember"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// >>>> 파일이 있는 경우 <<<<
		MultipartFile attachFile = mtp_request.getFile("file");	// 첨부한 파일 가져오기
		
		if(attachFile != null) {

			// WAS(톰캣)의 절대경로 알아오기
			HttpSession session = mtp_request.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root + "resources" + File.separator + "draft";  // 파일 저장 위치
			
			// 만약 폴더가 없으면 생성
			File dir = new File(path);
			if(!dir.exists()) {
				dir.mkdir();
			}

			String newFileName = "";	// WAS(톰캣)의 디스크에 저장될 파일명
			byte[] bytes = null;		// 파일 내용 담을 변수
			long fileSize = 0;			// 첨부파일의 크기
			
			try {
					bytes = attachFile.getBytes(); // 첨부파일의 내용물 읽어오기
					
					String originalFilename = attachFile.getOriginalFilename();	// 첨부파일의 실제 파일명
					
					fileSize = attachFile.getSize(); // 첨부된 파일의 파일사이즈
					
					// >>> 첨부된 파일을 저장소에 업로드
					newFileName = fileManager.doFileUpload(bytes, originalFilename, path);	
					
					paraMap.put("draft_file_name", newFileName);				// 저장된 파일명
					paraMap.put("draft_file_origin_name", originalFilename);	// 원본파일명
					paraMap.put("draft_file_size", String.valueOf(fileSize));	// 파일사이즈
	
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
		
		int result = 0;

		// ==== 첨부파일이 없는 경우 기안문 임시저장하기 ==== //
		if(attachFile == null) {
			result = approvalService.insertToTemporaryStored(paraMap);
		}
		// ==== 첨부파일이 있는 경우 기안문 임시저장하기 ==== //
		else if(attachFile != null) {
			result = approvalService.insertToTemporaryStored_withFile(paraMap);
		}
	
		return result;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 결재상신함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ==== 내가 작성한(결재요청한) 기안문 리스트 불러오기 ==== //
	@GetMapping("approvalRequestList")
	public ModelAndView approvalRequestList(ModelAndView mav
							              , HttpServletRequest request
							              , @RequestParam(defaultValue = "") String searchType
							              , @RequestParam(defaultValue = "") String searchWord
							              , @RequestParam(defaultValue = "10") int sizePerPage
							              , @RequestParam(defaultValue = "1") int currentShowPageNo) {
		
		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("member_userid", loginuser.getMember_userid());
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		// >>> 총 게시물 건수 구하기 <<< ///
		int totalCount = 0;
		int totalPage = 0;
		
		totalCount = approvalService.getTotalCount_approvalRequest(paraMap);
		
		// 페이지 당 보여줄 기안문 개수에 따라 총 페이지 수 구하기
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
			
		try {
			// url 에 잘못된 페이지번호가 입력 될 경우 첫 페이지로 처리
			if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
				currentShowPageNo = 1;
			}
		} catch (NumberFormatException e) {
			currentShowPageNo = 1;
		}
		
		
		// >>> 페이지당 보여줄 목록 가져오기 <<< //
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 범위시작
		int endRno = startRno + sizePerPage -1;	// 범위끝
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

		// >>> 결재상신함 기안문 불러오기 <<< //
		List<ApprovalVO> requestList = approvalService.approvalRequestList(paraMap);
		mav.addObject("requestList", requestList);
		
		// 검색어 유지시키기 위해 데이터 전달
		if("draft_form_type".equals(searchType) || "draft_subject".equals(searchType)) {	
			mav.addObject("paraMap", paraMap);
		}
		
		mav.addObject("sizePerPage", sizePerPage);
		
		// >>> 페이지바 생성 <<< //
		int blockSize = 10;	// 한 줄에 보이는 페이지 번호 개수
		int loop = 1;		// 페이지바의 다음 줄을 보여주는데 사용
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
	    String url = "approvalRequestList";
	    
	    // === [맨처음][이전] 만들기 === //
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>&lt;&lt;</a></li>";

	    if (pageNo != 1) {  // 내가 보고자 하는 넘버가 1페이지가 아닐 때
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>&lt;</a></li>";
	    }

	    while (!(loop > blockSize || pageNo > totalPage)) {  // 10 보다 크거나 totalPage 보다 크면 안 된다
	        if (pageNo == currentShowPageNo) {  // 내가 현재 보고자 하는 페이지
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>" + pageNo + "</li>";
	        } else {
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>" + pageNo + "</a></li>";
	        }
	        
	        loop++;
	        pageNo++;
	    }

	    // === [다음][마지막] 만들기 === //
	    if (pageNo <= totalPage) {  // 맨 마지막 페이지라면 [다음]이 없음
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>&gt;</a></li>";
	    }

	    pageBar += "<li style='display:inline-block; width:70px;  font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>&gt;&gt;</a></li>";

	    pageBar += "</ul>";
			    
	    
	    mav.addObject("pageBar", pageBar); // modelandview(뷰단페이지에 페이지바를 나타냄)
	    
		mav.setViewName("content/approval/approvalRequestList");

		return mav;
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 임시저장함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ==== 임시저장함 폼페이지 요청 ==== //
	@GetMapping("approvalTemporaryList")
	public ModelAndView approvalTemporaryList(ModelAndView mav
			                                , HttpServletRequest request
			                                , @RequestParam(defaultValue = "") String searchType
			                                , @RequestParam(defaultValue = "") String searchWord
			                                , @RequestParam(defaultValue = "10") int sizePerPage
			                                , @RequestParam(defaultValue = "1") int currentShowPageNo) {

		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("member_userid", loginuser.getMember_userid());
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		// >>> 총 게시물 건수 구하기 <<< ///
		int totalCount = 0;
		int totalPage = 0;
		
		totalCount = approvalService.getTotalCount(paraMap);
		
		// 페이지 당 보여줄 기안문 개수에 따라 총 페이지 수 구하기
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
			
		try {
			// url 에 잘못된 페이지번호가 입력 될 경우 첫 페이지로 처리
			if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
				currentShowPageNo = 1;
			}
		} catch (NumberFormatException e) {
			currentShowPageNo = 1;
		}
		
		
		// >>> 페이지당 보여줄 목록 가져오기 <<< //
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 범위시작
		int endRno = startRno + sizePerPage -1;	// 범위끝
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// >>> 임시저장함 기안문 불러오기 <<< //
		List<ApprovalVO> temporaryList = approvalService.selectTemporaryList(paraMap);
		mav.addObject("temporaryList", temporaryList);
		
		// 검색어 유지시키기 위해 데이터 전달
		if("draft_form_type".equals(searchType) || "draft_subject".equals(searchType)) {	
			mav.addObject("paraMap", paraMap);
		}
		
		mav.addObject("sizePerPage", sizePerPage);
		
		// >>> 페이지바 생성 <<< //
		int blockSize = 10;	// 한 줄에 보이는 페이지 번호 개수
		int loop = 1;		// 페이지바의 다음 줄을 보여주는데 사용
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
	    String url = "approvalTemporaryList";
	    
	    // === [맨처음][이전] 만들기 === //
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>&lt;&lt;</a></li>";

	    if (pageNo != 1) {  // 내가 보고자 하는 넘버가 1페이지가 아닐 때
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>&lt;</a></li>";
	    }

	    while (!(loop > blockSize || pageNo > totalPage)) {  // 10 보다 크거나 totalPage 보다 크면 안 된다
	        if (pageNo == currentShowPageNo) {  // 내가 현재 보고자 하는 페이지
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>" + pageNo + "</span></li>";
	        } else {
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>" + pageNo + "</a></li>";
	        }
	        
	        loop++;
	        pageNo++;
	    }

	    // === [다음][마지막] 만들기 === //
	    if (pageNo <= totalPage) {  // 맨 마지막 페이지라면 [다음]이 없음
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>&gt;</a></li>";
	    }

	    pageBar += "<li style='display:inline-block; width:70px;  font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>&gt;&gt;</a></li>";

	    pageBar += "</ul>";

       
	    mav.addObject("pageBar", pageBar); // modelandview(뷰단페이지에 페이지바를 나타냄)

		mav.setViewName("content/approval/approvalTemporaryList");

		return mav;
	}
	
		
	// ==== 임시저장함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
	@PostMapping("approvalTemporaryDetail")
	public ModelAndView approvalTemporaryDetail(ModelAndView mav, @RequestParam String draft_no) {
	
		HashMap<String, String> approvalvo = approvalService.approvalTemporaryDetail(draft_no);
		mav.addObject("approvalvo", approvalvo);
		mav.setViewName("/content/approval/write");
		
		return mav;
	}
	
	
	// ==== 임시저장한 기존의 기안 양식 가져오기 ==== //
	@GetMapping("writeDraftTemp")
	public ModelAndView writeDraftTemp(ModelAndView mav,
								   	   HttpServletRequest request,
								   	   @RequestParam String typeSelect
								   		) {
		
		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		Map<String, Object> paraMap = new HashMap<>();
		
		if(loginuser != null) {
			
			// 기안자 정보 불러오기
			//ApprovalVO memverInfo = approvalService.insertToApprovalLine(loginuser.getMember_userid());
			
			// 문서번호 생성
			//String draft_no = approvalService.createDraftNo();
			
			// 기안일자 
			LocalDate now = LocalDate.now();	// 현재날짜
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
			String now_date = now.format(formatter);

			//paraMap.put("memverInfo", memverInfo);
			//paraMap.put("draft_no", draft_no);		
			paraMap.put("now_date", now_date);
		}
		
		
		if(typeSelect.equals("휴가신청서")) {
			
			// 잔여 연차 조회
			String member_yeoncha = approvalService.leftoverYeoncha(loginuser.getMember_userid());
			paraMap.put("member_yeoncha", member_yeoncha);	
			
			// 문서 양식
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("지출결의서")) {
			
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}
		else if(typeSelect.equals("근무 변경 신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");			
		}
		else if(typeSelect.equals("출장신청서")) {
			mav.setViewName("/content/approval/draftExamples/dayLeave");
		}

		mav.addObject("paraMap", paraMap);
		
		return mav;
	}
	
	
	// ==== 임시저장한 내용 중 결재선/참조자 목록 불러오기 ==== //
	@GetMapping("getTempApprovalRefer")
	@ResponseBody
	public List<Map<String, String>> getTempApprovalRefer(@RequestParam String draft_no) {

		List<Map<String, String>> mapList = approvalService.getTempApprovalRefer(draft_no);
		return mapList;
	}

	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 결재문서함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ==== 내가 결재할 대기문서 및 결재/반려 등 처리가 된 문서 불러오기 === //
	@GetMapping("approvalPendingList")
	public ModelAndView approvalPendingList(ModelAndView mav
							              , HttpServletRequest request
							              , @RequestParam(defaultValue = "") String searchType
							              , @RequestParam(defaultValue = "") String searchWord
							              , @RequestParam(defaultValue = "10") int sizePerPage
							              , @RequestParam(defaultValue = "1") int currentShowPageNo) {
		
		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("member_userid", loginuser.getMember_userid());
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		// >>> 총 게시물 건수 구하기 <<< ///
		int totalCount = 0;
		int totalPage = 0;
		
		totalCount = approvalService.getTotalCount_approvalPending(paraMap);
		
		// 페이지 당 보여줄 기안문 개수에 따라 총 페이지 수 구하기
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
			
		try {
			// url 에 잘못된 페이지번호가 입력 될 경우 첫 페이지로 처리
			if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
				currentShowPageNo = 1;
			}
		} catch (NumberFormatException e) {
			currentShowPageNo = 1;
		}
		
		// >>> 페이지당 보여줄 목록 가져오기 <<< //
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 범위시작
		int endRno = startRno + sizePerPage -1;	// 범위끝
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// >>> 결재문서함 기안문 불러오기 <<< //
		List<Map<String, String>> pendingList = approvalService.approvalPendingList(paraMap);
		mav.addObject("pendingList", pendingList);
		
		// 검색어 유지시키기 위해 데이터 전달
		if("draft_form_type".equals(searchType) || "draft_subject".equals(searchType) || "member_name".equals(searchType) || "parent_dept_name".equals(searchType)) {	
			mav.addObject("paraMap", paraMap);
		}
		
		mav.addObject("sizePerPage", sizePerPage);
		
		// >>> 페이지바 생성 <<< //
		int blockSize = 10;	// 한 줄에 보이는 페이지 번호 개수
		int loop = 1;		// 페이지바의 다음 줄을 보여주는데 사용
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
	    String url = "approvalPendingList";
		
	 // === [맨처음][이전] 만들기 === //
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>&lt;&lt;</a></li>";

	    if (pageNo != 1) {  // 내가 보고자 하는 넘버가 1페이지가 아닐 때
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>&lt;</a></li>";
	    }

	    while (!(loop > blockSize || pageNo > totalPage)) {  // 10 보다 크거나 totalPage 보다 크면 안 된다
	        if (pageNo == currentShowPageNo) {  // 내가 현재 보고자 하는 페이지
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>" + pageNo + "</li>";
	        } else {
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>" + pageNo + "</a></li>";
	        }
	        
	        loop++;
	        pageNo++;
	    }

	    // === [다음][마지막] 만들기 === //
	    if (pageNo <= totalPage) {  // 맨 마지막 페이지라면 [다음]이 없음
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>&gt;</a></li>";
	    }

	    pageBar += "<li style='display:inline-block; width:70px;  font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>&gt;&gt;</a></li>";

	    pageBar += "</ul>";

       
	    mav.addObject("pageBar", pageBar); // modelandview(뷰단페이지에 페이지바를 나타냄)
		
		mav.setViewName("content/approval/approvalPendingList");
		
		return mav;
	}
	
	
	// ==== 결재문서함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
	@PostMapping("approvalPendingListDetail")
	public ModelAndView approvalPendingListDetail(ModelAndView mav, HttpServletRequest request, @RequestParam String draft_no) {

		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		String member_userid = loginuser.getMember_userid();
		
		Map<String,String> map = new HashMap<>();
		map.put("member_userid", member_userid);
		map.put("draft_no", draft_no);
		
		HashMap<String, String> approvalvo = approvalService.approvalPendingListDetail(map);
		mav.addObject("approvalvo", approvalvo);
		mav.setViewName("/content/approval/approvalDraft");
		
		return mav;
	}
	
	
	// ==== 결재 의견 불러오기 ==== //
	@GetMapping("getApprovalFeedback")
	@ResponseBody
	public List<Map<String, String>> getApprovalFeedback(ModelAndView mav, @RequestParam String draft_no) {

		List<Map<String, String>> approvalvo = approvalService.getApprovalFeedback(draft_no);

		return approvalvo;
	}
	
	
	// ==== 결재문서에서 첨부된 파일 클릭시 다운로드 ==== //
	@GetMapping("download")
	public void download(HttpServletRequest request
			           , HttpServletResponse response
			           , @RequestParam String draft_file_name
			           , @RequestParam String draft_file_origin_name) {
		
		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = null;
		
		try {
			
			if(draft_file_name == null || draft_file_origin_name == null) {
				out = response.getWriter();
				
				out.println("<script type='text/javascript'>alert('첨부파일이 없으므로 파일다운로드가 불가합니다.'); history.back();</script>");
				return;
			}
			else {
				// 파일이 존재하는 경우
								
				HttpSession session = request.getSession();
				
				String root = session.getServletContext().getRealPath("/");  // 파일 위치를 알기위해 webapp 의 절대경로 알아오기
				String path = root + "resources" + File.separator + "draft"; // 파일이 업로드 된 위치
				
				// >>>> 파일 다운로드 <<<< //
				boolean flag = false;	// 파일다운로드 성공/실패 여부
				flag = fileManager.doFileDownload(draft_file_name, draft_file_origin_name, path, response);
				
				if(!flag) {
					// 다운로드 실패의 경우
					out = response.getWriter();
					
					out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>");
				}
			}
		} catch (IOException e) {
			
			try {
				out = response.getWriter();

				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	
	// ==== 결재의견 작성 모달에서 승인버튼 클릭 이벤트 ==== //
	@PostMapping("goApprove")
	@ResponseBody
	public int goApprove(@RequestParam String approval_feedback
						,@RequestParam String fk_draft_no
						,HttpServletRequest request) {
		
		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		String member_userid = loginuser.getMember_userid();
				
		Map<String, String> map = new HashMap<>();
		map.put("approval_feedback", approval_feedback);
		map.put("fk_draft_no", fk_draft_no);
		map.put("member_userid", member_userid);
		
		int n = approvalService.goApprove(map);
		
		return n;
	}
	
	
	// ==== 반려의견 작성 모달에서 반려버튼 클릭 이벤트 ==== //
	@PostMapping("goSendBack")
	@ResponseBody
	public int goSendBack(@RequestParam String approval_feedback
						,@RequestParam String fk_draft_no
						,HttpServletRequest request) {
		
		System.out.println("확인용~~ fk_draft_no : " + fk_draft_no);
		System.out.println("확인용~~ approval_feedback : " + approval_feedback);
		
		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		String member_userid = loginuser.getMember_userid();
				
		Map<String, String> map = new HashMap<>();
		map.put("approval_feedback", approval_feedback);
		map.put("fk_draft_no", fk_draft_no);
		map.put("member_userid", member_userid);
		
		int n = approvalService.goSendBack(map);
		
		return n;
	}
	
	
	// ==== 결재선 결재순위 지정(결재 한 경우 사인 이미지) ==== // 
	@PostMapping("orderByApprovalStep_withSign")
	@ResponseBody
	public List<HashMap<String, String>> orderByApprovalStep_withSign(@RequestParam String draft_no) {
		
		List<HashMap<String, String>> memberList = approvalService.orderByApprovalStep_withSign(draft_no);

		return memberList;
	}
	

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// *** 참조문서함 ***
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ==== 참조문서함 목록 불러오기 ==== //
	@GetMapping("referenceApprovalList")
	public ModelAndView referenceApprovalList(ModelAndView mav
			                                , HttpServletRequest request
			                                , @RequestParam(defaultValue = "") String searchType
			                                , @RequestParam(defaultValue = "") String searchWord
			                                , @RequestParam(defaultValue = "10") int sizePerPage
			                                , @RequestParam(defaultValue = "1") int currentShowPageNo) {

		// >>> 작성자(로그인된 유저) 정보 전달 <<< //
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("member_userid", loginuser.getMember_userid());
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		// >>> 참조문서함 총 게시물 건수 구하기 <<< ///
		int totalCount = 0;
		int totalPage = 0;
		
		totalCount = approvalService.getTotalCount_referenceApproval(paraMap);
		
		// 페이지 당 보여줄 기안문 개수에 따라 총 페이지 수 구하기
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
			
		try {
			// url 에 잘못된 페이지번호가 입력 될 경우 첫 페이지로 처리
			if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
				currentShowPageNo = 1;
			}
		} catch (NumberFormatException e) {
			currentShowPageNo = 1;
		}
		
		
		// >>> 페이지당 보여줄 목록 가져오기 <<< //
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 범위시작
		int endRno = startRno + sizePerPage -1;	// 범위끝
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		// >>> 참조문서함 기안문 불러오기 <<< //
		List<ApprovalVO> referenceApprovalList = approvalService.selectreferenceApprovalList(paraMap);
		mav.addObject("referenceApprovalList", referenceApprovalList);
		
		// 검색어 유지시키기 위해 데이터 전달
		if("draft_form_type".equals(searchType) || "draft_subject".equals(searchType) || "member_name".equals(searchType) || "parent_dept_name".equals(searchType)) {	
			mav.addObject("paraMap", paraMap);
		}
		
		mav.addObject("sizePerPage", sizePerPage);
		
		// >>> 페이지바 생성 <<< //
		int blockSize = 10;	// 한 줄에 보이는 페이지 번호 개수
		int loop = 1;		// 페이지바의 다음 줄을 보여주는데 사용
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
	    String url = "referenceApprovalList";
	    
	    // === [맨처음][이전] 만들기 === //
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>&lt;&lt;</a></li>";

	    if (pageNo != 1) {  // 내가 보고자 하는 넘버가 1페이지가 아닐 때
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>&lt;</a></li>";
	    }

	    while (!(loop > blockSize || pageNo > totalPage)) {  // 10 보다 크거나 totalPage 보다 크면 안 된다
	        if (pageNo == currentShowPageNo) {  // 내가 현재 보고자 하는 페이지
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>" + pageNo + "</li>";
	        } else {
	            pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>" + pageNo + "</a></li>";
	        }
	        
	        loop++;
	        pageNo++;
	    }

	    // === [다음][마지막] 만들기 === //
	    if (pageNo <= totalPage) {  // 맨 마지막 페이지라면 [다음]이 없음
	        pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>&gt;</a></li>";
	    }

	    pageBar += "<li style='display:inline-block; width:70px;  font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>&gt;&gt;</a></li>";

	    pageBar += "</ul>";
       
	    mav.addObject("pageBar", pageBar); 

		mav.setViewName("content/approval/referenceApprovalList");

		return mav;
	}
}
