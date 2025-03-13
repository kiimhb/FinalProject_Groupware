package com.spring.med.mail.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
			
			String mail_sent_important = mvo.getMail_sent_important();
			
			// System.out.println("값뭐임 : "+ mail_sent_important);
			
			if(mail_sent_important == null) {
				mail_sent_important = "0";
				
				System.out.println("체크안함 : "+ mail_sent_important);
				
				mvo.setMail_sent_important(mail_sent_important);
				
				n = service.insertMailWrite(mvo, fk_member_userid);
			}
			else {
				System.out.println("체크함 : " +mail_sent_important );
				n = service.insertMailWrite(mvo, fk_member_userid);
			}
			
			

		}
		else {
			
			String mail_sent_important = mvo.getMail_sent_important();
			
			if(!mail_sent_important.equals("1")) {
				mail_sent_important = "0";
				
				mvo.setMail_sent_important(mail_sent_important);
				
				n = service.insertMailWriteWithFile(mvo, fk_member_userid);  // <== 파일첨부가 있는 글쓰기
			}
			else {
				n = service.insertMailWriteWithFile(mvo, fk_member_userid);  // <== 파일첨부가 있는 글쓰기
			}
			
			
			
			
			
			 n = service.insertMailWriteWithFile(mvo, fk_member_userid);  // <== 파일첨부가 있는 글쓰기
		}
		

		
		mav.setViewName("content/mail/mailWrite");
		
		return mav;
	}
	
	
	// 받은메일함 페이징 select 해오기
	@GetMapping("mailReceive/{user_id}")
	public ModelAndView mailReceive(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @PathVariable String user_id, 
																												@RequestParam(defaultValue = "1") String currentShowPageNo) {		
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
			
		String fk_member_userid = loginuser.getMember_userid();
		
		//System.out.println("user_id : "+user_id);
		//System.out.println("fk_member_userid : "+fk_member_userid);
						
		if(!user_id.equals(fk_member_userid)) {
			
			// System.out.println("로그인한 아이디와 일치 X");
			
		}
		else {
									
			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("user_id", user_id);
			
			int receiveTotalCount = 0;          // 총 게시물 건수
			int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
			int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
			int n_currentShowPageNo = 0;
			
			receiveTotalCount = service.getTotalCount(paraMap); // 총 환자수 (totalCount)
			
			totalPage = (int) Math.ceil((double)receiveTotalCount/sizePerPage); // 총 페이지수
			
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
			
			//System.out.println("startRno : "+startRno);
			//System.out.println("endRno : "+endRno);
			
			
			paraMap.put("startRno", String.valueOf(startRno));
			paraMap.put("endRno", String.valueOf(endRno));
			paraMap.put("currentShowPageNo", currentShowPageNo);
						
			
			List<MailReceiveVO> mailReceiveList = service.selectMailReceiveList(paraMap);			
								
			mav.addObject("mailReceiveList", mailReceiveList);
		
			
			// 페이지바 만들기 //
			int blockSize = 10;
			
			int loop = 1;
			
			int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
			
			String userid = user_id;
			String pageBar = "<ul style='list-style:none;'>";
			String url = "mailReceive";
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo=1'>[맨처음]</a></li>";
			
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
			}
			
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == Integer.parseInt(currentShowPageNo)) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>"; 
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
			}
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
						
			pageBar += "</ul>";	
			
			mav.addObject("pageBar", pageBar);
			 
			
			///////////////////////////////////////////////////////////

			mav.addObject("receiveTotalCount", receiveTotalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			
			mav.setViewName("content/mail/mailReceive");
			
			
		}


		
		return mav;
	}
	
	// 
	@PostMapping("mailReceive/{user_id}")
	public ModelAndView updateImportant(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @PathVariable String user_id, 
										@RequestParam(defaultValue = "1") String currentShowPageNo) {
		
		String mail_sent_no = request.getParameter("mail_sent_no");
					
		System.out.println("오니");
		
		//int n = service.updateImportant(mail_sent_no);
		
		
	return mav;
				
	}
	
	// 보낸메일함 페이징 select 해오기
	@GetMapping("mailSend/{user_id}")
	public ModelAndView mailSent(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @PathVariable String user_id, 
																												@RequestParam(defaultValue = "1") String currentShowPageNo) {		
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
			
		String fk_member_userid = loginuser.getMember_userid();
		
		//System.out.println("user_id : "+user_id);
		//System.out.println("fk_member_userid : "+fk_member_userid);
						
		if(!user_id.equals(fk_member_userid)) {
			
			System.out.println("로그인한 아이디와 일치 X");
			
		}
		else {
			
						
			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("user_id", user_id);
			
			int sentTotalCount = 0;          // 총 게시물 건수
			int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
			int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
			int n_currentShowPageNo = 0;
			
			sentTotalCount = service.getTotalCountSent(paraMap); // 총 환자수 (totalCount)
			
			totalPage = (int) Math.ceil((double)sentTotalCount/sizePerPage); // 총 페이지수
			
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
			
			//System.out.println("startRno : "+startRno);
			//System.out.println("endRno : "+endRno);
			
			
			paraMap.put("startRno", String.valueOf(startRno));
			paraMap.put("endRno", String.valueOf(endRno));
			paraMap.put("currentShowPageNo", currentShowPageNo);
						
			
			List<MailReceiveVO> mailSentList = service.selectMailSentList(paraMap);			
								
			//System.out.println("보낸메일리스트나오냐 : "+mailSentList);
			
			mav.addObject("mailSentList", mailSentList);
		
			
			// 페이지바 만들기 //
			int blockSize = 10;
			
			int loop = 1;
			
			int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
			
			String pageBar = "<ul style='list-style:none;'>";

			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo=1'>[맨처음]</a></li>";
			
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
			}
			
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == Integer.parseInt(currentShowPageNo)) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>"; 
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
			}
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
						
			pageBar += "</ul>";	
			
			mav.addObject("pageBar", pageBar);
			 
			
			///////////////////////////////////////////////////////////

			mav.addObject("sentTotalCount", sentTotalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			
			mav.setViewName("content/mail/mailSend");
			
			
		}


		
		return mav;
	}
	
	
	// 중요메일 유무 알아오기
	@GetMapping("isImportantMail")
	@ResponseBody
	public List<HashMap<String, String>> isImportantMail(HttpServletRequest request){
		
		HttpSession session = request.getSession();
	    ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

	    String member_userid = loginuser.getMember_userid();

	    List<HashMap<String, String>> mailNoList = service.isImportantMail(member_userid);
	   // System.out.println("확인용 " +mailNoList);
	    
	    //System.out.println(mailNoList.get(1));
		
		return mailNoList;
	}
	
	
	// 받은메일함 중요메일 등록 & 해제
	@PostMapping("IDImportant")
	@ResponseBody
	public Map<String, Object> IDImportant(@RequestParam String fk_mail_sent_no, @RequestParam String mail_received_important, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");		
		
		Map<String, Object> resultMap = new HashMap<>();
		if(loginuser != null) {
			String user_id = loginuser.getMember_userid();
			
			Map<String, String> paraMap=new HashMap<>();
			
			paraMap.put("fk_mail_sent_no", fk_mail_sent_no);
			paraMap.put("mail_received_important", mail_received_important);
			paraMap.put("user_id", user_id);
			
			System.out.println("넘어오는 값이 얼마니 + "+mail_received_important);
			
	        if (mail_received_important.equals("0")) {
	        	// 중요메일 insert 0->1(트랜잭션)
	            int n = service.updateImportant(paraMap);
	            
	           // System.out.println("잘되니 : "+n );
	            resultMap.put("success", true);	            
	        } else {
	        	// 중요메일 insert 1->0(트랜잭션)
	            int result = service.updateImportantreturn(paraMap);
	            //System.out.println("밑에잘되니 : "+result);
	            resultMap.put("success2", true);
	        }
	    } else {
	        resultMap.put("success", false);
	    }
		    
		    return resultMap;
		}
	
	
	// 받은메일함 보관하기
	@PostMapping("sendMailStorage")
	@ResponseBody
	public int sendMailStorage( HttpServletRequest request, HttpServletResponse response, @RequestBody List<Integer> mailNos) {
		
		
		System.out.println("체크한번호들 : "+mailNos);
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String user_id = loginuser.getMember_userid();
		
		Map<String, String> paraMap=new HashMap<>();
		
		paraMap.put("user_id", user_id);
		
		
		// 체크한 메일 보관함 옮기기
		int n = service.sendMailStorage(mailNos, paraMap);
				
		
		
		return n ;
	}
	
	// 받은메일함 휴지통
	@PostMapping("sendMailTrash")
	@ResponseBody
	public int sendMailTrash( HttpServletRequest request, HttpServletResponse response, @RequestBody List<Integer> mailNos) {
		
		
		System.out.println("체크한번호들 : "+mailNos);
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String user_id = loginuser.getMember_userid();
		
		Map<String, String> paraMap=new HashMap<>();
		paraMap.put("user_id", user_id);
		
		// 체크한 메일 휴지통 옮기기
		int n = service.sendMailTrash(mailNos, paraMap);
						
		
		return n ;
	}
	
	
	
	// 보낸메일함 중요메일 유무 알아오기
	@GetMapping("isImportantMailSent")
	@ResponseBody
	public List<HashMap<String, String>> isImportantMailSent(HttpServletRequest request){
		
		HttpSession session = request.getSession();
	    ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

	    String member_userid = loginuser.getMember_userid();

	    List<HashMap<String, String>> mailNoList = service.isImportantMailSent(member_userid);
	    System.out.println("확인용 " +mailNoList);
	    
	    //System.out.println(mailNoList.get(1));
		
		return mailNoList;
	}
	
	// 보낸메일함 중요메일 등록 & 해제
	@PostMapping("IDImportantSent")
	@ResponseBody
	public Map<String, Object> IDImportantSent(@RequestParam String mail_sent_no, @RequestParam String mail_sent_important, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");		
		
		Map<String, Object> resultMap = new HashMap<>();
		if(loginuser != null) {
			String user_id = loginuser.getMember_userid();
			
			Map<String, String> paraMap=new HashMap<>();
			
			paraMap.put("mail_sent_no", mail_sent_no);
			paraMap.put("mail_sent_important", mail_sent_important);
			paraMap.put("user_id", user_id);
			
			System.out.println("넘어오는 값이 얼마니 + "+mail_sent_important);
			
	        if (mail_sent_important.equals("0")) {
	        	// 중요메일 insert 0->1(트랜잭션)
	            int n = service.updateImportantSent(paraMap);
	            
	           // System.out.println("잘되니 : "+n );
	            resultMap.put("success", true);	            
	        } else {
	        	// 중요메일 insert 1->0(트랜잭션)
	            int result = service.updateImportantreturnSent(paraMap);
	            //System.out.println("밑에잘되니 : "+result);
	            resultMap.put("success2", true);
	        }
	    } else {
	        resultMap.put("success", false);
	    }
		    
		    return resultMap;
		}
	
	
	
	// 보낸메일함 휴지통 보내기
	@PostMapping("sendMailTrashSent")
	@ResponseBody
	public int sendMailTrashSent( HttpServletRequest request, HttpServletResponse response, @RequestBody List<Integer> mailNos) {
		
		
		System.out.println("체크한번호들 : "+mailNos);
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String user_id = loginuser.getMember_userid();
		
		Map<String, String> paraMap=new HashMap<>();
		paraMap.put("user_id", user_id);
		
		// 보낸메일함 체크한 메일 휴지통 옮기기
		int n = service.sendMailTrashSent(mailNos, paraMap);
						
		
		return n ;
	}
	
	
	// 휴지통 페이징 select 해오기
	@GetMapping("mailTrash/{user_id}")
	public ModelAndView mailTrash(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @PathVariable String user_id, 
																												@RequestParam(defaultValue = "1") String currentShowPageNo) {		
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

		String abc = "abc";				
		
		if(!user_id.equals(user_id)) {
			
			// System.out.println("로그인한 아이디와 일치 X");
			String message = "로그인한 아이디와 일치하지 않습니다.";
					
			mav.addObject("message", message);
			
		}
		else {									
			
			if(user_id != null) {
				
			
			// 보낸메일함 휴지통 총갯수 가져오기			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("user_id", user_id);
			
			int receiveTotalCount = 0;          // 총 게시물 건수
			int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
			int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
			int n_currentShowPageNo = 0;
			
			// 보낸메일함 휴지통 총갯수 가져오기
			receiveTotalCount = service.getSentTrashTotalCount(paraMap); // 총 환자수 (totalCount)
			
			totalPage = (int) Math.ceil((double)receiveTotalCount/sizePerPage); // 총 페이지수
			
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
			
			//System.out.println("startRno : "+startRno);
			//System.out.println("endRno : "+endRno);
			
			
			paraMap.put("startRno", String.valueOf(startRno));
			paraMap.put("endRno", String.valueOf(endRno));
			paraMap.put("currentShowPageNo", currentShowPageNo);
						
			// 보낸메일함 휴지통 리스트
			List<MailSentVO> mailSentTrashList = service.selectMailTrashList(paraMap);			
								
			mav.addObject("mailSentTrashList", mailSentTrashList);
		
			
			// 페이지바 만들기 //
			int blockSize = 10;
			
			int loop = 1;
			
			int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
			
			String userid = user_id;
			String pageBar = "<ul style='list-style:none;'>";
			String url = "mailReceive";
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo=1'>[맨처음]</a></li>";
			
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
			}
			
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == Integer.parseInt(currentShowPageNo)) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>"; 
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
			}
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
						
			pageBar += "</ul>";	
			
			mav.addObject("pageBar", pageBar);
			 
			
			///////////////////////////////////////////////////////////

			mav.addObject("receiveTotalCount", receiveTotalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			
			
			// 보낸메일함 휴지통 총갯수 가져오기			
			Map<String, String> paraMap1 = new HashMap<>();
			
			paraMap.put("user_id", user_id);
			
			int receiveTotalCount1 = 0;          // 총 게시물 건수
			int sizePerPage1 = 10;        // 한 페이지당 보여줄 게시물 건수
			int totalPage1 = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
			int n_currentShowPageNo1 = 0;
			
			// 보낸메일함 휴지통 총갯수 가져오기
			receiveTotalCount1 = service.getReceivedTrashTotalCount(paraMap); // 총 환자수 (totalCount)
			
			totalPage1 = (int) Math.ceil((double)receiveTotalCount1/sizePerPage1); // 총 페이지수
			
			try {
				n_currentShowPageNo1 = Integer.parseInt(currentShowPageNo);
				
				if(n_currentShowPageNo1 < 1 || n_currentShowPageNo1 > totalPage1) {
					n_currentShowPageNo1 = 1;
				}
			} catch(NumberFormatException e) {
				n_currentShowPageNo1 = 1;
			}
			
			int startRno1 = ((n_currentShowPageNo1 - 1) * sizePerPage1) + 1; // 시작 행번호
			int endRno1 = startRno + sizePerPage1 - 1; // 끝 행번호 
			
			//System.out.println("startRno : "+startRno);
			//System.out.println("endRno : "+endRno);
			
			
			paraMap.put("startRno", String.valueOf(startRno1));
			paraMap.put("endRno", String.valueOf(endRno1));
			paraMap.put("currentShowPageNo", currentShowPageNo);
						
			// 보낸메일함 휴지통 리스트
			List<MailSentVO> mailReceivedTrashList = service.selectReceivedMailTrashList(paraMap);			
								
			mav.addObject("mailReceivedTrashList", mailReceivedTrashList);
		
			
			// 페이지바 만들기 //
			int blockSize1 = 10;
			
			int loop1 = 1;
			
			int pageNo1 = ((n_currentShowPageNo1 - 1)/blockSize1) * blockSize1 + 1;
			
			String userid1 = user_id;
			String pageBar1 = "<ul style='list-style:none;'>";
			String url1 = "mailTrash";
			
			pageBar1 += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+userid1+"?currentShowPageNo=1'>[맨처음]</a></li>";
			
			if(pageNo1 != 1) {
				pageBar1 += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+userid1+"?currentShowPageNo="+(pageNo1-1)+"'>[이전]</a></li>"; 
			}
			
			
			while( !(loop1 > blockSize1 || pageNo1 > totalPage1) ) {
				
				if(pageNo1 == Integer.parseInt(currentShowPageNo)) {
					pageBar1 += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo1+"</li>"; 
				}
				else {
					pageBar1 += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo="+pageNo1+"'>"+pageNo1+"</a></li>"; 
				}
				
				loop1++;
				pageNo1++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo1 <= totalPage1) {
				pageBar1 += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo="+pageNo1+"'>[다음]</a></li>"; 	
			}
			
			pageBar1 += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+userid+"?currentShowPageNo="+totalPage1+"'>[마지막]</a></li>";
						
			pageBar1 += "</ul>";	
			
			mav.addObject("pageBar1", pageBar1);
			 
			
			///////////////////////////////////////////////////////////

			mav.addObject("receiveTotalCount1", receiveTotalCount1);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage1", sizePerPage1); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			
			
			
			
			
			
			}

			
			
		}

		mav.setViewName("content/mail/mailTrash");
		
		return mav;
	}
	
	
	
	
	
	
	// 보낸메일 휴지통 메일 복구하기 1->0
	@PostMapping("sentMailRestore")
	@ResponseBody
	public int sentMailRestore( HttpServletRequest request, HttpServletResponse response, @RequestBody List<Integer> mailNos) {
		
		// int n = 0;
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String user_id = loginuser.getMember_userid();
		
		Map<String, String> paraMap=new HashMap<>();
		paraMap.put("user_id", user_id);
		
		System.out.println("체크한번호들 : "+mailNos);				
		
		int n = service.sentMailRestore(mailNos, paraMap);						
		
		return n;
	}
	
	
	// 받은메일 휴지통 메일 복구하기 1->0
	@PostMapping("receivedMailRestore")
	@ResponseBody
	public int receivedMailRestore( HttpServletRequest request, HttpServletResponse response, @RequestBody List<Integer> mailNos) {
		
		// int n = 0;
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String user_id = loginuser.getMember_userid();
		
		Map<String, String> paraMap=new HashMap<>();
		paraMap.put("user_id", user_id);
		
		System.out.println("체크한번호들 : "+mailNos);				
		
		int n = service.receivedMailRestore(mailNos, paraMap);						
		
		return n;
	}
	
	
	// 휴지통 보낸 메일 영구삭제하기
	@PostMapping("sentMailDelete")
	@ResponseBody
	public int sentMailDelete( HttpServletRequest request, HttpServletResponse response, @RequestBody List<Integer> mailNos) {
		
		// int n = 0;
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String user_id = loginuser.getMember_userid();
		
		Map<String, String> paraMap=new HashMap<>();
		paraMap.put("user_id", user_id);
		
		System.out.println("체크한번호들 : "+mailNos);				
		
		int n = service.sentMailDelete(mailNos, paraMap);						
		
		return n;
	}
	
	
	// 휴지통 받은 메일 영구삭제하기
	@PostMapping("receivedMailDelete")
	@ResponseBody
	public int receivedMailDelete( HttpServletRequest request, HttpServletResponse response, @RequestBody List<Integer> mailNos) {
		
		// int n = 0;
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String user_id = loginuser.getMember_userid();
		
		Map<String, String> paraMap=new HashMap<>();
		paraMap.put("user_id", user_id);
		
		System.out.println("체크한번호들 : "+mailNos);				
		
		int n = service.receivedMailDelete(mailNos, paraMap);						
		
		return n;
	}
	
	
	/* 보관함 보류
	// 보관함 페이징 select 해오기
	@GetMapping("mailStorage/{user_id}")
	public ModelAndView mailStorage(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, @PathVariable String user_id, 
																												@RequestParam(defaultValue = "1") String currentShowPageNo) {		
		
		HttpSession session = request.getSession();		
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
			
		String fk_member_userid = loginuser.getMember_userid();
		
		//System.out.println("user_id : "+user_id);
		//System.out.println("fk_member_userid : "+fk_member_userid);
						
		if(!user_id.equals(fk_member_userid)) {
			
			// System.out.println("로그인한 아이디와 일치 X");
			String message = "로그인한 아이디와 일치하지 않습니다.";
					
			mav.addObject("message", message);
			
		}
		else {
									
			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("user_id", user_id);
			
			int receiveTotalCount = 0;          // 총 게시물 건수
			int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
			int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
			int n_currentShowPageNo = 0;
			
			receiveTotalCount = service.getStorageTotalCount(paraMap); // 총 환자수 (totalCount)
			
			totalPage = (int) Math.ceil((double)receiveTotalCount/sizePerPage); // 총 페이지수
			
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
			
			//System.out.println("startRno : "+startRno);
			//System.out.println("endRno : "+endRno);
			
			
			paraMap.put("startRno", String.valueOf(startRno));
			paraMap.put("endRno", String.valueOf(endRno));
			paraMap.put("currentShowPageNo", currentShowPageNo);
						
			
			List<MailReceiveVO> mailStorageList = service.selectMailStorageList(paraMap);			
								
			mav.addObject("mailStorageList", mailStorageList);
		
			
			// 페이지바 만들기 //
			int blockSize = 10;
			
			int loop = 1;
			
			int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
			
			String userid = user_id;
			String pageBar = "<ul style='list-style:none;'>";
			String url = "mailReceive";
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo=1'>[맨처음]</a></li>";
			
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
			}
			
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == Integer.parseInt(currentShowPageNo)) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>"; 
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
			}
			
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+user_id+"?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
						
			pageBar += "</ul>";	
			
			mav.addObject("pageBar", pageBar);
			 
			
			///////////////////////////////////////////////////////////

			mav.addObject("receiveTotalCount", receiveTotalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
			
			
			mav.setViewName("content/mail/mailStorage");			
			
		}


		
		return mav;
	}
	*/
	
}
