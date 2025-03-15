package com.spring.med.management.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.json.JSONObject;
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

import com.spring.med.common.MyUtil;
import com.spring.med.common.ManagFileManager;
import com.spring.med.management.domain.Child_deptVO_ga;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.management.domain.Parent_deptVO_ga;
import com.spring.med.management.service.ManagementService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/management/*")
public class ManagementController {
	
	@Autowired	// Type 에 따라 알아서 Bean 을 주입해준다.
	private ManagementService managService;
	
	// === 파일업로드 및 파일다운로드를 해주는 FileManager 클래스 의존객체 주입하기(DI : Dependency Injection) === 
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private ManagFileManager managfileManager; 
	
	// === 사원등록 폼 페이지 요청 시작 === //
	@GetMapping("ManagementForm")
	public String ManagementForm_get(HttpServletRequest request) {
		
		return "content/management/ManagementForm";
	}
	
	
	@GetMapping("parentDeptJSON")
	@ResponseBody
	public List<Map<String, String>> parentDeptJSON() {

	    List<Parent_deptVO_ga> parentDeptList = managService.parentDeptList();
	    List<Map<String, String>> parentDeptMapList = new ArrayList<>();
	    
	    for (Parent_deptVO_ga parentDept : parentDeptList) {
	        Map<String, String> parentDeptMap = new HashMap<>();
	        parentDeptMap.put("parent_dept_no", String.valueOf(parentDept.getParent_dept_no()));
	        parentDeptMap.put("parent_dept_name", String.valueOf(parentDept.getParent_dept_name()));
	        parentDeptMapList.add(parentDeptMap);
	    }
	    
	    return parentDeptMapList;
	}

	// === 하위부서 테이블 가져오기 === //
	@GetMapping("childDeptJSON")
	@ResponseBody
	public List<Map<String, String>> childDeptJSON(@RequestParam String dept) {
	    Map<String, Object> paraMap = new HashMap<>();
	    
	    if (!"".equals(dept)) {
	        paraMap.put("dept", dept);
	    }
	    
	    List<Child_deptVO_ga> childDeptList = managService.childDeptJSON(paraMap);
	    List<Map<String, String>> childDeptMapList = new ArrayList<>();
	    
	    for (Child_deptVO_ga childDept : childDeptList) {
	        Map<String, String> childDeptMap = new HashMap<>();
	        childDeptMap.put("fk_child_dept_no", String.valueOf(childDept.getChild_dept_no()));
	        childDeptMap.put("fk_parent_dept_no", String.valueOf(childDept.getFk_parent_dept_no()));
	        childDeptMap.put("child_dept_name", childDept.getChild_dept_name());
	        childDeptMapList.add(childDeptMap);
	    }
	    
	    return childDeptMapList;
	}


	
	
	@PostMapping("ManagementForm")
	public ModelAndView ManagementForm_post(@RequestParam Map<String, String> paraMap,
											ModelAndView mav, ManagementVO_ga managementVO_ga,
											MultipartHttpServletRequest mrequest, HttpServletRequest request) {

		// 아이디와 비밀번호 랜덤 생성 (8자리 숫자)
	    String randomidAndPwd = randomidAndPwd(8);  
	 
		managementVO_ga.setMember_userid(randomidAndPwd);
	    managementVO_ga.setMember_pwd(randomidAndPwd);  
	    
	    paraMap.put("randomidAndPwd", randomidAndPwd);
		
		MultipartFile attach = managementVO_ga.getAttach(); 
		
		if (attach != null && !attach.isEmpty()) { 
		    // attach(첨부파일)가 비어 있지 않으면(즉, 첨부파일이 있는 경우)
			
			// WAS 의 webapp 의 절대경로를 알아와야 한다.
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
//			System.out.println("~~~ 확인용 webapp 의 절대경로 ==> " + root);
			
			String path =  root+"resources"+File.separator+"profile"; 
			
			String newFileName = "";
			// WAS(톰캣)의 디스크에 저장될 파일명
			
			byte[] bytes = null;
			// 첨부파일의 내용물을 담는 것
			
			long fileSize = 0;
			// 첨부파일의 크기
			
			
			try {
				bytes = attach.getBytes();
				// 첨부파일의 내용물을 읽어오는 것
				
				String originalFilename = attach.getOriginalFilename();
				//System.out.println("~~~ 확인용 originalFilename => " + originalFilename); 
				
				newFileName = managfileManager.doFileUpload(bytes, originalFilename, path);
				
				managementVO_ga.setMember_pro_filename(newFileName);
				
				managementVO_ga.setMember_pro_orgfilename(originalFilename);
				
				fileSize = attach.getSize(); // 첨부파일의 크기(단위는 byte임)
				managementVO_ga.setMember_pro_filesize(String.valueOf(fileSize));
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else {
		    // 사용자가 파일을 업로드하지 않았다면 기본 프로필 이미지 설정
		    managementVO_ga.setMember_pro_filename("default_profile.png");
		    managementVO_ga.setMember_pro_orgfilename("default_profile.png");
		    managementVO_ga.setMember_pro_filesize("0");
		}
		
		int n = 0;
		
		n = managService.manag_form(managementVO_ga, paraMap);

		if (n == 1) {
	        mav.setViewName("content/management/managFormDetail");
		} else {
		    mav.setViewName("content/management/managementForm");
		}

		return mav;
	}
	

	// 8자리 랜덤 숫자 생성 메서드(첫자리는 1~9, 뒷자리부터는 0~9)
	private String randomidAndPwd(int length) {
	    Random random = new Random();
	    StringBuilder sb = new StringBuilder();

	    sb.append(random.nextInt(9) + 1); 

	    for (int i = 1; i < length; i++) {
	        sb.append(random.nextInt(10));
	    }

	    return sb.toString();
	}
	
	@GetMapping("managFormDetail")
	public String managFormDetail(ManagementVO_ga managementVO_ga, HttpServletRequest request) {
		
		return "content/management/managFormDetail";	
	}
	// === 사원등록 폼 페이지 요청 끝 === //
	
	
	// === 메인페이지 이전 로그인 폼 페이지 요청 시작 === //
	@GetMapping("login")
	public ModelAndView login(ModelAndView mav) {
		mav.setViewName("content/management/login");
		
		return mav;
	}
	
	@PostMapping("login")
	public ModelAndView login(ModelAndView mav, 
                              HttpServletRequest request,
                              @RequestParam Map<String, String> paraMap) {
		
		
		// === 클라이언트의 IP 주소를 알아오는 것 === //
		// /myspring/src/main/webapp/JSP 파일을 실행시켰을 때 IP 주소가 제대로 출력되기위한 방법.txt 참조할 것!!!
		String clientip = request.getRemoteAddr();
		paraMap.put("clientip", clientip);
		mav = managService.login(mav, request, paraMap);
		
		return mav;
	}
	
	@GetMapping("logout")
	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {
		
		mav = managService.logout(mav, request);
		return mav;
	}
	// === 메인페이지 이전 로그인 폼 페이지 요청 끝 === //
	
	// === 사이드바 프로필 요청 시작 === //
	@PostMapping("sideProfile")
	@ResponseBody
	public String sideProfile(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

		Map<String, String> paramMap = new HashMap<>();
		paramMap.put("member_userid", loginuser.getMember_userid());

	    ManagementVO_ga sideProfile = managService.getView_member_one(paramMap);
	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("member_pro_filename", sideProfile.getMember_pro_filename());
	    jsonObj.put("member_name", sideProfile.getMember_name());
	    jsonObj.put("child_dept_name", sideProfile.getChildVO().getChild_dept_name());
	    jsonObj.put("member_position", sideProfile.getMember_position());
	    
	    return jsonObj.toString();
	}
	// === 사이드바 프로필 요청 끝 === //
	
	
	// === 사원목록 페이지 조회 요청 시작 === //
	@GetMapping("ManagementList")
	public ModelAndView ManagementList(ModelAndView mav, HttpServletRequest request,
										@RequestParam(defaultValue = "") String searchType,
							            @RequestParam(defaultValue = "") String searchWord,
							            @RequestParam(defaultValue = "1") String currentShowPageNo) {
		
		List<ManagementVO_ga> Manag_List = null;
		
		searchWord = searchWord.trim();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		int totalCount = 0;          // 총 게시물 건수
		int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		
		int n_currentShowPageNo = 0; 
		
		// 총 게시물 건수 (totalCount)
		totalCount = managService.get_commuteList_TotalCount(paraMap);
		//System.out.println("~~~ 확인용 totalCount : " + totalCount);
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
		
		try {
			  n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
		
			  if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				  
				  n_currentShowPageNo = 1;
			  }
			  
		} catch(NumberFormatException e) {
			n_currentShowPageNo = 1;
		}
		
		 int startRno = ((n_currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		 int endRno = startRno + sizePerPage - 1; // 끝 행번호 
		 
		 paraMap.put("startRno", String.valueOf(startRno)); 
		 paraMap.put("endRno", String.valueOf(endRno));    
		 
		 paraMap.put("currentShowPageNo", currentShowPageNo);
		 
		 Manag_List = managService.Manag_List(paraMap);
		
		 mav.addObject("Manag_List", Manag_List);
		
		 if("userid".equals(searchType) || 
		    "position".equals(searchType) ||
		    "name".equals(searchType)) { 

			 paraMap.put("searchType", searchType);
			 paraMap.put("searchWord", searchWord);
			 
			 mav.addObject("paraMap", paraMap);	
		 }
		 int blockSize = 10;
 
		 int loop = 1;
		 
		 int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
			  
		 String pageBar = "<ul style='list-style:none;'>";
		 String url = "ManagementList";
			
			// === [맨처음][이전] 만들기 === //
			pageBar += "<li style='display:inline-block; width:70px; font-size:13pt;  '><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1' style='color:#006769; font-weight: bold;'> << </a></li>";
			
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:13pt; '><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"' style='color:#006769; font-weight: bold;'> [이전] </a></li>"; 
			}
			
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == Integer.parseInt(currentShowPageNo)) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:13pt; border:solid 1px gray; color:red; padding:2px 4px;' >"+pageNo+"</li>"; 
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:13pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'  style='color:#006769; font-weight: bold;' >"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:13pt;  color:#006769;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color:#006769; font-weight: bold;'> [다음] </a></li>"; 	
			}
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:13pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color:#006769; font-weight: bold;'> >> </a></li>";
						
			pageBar += "</ul>";	
			
			mav.addObject("pageBar", pageBar);
		
			mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			String currentURL = MyUtil.getCurrentURL(request);
		//	System.out.println("~~~ 확인용 currentURL : " + currentURL);

			mav.addObject("goBackURL", currentURL);
			
			mav.setViewName("content/management/ManagementList");
			
			return mav;
	}
	
	// === 검색어 조회 === //
	@GetMapping("wordSearchShow")
	@ResponseBody
	public List<Map<String, String>> wordSearchShow(@RequestParam Map<String, String> paraMap) {
		
		List<String> wordList = managService.wordSearchShow(paraMap); 
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(wordList != null) {
			for(String word : wordList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				mapList.add(map);
			}// end of for-------------
		}
		
		return mapList;
	}

	
	// === 인사관리 사원수정,삭제 한명의 멤버 조회 === //
	@PostMapping("managementone")
	@ResponseBody
	public String getMemberInfo(@RequestParam() String member_userid) {
				
	    Map<String, String> paramMap = new HashMap<>();
	    paramMap.put("member_userid", member_userid);

	    ManagementVO_ga memberInfo = managService.getView_member_one(paramMap);

	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("member_userid", memberInfo.getMember_userid());
	    jsonObj.put("member_pro_filename", memberInfo.getMember_pro_filename());
	    jsonObj.put("member_pro_orgfilename", memberInfo.getMember_pro_orgfilename());
	    jsonObj.put("member_pro_filesize", memberInfo.getMember_pro_filesize());
	    jsonObj.put("member_name", memberInfo.getMember_name());
	    jsonObj.put("fk_child_dept_no", memberInfo.getFk_child_dept_no());
	    jsonObj.put("child_dept_name", memberInfo.getChildVO().getChild_dept_name());
	    jsonObj.put("fk_parent_dept_no", memberInfo.getChildVO().getFk_parent_dept_no());
	    jsonObj.put("parent_dept_name", memberInfo.getParentVO().getParent_dept_name());
	    jsonObj.put("member_position", memberInfo.getMember_position());
	    jsonObj.put("member_mobile", memberInfo.getMember_mobile());
	    jsonObj.put("member_birthday", memberInfo.getMember_birthday());
	    jsonObj.put("member_gender", memberInfo.getMember_gender());
	    jsonObj.put("member_email", memberInfo.getMember_email());
	    jsonObj.put("member_start", memberInfo.getMember_start());
	    jsonObj.put("member_grade", memberInfo.getMember_grade());
	    jsonObj.put("member_yeoncha", memberInfo.getMember_yeoncha());
	    jsonObj.put("member_workingTime", memberInfo.getMember_workingTime());

	    return jsonObj.toString();
	}
	// === 사원목록 페이지 조회 요청 끝 === //
	
	// === 사원 퇴사처리 요청 시작 === //
	@PostMapping("managementone_delete")
	@ResponseBody
	public String managementone_delete(@RequestParam() String member_userid) {
		//System.out.println(member_userid);
		
		int n = managService.managementone_delete(member_userid);
		

		JSONObject jsObj = new JSONObject();
		jsObj.put("n", n);
			
		return jsObj.toString();
	}
	// === 사원 퇴사처리 요청 끝 === //
	
	
	// === 사원 수정처리 요청 시작 === //
	@PostMapping("Managementone_update")
	public ModelAndView Managementone_update(@RequestParam() String member_userid, ModelAndView mav, HttpServletRequest request, ManagementVO_ga managementVO_ga,
	                                          MultipartHttpServletRequest mrequest) {
		
		MultipartFile attach = managementVO_ga.getAttach(); 

		HttpSession session = mrequest.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources" + File.separator + "profile"; 

		if (attach != null && !attach.isEmpty()) {
		    // 첨부파일이 있을 경우        
		    String newFileName = "";
		    byte[] bytes = null;
		    long fileSize = 0;

		    try {
		        bytes = attach.getBytes();
		        String originalFilename = attach.getOriginalFilename();
		        
		        // 파일 업로드 처리
		        newFileName = managfileManager.doFileUpload(bytes, originalFilename, path);
		        
		        // 기존 파일 삭제 처리
		        if (!"default_profile.png".equals(managementVO_ga.getMember_pro_filename())) {
		            managfileManager.doFileDelete(managementVO_ga.getMember_pro_filename(), path);
		        }
		        
		        // 새로운 파일 정보 업데이트
		        managementVO_ga.setMember_pro_filename(newFileName);
		        managementVO_ga.setMember_pro_orgfilename(originalFilename);
		        
		        fileSize = attach.getSize(); // 첨부파일 크기
		        managementVO_ga.setMember_pro_filesize(String.valueOf(fileSize));

		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		} else {
		    
		    String currentFilename = managementVO_ga.getMember_pro_filename();
		    String currentOriginalFilename = managementVO_ga.getMember_pro_orgfilename();
		    String currentFileSize = managementVO_ga.getMember_pro_filesize(); 
		    
//		    System.out.println(currentFilename);
//		    System.out.println(currentOriginalFilename);
//		    System.out.println(currentFileSize);
		    
		    managementVO_ga.setMember_pro_filename(currentFilename);  
		    managementVO_ga.setMember_pro_orgfilename(currentOriginalFilename);  
		    managementVO_ga.setMember_pro_filesize(currentFileSize); 
		}

	        
		int n = managService.Managementone_update(managementVO_ga);
        
        if (n == 1) {
            mav.addObject("message", "사원정보 수정이 완료되었습니다.");
            mav.addObject("loc", request.getContextPath() + "/management/ManagementList");
        } else {
            mav.addObject("message", "사원정보 수정에 실패하였습니다.");
            mav.addObject("loc", "javascript:history.back()");
        }
        
        mav.setViewName("msg");	
    
    return mav;
}
	
	
	@GetMapping("commuteList")
	public ModelAndView commuteList(ModelAndView mav, HttpServletRequest request,              
									 @RequestParam(defaultValue = "") String searchType, 		
									 @RequestParam(defaultValue = "") String searchWord,
									 @RequestParam(defaultValue = "1") String currentShowPageNo  
									 ) {
		List<Map<String, String>> commuteList = null;
		
		searchWord = searchWord.trim();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		int totalCount = 0;  			
		int sizePerPage = 5; 		 
		int totalPage = 0;
		
		int n_currentShowPageNo = 0;
		
		totalCount = managService.getTotalCount(paraMap);
		//System.out.println("~~~ 확인용 totalCount : " + totalCount);
		
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
		
		try {
			  n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
		
			  if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				  
				  n_currentShowPageNo = 1;
			  }
			  
		} catch(NumberFormatException e) {
			n_currentShowPageNo = 1;
		}
		
		 int startRno = ((n_currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		 int endRno = startRno + sizePerPage - 1; // 끝 행번호 
		 
		 paraMap.put("startRno", String.valueOf(startRno)); 
		 paraMap.put("endRno", String.valueOf(endRno));    
		 
		 paraMap.put("currentShowPageNo", currentShowPageNo);
		 
		 commuteList = managService.manag_commuteList(paraMap);
		
		 mav.addObject("commuteList", commuteList);
		
		 if("userid".equals(searchType) || "name".equals(searchType)) { 

			 paraMap.put("searchType", searchType);
			 paraMap.put("searchWord", searchWord);
			 
			 mav.addObject("paraMap", paraMap);	
		 }
		 int blockSize = 10;
 
		 int loop = 1;
		 
		 int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
			  
		 String pageBar = "<ul style='list-style:none;'>";
		 String url = "commuteList";
			
			// === [맨처음][이전] 만들기 === //
			pageBar += "<li style='display:inline-block; width:70px; font-size:13pt;  '><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1' style='color:#006769; font-weight: bold;'> << </a></li>";
			
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:13pt; '><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"' style='color:#006769; font-weight: bold;'> [이전] </a></li>"; 
			}
			
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == Integer.parseInt(currentShowPageNo)) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:13pt; border:solid 1px gray; color:red; padding:2px 4px;' >"+pageNo+"</li>"; 
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:13pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'  style='color:#006769; font-weight: bold;' >"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:13pt;  color:#006769;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color:#006769; font-weight: bold;'> [다음] </a></li>"; 	
			}
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:13pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color:#006769; font-weight: bold;'> >> </a></li>";
						
			pageBar += "</ul>";	
			
			mav.addObject("pageBar", pageBar);
		
			mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			String currentURL = MyUtil.getCurrentURL(request);
		//	System.out.println("~~~ 확인용 currentURL : " + currentURL);

			mav.addObject("goBackURL", currentURL);

		mav.setViewName("content/management/commuteList");
		
		return mav;
	}
	
	
	@GetMapping("management_chart")
	@ResponseBody
	public List<Map<String, String>> management_chart() {
		List<Map<String, String>> management_chart = managService.management_chart();
		return management_chart;
	}


}
