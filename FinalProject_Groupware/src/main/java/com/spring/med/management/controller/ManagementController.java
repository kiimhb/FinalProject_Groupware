package com.spring.med.management.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

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

import com.spring.med.common.ManagFileManager;
import com.spring.med.management.domain.Child_deptVO_ga;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.management.domain.Parent_deptVO_ga;
import com.spring.med.management.service.ManagementService;

import jakarta.servlet.http.HttpServletRequest;
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
	@GetMapping("ManagementFrom")
	public String ManagementFrom_get(HttpServletRequest request) {
		
		//상위부서 테이블 가져오기
		List<Parent_deptVO_ga> parentDeptList = managService.parentDeptList();
		
		request.setAttribute("parentDeptList", parentDeptList);
		
		return "content/management/ManagementFrom";
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

	
	
	
	@PostMapping("ManagementFrom")
	public ModelAndView ManagementFrom_post(@RequestParam Map<String, String> paraMap,  ModelAndView mav, ManagementVO_ga managementVO_ga,  MultipartHttpServletRequest mrequest) {

		// 아이디와 비밀번호 랜덤 생성 (8자리 숫자)
	    String randomidAndPwd = randomidAndPwd(8);  
	    System.out.println(">>> [DEBUG] 컨트롤러에서 받은 member_mobile: " + paraMap.get("member_mobile"));

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
			
			String path =  root+"resources"+File.separator+"files"; 
			
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
		    mav.setViewName("redirect:/management/managFromDetail");
		} else {
		    mav.setViewName("mycontent1/management/management");
		}

		return mav;
	}
	

	// 8자리 랜덤 숫자 생성 메서드
	private String randomidAndPwd(int length) {
	    Random random = new Random();
	    StringBuilder sb = new StringBuilder();
	    
	    for (int i = 0; i < length; i++) {
	        sb.append(random.nextInt(10));  // 0~9 사이의 숫자를 추가
	    }
	    
	    return sb.toString();
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
	

	
	
	// === 사원목록 페이지 조회 요청 시작 === //
	@GetMapping("ManagementList")
	public String ManagementList(HttpServletRequest request) {
	
		return "content/management/ManagementList";
	}
	// === 사원목록 페이지 조회 요청 끝 === //

}
