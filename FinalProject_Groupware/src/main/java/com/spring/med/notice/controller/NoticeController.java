package com.spring.med.notice.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
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
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.notice.domain.NoticeVO;
import com.spring.med.notice.service.NoticeService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/notice/*")
public class NoticeController {

	@Autowired
	private NoticeService service;
	
	@Autowired
	private FileManager fileManager;
	
	// 내 아이디 65897690
	// 공지사항목록
	// 조건1) 공지대상 부서가 어디인가? 전체공지 / 진료과 / 간호과 / 원무과 등 ...
	@GetMapping("list")
	public ModelAndView requiredLogin_notice_list(HttpServletRequest request, HttpServletResponse response,
												  ModelAndView mav, 
												  @RequestParam(defaultValue = "1") String currentShowPageNo) {

		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		// 글 조회수 증가를 위함 
		session.setAttribute("readCountPermission", "yes");
		
		String fk_member_userid = loginuser.getMember_userid();
		int member_grade = Integer.parseInt(loginuser.getMember_grade()); // 로그인 한 유저의 grade-level 알아오기 
		String fk_child_dept_no = loginuser.getFk_child_dept_no(); 	//  로그인 한 유저의 부서 알아오기
																   	// 1~7:진료부 / 8~10:간호부 / 11~13:경영지원부
		mav.addObject("member_grade", member_grade);
		mav.addObject("fk_member_userid", fk_member_userid);
		
		int parent_dept_no; // 1: 진료부 2:간호부 3: 경영지원부
		int child_dept_no = Integer.parseInt(fk_child_dept_no); // 값 비교를 위해 int 형으로 바꿈
		
		if(child_dept_no >= 1 && child_dept_no <= 7) {
			parent_dept_no = 1; // 진료부
		}
		else if(child_dept_no >= 8 && child_dept_no <= 10) {
			parent_dept_no = 2; // 간호부
		}
		else {
			parent_dept_no = 3; // 경영지원부
		}

		
		Map<String, Object> paraMap = new HashMap<>();
		List<Integer> parent_deptList = Arrays.asList(0, parent_dept_no); // 0 은 전체공지 , 나머지는 매번 바뀐다.
		
		paraMap.put("parent_deptList", parent_deptList);
			
		int totalCount = 0;          // 총 게시물 건수
		int sizePerPage = 10;        // 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;           // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int n_currentShowPageNo = 0;
		
		totalCount = service.getNoticeCount(paraMap); // 개인별(부서별) 총 공지사항 개수 (totalCount) 전체공지 + 해당 부서 공지사항
		// System.out.println("totalCount"+totalCount);
		mav.addObject("totalCount", totalCount);
		
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage); // 총 페이지수
		
		try {
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				n_currentShowPageNo = 1;
			}
		} catch(NumberFormatException e) {
			n_currentShowPageNo = 1;
		}
		
		int startRno = ((n_currentShowPageNo - 1) * sizePerPage) + 1;
		int endRno = startRno + sizePerPage - 1;
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		// System.out.println("startRno"+startRno+"endRno"+endRno);
		
		List<NoticeVO> notice_list = service.notice_list(paraMap);
		// System.out.println(notice_list);
		mav.addObject("notice_list", notice_list);
		
		// 페이지바 만들기 //
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "list";
	
		pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?parent_dept_no="+parent_dept_no+"&currentShowPageNo=1'><<</a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?parent_dept_no="+parent_dept_no+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; 
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; padding:2px 4px;'>"+pageNo+"</li>"; 
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?parent_dept_no="+parent_dept_no+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;
			pageNo++;
		}// end of while-------------------------------
		
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?parent_dept_no="+parent_dept_no+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 	
		}
		
		pageBar += "<li style='display:inline-block; width:70px;  font-size:12pt;'><a href='"+url+"?parent_dept_no="+parent_dept_no+"&currentShowPageNo="+totalPage+"'>>></a></li>";
					
		pageBar += "</ul>";	
		
		mav.addObject("pageBar", pageBar);
		 
		
		///////////////////////////////////////////////////////////
		mav.addObject("loginuser", loginuser);
		mav.addObject("totalCount", totalCount);   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
		mav.addObject("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.

		
		mav.setViewName("content/notice/notice");
		return mav;
	}
	
	// 공지사항 자세히보기 
	@GetMapping("detail/{notice_no}")
	public ModelAndView notice_detail(@PathVariable String notice_no, ModelAndView mav
									  , HttpServletRequest request) {
	
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String login_userid = null;
		if(loginuser != null) {
			login_userid = loginuser.getMember_userid();
			// login_userid 는 로그인 되어진 사용자의 userid 이다.
		}
	
		
		mav.addObject("login_userid", login_userid);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("notice_no", notice_no);
		paraMap.put("login_userid", login_userid);
		
		NoticeVO noticevo = null;
		
		if("yes".equals( (String) session.getAttribute("readCountPermission") )) {
			// 글목록보기인 /list 페이지를 클릭한 다음에 특정글을 조회해온 경우이다.

			noticevo = service.getNoticeView(paraMap);
			// 글 조회수 증가와 함께 글 1개를 조회를 해오는 것
			
			session.removeAttribute("readCountPermission");
			// 중요함!! session 에 저장된 readCountPermission 을 삭제한다. 
		}
		else {
		    // 웹브라우저에서 새로고침(F5)을 클릭한 경우이다.
			noticevo = service.getView_no_increase_readCount(paraMap);
			// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
			
			if(noticevo == null) {
				mav.setViewName("redirect:/notice/list");
				return mav;
			}
		}
		
		// enter 줄바꿈으로 변환
		noticevo.setNotice_content(noticevo.getNotice_content().replace("\n", "<br/>")); 
		
		mav.addObject("notice_no", notice_no);
		mav.addObject("login_userid", login_userid);
		
		mav.addObject("loginuser", loginuser);
		mav.addObject("noticevo", noticevo);
		mav.setViewName("content/notice/noticeDetail");
		
		return mav;
	}
	
	
	// 공지사항 작성하기
	@PostMapping("write")
	public ModelAndView write_notice(@ModelAttribute NoticeVO noticevo, ModelAndView mav,
							   		 MultipartHttpServletRequest mrequest) {
		
		MultipartFile attach = noticevo.getAttach(); 
		
		if(attach != null) {
			// attach(첨부파일)가 비어 있지 않으면(즉, 첨부파일이 있는 경우라면)
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
			String path = root + "resources" + File.separator + "noticefiles";
			// 첨부파일이 저장될 was 의 폴더
			
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
				// 첨부파일명의 파일명(예: 강아지.png)
				
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
				// 첨부되어진 파일을 업로드 하는 것이다.
				
				noticevo.setNotice_fileName(newFileName);
				// noticevo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기
				
				noticevo.setNotice_orgFilename(originalFilename);
				// 게시판 페이지에서 첨부된 파일(강아지.png)을 보여줄 때 사용.
				
				fileSize = attach.getSize(); // 첨부파일의 크기(단위는 byte임)
				noticevo.setNotice_fileSize(String.valueOf(fileSize));
				
			} catch(Exception e) {
				e.printStackTrace();
			}
	
		} // end of if(attach != null)
		
		int n = 0;
		
		if(attach.isEmpty()) { // 첨부 파일없음
			n = service.notice_write(noticevo); 
		}
		else { // 첨부파일있음
			n = service.notice_file_write(noticevo);	
		}
		
		if(n==1) {
			mav.setViewName("redirect:/notice/list");
			// 작성을 완료하면 공지사항 목록 페이지로 이동한다.
		}
		
		return mav;
	}

	
	// 공지사항의 첨부파일 다운로드하기
	@GetMapping("download")
	public void download(HttpServletRequest request, HttpServletResponse response) {
		
		String notice_no = request.getParameter("notice_no"); // 첨부파일이 있는 공지사항 번호 받아오기 
		
		// **** 웹브라우저에 출력하기 시작 **** //
		// HttpServletResponse response 객체는 전송되어져온 데이터를 조작해서 결과물을 나타내고자 할때 쓰인다.
		response.setContentType("text/html; charset=UTF-8");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("notice_no", notice_no);
		
		PrintWriter out = null;
		// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
		
		try {
			Integer.parseInt(notice_no);
			
			NoticeVO noticevo = service.getView_no_increase_readCount(paraMap); // 글 조회하기
			
			if(noticevo == null || (noticevo != null && noticevo.getNotice_fileName() == null)) {
				
				out = response.getWriter();
				
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
				return;
			}
			else {
				// 정상적으로 다운로드를 할 경우 
				
				String fileName = noticevo.getNotice_fileName();
				String orgFilename = noticevo.getNotice_orgFilename();
				
				// WAS 의 webapp 의 절대경로를 알아와야 한다.
				HttpSession session = request.getSession();
				String root = session.getServletContext().getRealPath("/");
				
				String path = root+"resources"+File.separator+"noticefiles";
				
				// ***** file 다운로드 하기 ***** //
				boolean flag = false; // file 다운로드 성공, 실패인지 여부를 알려주는 용도
				// 다운로드 성공 true, 다운로드 실패 false
				flag = fileManager.doFileDownload(fileName, orgFilename, path, response);

				System.out.println("flag"+flag);
				if(!flag) {
					// 다운로드가 실패한 경우 메시지를 띄운다.
					out = response.getWriter();
					out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>");
				}
			}
			
		} catch(NumberFormatException | IOException e) {
			try {
				out = response.getWriter();
				// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
				
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
		
	} // end of public void download(HttpServletRequest request, HttpServletResponse response)
	
	
	
	// 공지사항 삭제하기
	@DeleteMapping("delete")
	public ResponseEntity<Map<String, String>> delete_notice(@RequestParam String notice_no, HttpServletRequest request) {
		
		Map<String, String> response = new HashMap<>();
		
		// 파일첨부 또는 사진첨부 또는 파일첨부 및 사진첨부가 된 글이라면 글 삭제시 먼저 첨부파일, 사진파일을 삭제해주어야 한다 //
		Map<String, String> noticemap = service.getNotice_delete(notice_no);
		String filename = noticemap.get("notice_fileName");
		//  WAS(톰캣) 디스크에 저장된 '첨부 파일명' 이다.
		
		Map<String, String> paraMap = new HashMap<>();
		
		if(filename != null && !"".equals(filename)) {
			// 첨부파일이 존재하는 경우
			
			HttpSession session = request.getSession(); 
			String root = session.getServletContext().getRealPath("/");  
			
			String filepath = root+"resources"+File.separator+"noticefiles";
			
			paraMap.put("filepath", filepath); // 삭제해야할 첨부파일이 저장된 경로
			paraMap.put("filename", filename); // 삭제해야할 첨부파일명 
		}
		
		paraMap.put("notice_no", notice_no); // 삭제할 글번호
		int n = service.notice_del(paraMap); // 파일첨부, 사진이미지가 들었는 경우의 글 삭제하기
		
		if (n == 1) {
	        response.put("status", "success");
	        response.put("message", "공지사항이 삭제 되었습니다.");
	    } else {
	        response.put("status", "error");
	        response.put("message", "공지사항이 삭제가 실패되었습니다.");
	    }

	    return ResponseEntity.ok(response);
	}
	
	
	
		
	

}