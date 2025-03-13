package com.spring.med.mypage.controller;

import java.io.File;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.FileManager;
import com.spring.med.common.ManagFileManager;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.mypage.service.MypageService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/mypage/*")
public class MypageController {
	
	@Autowired	// Type 에 따라 알아서 Bean 을 주입해준다.
	private MypageService service;
	
	// === 파일업로드 및 파일다운로드를 해주는 FileManager 클래스 의존객체 주입하기(DI : Dependency Injection) === 
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private ManagFileManager managfileManager;  //프로필 이미지 저장용
	
	@Autowired // Type 에 따라 알아서 Bean 을 주입해준다.
	private FileManager fileManager;  			//사인 이미지 저장용
	
	// === 마이페이지 페이지 요청 시작 === //
	@GetMapping("mypage")
	public String mypage(HttpServletRequest request) {
		
		return "content/mypage/mypage";
	}
	
	@PostMapping("mypageEdit")
	public ModelAndView mypageEdit(@RequestParam() String member_userid, ModelAndView mav, HttpServletRequest request, ManagementVO_ga managementVO_ga,
	                                          MultipartHttpServletRequest mrequest) {
		
		String member_pwd = request.getParameter("member_pwd");
		//System.out.println(member_pwd);
		
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
		
		MultipartFile sign_attach = managementVO_ga.getSign_attach();
		
		if(sign_attach != null && !sign_attach.isEmpty()) {
			
			session = mrequest.getSession();
			root = session.getServletContext().getRealPath("/");
			path =  root+"resources"+File.separator+"sign";  
			
			String newFileName = "";
			byte[] bytes = null;
			long fileSize = 0;
			
			try {
				bytes = sign_attach.getBytes();
			
				String originalFilename = sign_attach.getOriginalFilename();
				//System.out.println("~~~ 확인용 originalFilename => " + originalFilename); 
				
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
				
				// === #151. BoardVO boardvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기
				managementVO_ga.setMember_sign_filename(newFileName);
				// WAS(톰캣)에 저장된 파일명(2025020709291535243254235235234.png)
				
				managementVO_ga.setMember_sign_orgfilename(originalFilename);
				// 게시판 페이지에서 첨부된 파일(강아지.png)을 보여줄 때 사용.
				// 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
				
				fileSize = sign_attach.getSize(); // 첨부파일의 크기(단위는 byte임)
				managementVO_ga.setMember_sign_filesize(String.valueOf(fileSize));
			    
			} catch (Exception e) {
				e.printStackTrace();
				}
			}else {
			    
			    String current_sign_Filename = managementVO_ga.getMember_sign_filename();
			    String current_sign_OriginalFilename = managementVO_ga.getMember_sign_orgfilename();
			    String current_sign_FileSize = managementVO_ga.getMember_sign_filesize(); 
			    
			    managementVO_ga.setMember_sign_filename(current_sign_Filename);  
			    managementVO_ga.setMember_sign_orgfilename(current_sign_OriginalFilename);  
			    managementVO_ga.setMember_sign_filesize(current_sign_FileSize); 
			}
			
		

	        
		int n = service.mypageEdit_update(managementVO_ga, member_pwd);
        
        if (n == 1) {
            mav.addObject("message", "정보 수정이 완료되었습니다.");
            mav.addObject("loc", request.getContextPath() + "/mypage/mypage");
        } else {
            mav.addObject("message", "정보 수정에 실패하였습니다.");
            mav.addObject("loc", "javascript:history.back()");
        }
        
        mav.setViewName("msg");	
    
    return mav;
	
	}

}
