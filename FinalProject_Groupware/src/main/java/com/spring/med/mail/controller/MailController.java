package com.spring.med.mail.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.common.FileManager;
import com.spring.med.mail.domain.MailReceiveVO;
import com.spring.med.mail.domain.MailSentVO;
import com.spring.med.mail.service.MailService;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping(value="/mail/*")
public class MailController {
	
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private MailService service;

	
	// === #150. 파일업로드 및 파일다운로드를 해주는 FileManager 클래스 의존객체 주입하기(DI : Dependency Injection) === 
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private FileManager fileManager;
	
	
	// 메일 쓰기창 보여주기
	@GetMapping("mailWrite")
	public ModelAndView showMailWrite(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {

		
		mav.setViewName("content/mail/mailWrite");
		
		return mav;
	}
	// 작성된 메일 발신메일 테이블에 insert 하기
	@PostMapping("mailWrite")
	public ModelAndView insertMailWrite(MultipartHttpServletRequest mrequest, HttpServletResponse response, ModelAndView mav, @ModelAttribute MailSentVO mvo, @RequestParam String mail_received_userid) {

		
		// System.out.println("중요체크 : "+ mvo.getMail_sent_important());
		
		/*
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
			
		String fk_member_userid = loginuser.getMember_userid();
		*/
		
		String fk_member_userid = mail_received_userid;
		
		//  === #148. !!! 첨부파일이 있는 경우 작업 시작 !!! ===
		MultipartFile attach = mvo.getAttach(); 
		
		if(attach != null) {
			// attach(첨부파일)가 비어 있지 않으면(즉, 첨부파일이 있는 경우라면)
			
			/*
			   1. 사용자가 보낸 첨부파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다.
			   >>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기 
			       우리는 WAS 의 /myspring/src/main/webapp/resources/files 라는 폴더를 생성해서 여기로 업로드 해주도록 할 것이다. 
			 */
			
			// WAS 의 webapp 의 절대경로를 알아와야 한다.
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
		//	System.out.println("~~~ 확인용 webapp 의 절대경로 ==> " + root);
			// ~~~ 확인용 webapp 의 절대경로 ==> C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\
			
			String path =  root+"resources"+File.separator+"files";  
			/* File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
		       운영체제가 Windows 이라면 File.separator 는  "\" 이고,
		       운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
		    */
			
			// path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
		//	System.out.println("~~~ 확인용 path ==> " + path);
			// ~~~ 확인용 path ==> C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\resources\files
			
			/*
			   2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
			*/
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
				// attach.getOriginalFilename() 이 첨부파일명의 파일명(예: 강아지.png) 이다. 
				
				System.out.println("~~~ 확인용 originalFilename => " + originalFilename); 
				
				// 첨부되어진 파일을 업로드 하는 것이다.
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
				
				// === #151. BoardVO boardvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기
				mvo.setMail_sent_file(newFileName);
				// WAS(톰캣)에 저장된 파일명(2025020709291535243254235235234.png)
				
				mvo.setMail_sent_file_origin(originalFilename);
				// 게시판 페이지에서 첨부된 파일(강아지.png)을 보여줄 때 사용.
				// 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
				
				fileSize = attach.getSize(); // 첨부파일의 크기(단위는 byte임)
				mvo.setMail_sent_filesize(String.valueOf(fileSize)) ;
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}// end of if(attach != null)---------
	//  === !!! 첨부파일이 있는 경우 작업 끝 !!! ===
				
	//	int n = service.add(boardvo);  // <== 파일첨부가 없는 글쓰기
		
		// === #152. 파일첨부가 있는 글쓰기 또는 파일첨부가 없는 글쓰기로 나뉘어서 service 호출하기 시작 === //
		// 먼저 위의 int n = service.add(boardvo); 부분을 주석처리 하고서 아래와 같이 한다.
		
		int n = 0;
		
		if(attach.isEmpty()) {
			// 파일첨부가 없는 경우라면
			n = service.insertMailWrite(mvo, fk_member_userid);			

		}
		else {
			// 파일첨부가 있는 경우라면 
			 n = service.insertMailWriteWithFile(mvo, fk_member_userid);  // <== 파일첨부가 있는 글쓰기
		}
		

		
		mav.setViewName("content/mail/mailWrite");
		
		return mav;
	}
	
	
	// 받은메일
	@GetMapping("mailReceive/{user_id}")
	public ModelAndView mailReceive(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @PathVariable String user_id) {		
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
			
		String fk_member_userid = loginuser.getMember_userid();
		
		//System.out.println("user_id : "+user_id);
		//System.out.println("fk_member_userid : "+fk_member_userid);
						
		if(!user_id.equals(fk_member_userid)) {
			
			System.out.println("로그인한 아이디와 일치 X");
			
		}
		else {
			
			List<MailReceiveVO> mailReceiveList = service.selectMailReceiveList(user_id);			
								
			mav.addObject("mailReceiveList", mailReceiveList);
		
			System.out.println("리스트나오니 : "+mailReceiveList);
			
			mav.setViewName("content/mail/mailReceive");
			
			
		}


		
		return mav;
	}
	
	
	
	
}
