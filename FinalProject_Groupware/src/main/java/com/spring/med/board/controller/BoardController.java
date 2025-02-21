package com.spring.med.board.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.domain.CommentVO;
import com.spring.med.board.service.BoardService;
import com.spring.med.common.FileManager;
import com.spring.med.common.MyUtil;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// ==== #22. 컨트롤러 선언 ====
@Controller
@RequestMapping(value="/board/*")
public class BoardController {

	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private BoardService service;
	
	// === #150. 파일업로드 및 파일다운로드를 해주는 FileManager 클래스 의존객체 주입하기(DI : Dependency Injection) === //
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private FileManager fileManager;
	
	
	// === #26. 게시판 글쓰기 폼페이지 요청 === //
	@GetMapping("add")
	public ModelAndView requiredLogin_add(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {  // <== Before Advice 를 사용하기         
 		
		// === #134. 답변글쓰기가 추가된 경우 시작 === //
		// view.jsp에서 보내어준 것을 알아본다(#130), add.jsp(원글쓰기인 경우, 답변글쓰기인 경우)
		String board_subject = request.getParameter("board_subject");
		
		if(board_subject == null) {  // 원글쓰기에서 넘어온 게 없다면
			board_subject="";  // 원글쓰기
		}
		else {
			board_subject = "[답변] " + request.getParameter("board_subject");
		}
		
		String fk_board_no = request.getParameter("fk_board_no"); 	// view.jsp에서 fk_board_no를 받아온다

		if(fk_board_no == null) {
			fk_board_no = "";
		}
		
		String board_groupno = request.getParameter("board_groupno"); 	// view.jsp에서 groupno를 받아온다
		String board_depthno = request.getParameter("board_depthno");

		/*
	       view.jsp 에서 "답변글쓰기" 를 할때 글제목에 [ 또는 ] 이 들어간 경우 아래와 같은 오류가 발생한다.
	             
	       HTTP 상태 400 – 잘못된 요청
	           메시지 : 요청 타겟에서 유효하지 않은 문자가 발견되었습니다. 
	                  유효한 문자들은 RFC 7230과 RFC 3986에 정의되어 있습니다.
	       
	       HTTP Status 400 – Bad Request
	           Message : Invalid character found in the request target    
	                     The valid characters are defined in RFC 7230 and RFC 3986
	                         
	       원인 : get 방식으로 보내는 데이터 값에 [ ] 와 같은 문자가 들어갈 경우임.    
	       
	       해결책은 
	       1. 외장톰캣을 사용할 경우에는 톰캣의 C:\SW\apache-tomcat-10.1.31\conf\server.xml 에서 
	       <Connector port="9090" protocol="HTTP/1.1"
	           connectionTimeout="20000"
	           redirectPort="8443"
	           maxParameterCount="1000" /> 
	           
	           에 가서
	           
	        <Connector port="9090" protocol="HTTP/1.1"
	           connectionTimeout="20000"
	           redirectPort="8443"
	           maxParameterCount="1000" 
	           relaxedQueryChars="[]()^|&quot;" />  
	                 
	           와 같이 relaxedQueryChars="[]()^|&quot;" 을 추가해주면 된다.
	           
	           
	        2. 내장톰캣을 사용할 경우에는  (EmbeddedTomcatConfig > 클래스파일을 만들어준다)
	      package com.spring.app.config;
	      
	      import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
	      import org.springframework.boot.web.server.WebServerFactoryCustomizer;
	      import org.springframework.context.annotation.Configuration;
	      
	      @Configuration
	      public class EmbeddedTomcatConfig implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {
	      
	         @Override
	          public void customize(TomcatServletWebServerFactory factory) {
	              factory.addConnectorCustomizers(connector -> connector.setProperty("relaxedQueryChars", "<>[\\]^`{|}"));
	          }
	      
	      }
	    
	   */
		 

		// 밑의 뷰단페이지에 보낸다.
		mav.addObject("board_subject", board_subject);
		mav.addObject("fk_board_no", fk_board_no);
		mav.addObject("board_groupno", board_groupno);
		mav.addObject("board_depthno", board_depthno);
		
		// === 답변글쓰기가 추가된 경우 끝 === //
		
		// add에 넘겨준다 add.jsp
		mav.setViewName("content/community/board/add");
		//  /WEB-INF/views/mycontent1/board/add.jsp 페이지를 만들어야 한다.
		
		return mav;
	}
	
	
	// === #28. 게시판 글쓰기 완료 요청 === //
	@PostMapping("add")
	// 원글에 대한 답글 게시물을 작성하면 add.jsp 글쓰기 버튼 코드 쪽 const frm = document.addFrm; 보내면 밑의 코드인 service.add(boardvo)로 보내진다. 
	// add service 임플 > int n = dao.add(boardvo); > dao 임플 > board.xml #31
	
//	public ModelAndView add(ModelAndView mav, BoardVO boardvo) {   // <== After Advice 를 사용하기 전 
//	public ModelAndView pointPlus_add(Map<String, String> paraMap, ModelAndView mav, BoardVO boardvo) {   // <== After Advice 를 사용하기, 파일첨부가 없을 경우
	public ModelAndView pointPlus_add(Map<String, String> paraMap, ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) {   
	// <== #146. After Advice 를 사용하기, 파일첨부가 있을 경우

		
	 // === 사용자가 쓴 글에 파일이 첨부되어 있는 것인지, 아니면 파일첨부가 안된것인지 구분을 지어주어야 한다. === 
	 // === #148. !!! 첨부파일이 있는 경우 작업 시작 !!! === //
		MultipartFile attach = boardvo.getAttach();
		
		if(attach != null) {
			// attach(실제 첨부파일)가 비어있지 않으면(즉, 첨부파일이 있는 경우라면)
			
			/*
			  	1. 사용자가 보낸 첨부파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다.(어디에 올리겠다)
			  	>>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기
			  		우리는 WAS 의 /myspring/src/main/webapp/resources/files 라는 폴더를 생성해서 여기로 업로드 해주도록 할 것이다.
			 */
			
			// WAS 의 webapp의 절대경로를 알아와야 한다.
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");  // 최상위 root
			
			// System.out.println("~~~ 확인용 webapp의 절대경로 ==> " + root);
			// ~~~ 확인용 webapp의 절대경로 ==> C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\
			
			String path = root+"resources"+File.separator+"files";
			/* 	File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
            	운영체제가 Windows 이라면 File.separator 는  "\" 이고,
            	운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
            		(path에 올리겠다)
			*/
			
			// path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
			// System.out.println("~~~ 확인용 path ==> " + path);
			// ~~~ 확인용 path ==> C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\resources\files
			
			/*
			  	2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
			*/
			String newFileName = "";
			// newFileName : WAS(톰캣)의 디스크에 저장될 파일명
			
			byte[] bytes = null;
			// 첨부파일의 내용물을 담는 것
			
			long board_fileSize = 0;       // 컬럼임
			// 첨부파일의 크기
			
			
			try {
				 bytes = attach.getBytes();
				 // 실제 첨부파일의 내용물을 읽어오는 것
				 
				 String originalFilename = attach.getOriginalFilename();  
				 // attach.getOriginalFilename() 이 첨부파일명의 파일명(예: 강아지.png) 이다. (첨부되어진 파일의 이름을 읽어온다)
				 
				 // System.out.println("~~~ 확인용 originalFilename => " + originalFilename);
				 
				 // 첨부되어진 파일을 업로드 하는 것이다. (common 패키지에서 FileManager 클래스 생성-#149)
				 newFileName = fileManager.doFileUpload(bytes, originalFilename, path);    // fileManager(의존객체)
				 					   			     // 내용물, 원래이름(확장자를 따오기 위해서 필요), 올릴 장소) 
				 
				 // === #151. BoardVO boardvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기 === //
				 // (첨부파일이 있는 경우하는 중임) form태그에서 넘어온 boardvo 
				 boardvo.setBoard_fileName(newFileName);
				 // WAS(톰캣)에 저장된 파일명(2025020709291535243254235235234.png)
				 
				 // DB에 넣어줘야 원래 이름을 알 수 있다
				 boardvo.setBoard_orgFilename(originalFilename);
				 // 게시판 페이지에서 첨부된 파일(강아지.pdf)을 보여줄 때 사용.
		         // 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
				 
					/*
					 * fileSize = attach.getSize(); // 첨부파일의 크기(단위는 byte임)
					 * boardvo.setFileName(String.valueOf(fileSize));
					 */

				board_fileSize = attach.getSize(); // 첨부파일의 크기(단위는 byte임)
				boardvo.setBoard_fileSize(String.valueOf(board_fileSize));
				 
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		} // end of if(attach != null) -----------------------------------
		// === !!! 첨부파일이 있는 경우 작업 끝 !!! === //
		
		// === #152. 파일첨부가 있는 글쓰기 또는 파일첨부가 없는 글쓰기로 나뉘어서 service 호출하기 시작 === //
		// 먼저 위의 int n = service.add(boardvo); 부분을 주석처리 하고서 아래와 같이 한다.
		
		int n = 0;
		
		if(attach.isEmpty()) { 
			// 파일첨부가 없는 경우라면
			n = service.add(boardvo);  // <== 파일첨부가 없는 글쓰기 
		}
		else {
			// 파일첨부가 있는 경우라면
			n = service.add_withFile(boardvo);  // <== 파일첨부가 있는 글쓰기
		}

		// === 파일첨부가 있는 글쓰기 또는 파일첨부가 없는 글쓰기로 나뉘어서 service 호출하기 끝 === //
		
		
		if(n==1) {
			mav.setViewName("redirect:/board/list"); 
			//   /board/list 페이지로 redirect(페이지이동)해라는 말이다.
			
		}
		else {
			mav.setViewName("board/error/add_error");
		    //  /WEB-INF/views/mycontent1/board/error/add_error.jsp 파일을 생성한다. 
		}

		return mav;
	}
	
		
	// === #32. 글목록 보기 페이지 요청 === //
	@GetMapping("list")
//	public ModelAndView list(ModelAndView mav, HttpServletRequest request) {
	public ModelAndView list(ModelAndView mav, HttpServletRequest request,              
							 @RequestParam(defaultValue = "") String searchType, 		 // (defaultValue = "")는 if(searchType == null) { searchType = ""; } 와 같은 뜻
							 @RequestParam(defaultValue = "") String searchWord,
							 @RequestParam(defaultValue = "1") String currentShowPageNo  // 기본페이지 "1"
							 ) {   // <== 페이징 처리  

		List<BoardVO> boardList = null;
		
		////////////////////////////////////////////////////////

		searchWord = searchWord.trim();

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		// 먼저, 총 게시물 건수(totalCount)를 구해와야 한다.    (전체 페이지, 검색이 없을 때, 검색이 있을 때)
		// 총 게시물 건수(totalCount)는 검색조건이 있을 때와 검색조건이 없을 때로 나뉘어진다.
		int totalCount = 0;  			// 총게시물 건수
		int sizePerPage = 10; 		 	// 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;			    // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		
		int n_currentShowPageNo = 0;    // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정한다.
		
		// 총 게시물 건수 (totalCount)
		totalCount = service.getTotalCount(paraMap);  // Map에 searchType과 searchWord를 넣어놨음
		// System.out.println("~~~ 확인용 totalCount : " + totalCount);
		/*
		    ~~~ 확인용 totalCount : 203
		    ~~~ 확인용 totalCount : 201
		    ~~~ 확인용 totalCount : 1
		    ~~~ 확인용 totalCount : 0
		*/
		
		// 만약에 총 게시물 건수(totalCount)가 124 개 이라면 총 페이지수(totalPage)는 13 페이지가 되어야 한다.
	    // 만약에 총 게시물 건수(totalCount)가 120 개 이라면 총 페이지수(totalPage)는 12 페이지가 되어야 한다.
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);
		// (double)124/10 ==> 12.4 ==> Math.ceil(12.4) ==> 13.0 ==> 13  (소수부가 존재할 때만 올라감)
		// (double)120/10 ==> 12.0 ==> Math.ceil(12.0) ==> 12.0 ==> 12
		
		try {
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
	            // get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				n_currentShowPageNo = 1;
			}
			
		} catch(NumberFormatException e) {
			// get 방식이므로 currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하거나 
			// int 범위를 초과한 경우
			n_currentShowPageNo = 1;
		}
		
		
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
	    /*
           currentShowPageNo      startRno     endRno
          --------------------------------------------
               1 page        ===>    1           10
               2 page        ===>    11          20
               3 page        ===>    21          30
               4 page        ===>    31          40
               ......                ...         ...
	    */
		
		int startRno = ((n_currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1;  // 끝 행번호
		
		paraMap.put("startRno", String.valueOf(startRno));   // Oracle 11g 와 호환되는 것으로 위함
		paraMap.put("endRno", String.valueOf(endRno));		 // Oracle 11g 와 호환되는 것으로 위함 
		// 위, 아래 둘 중 하나 사용
		paraMap.put("currentShowPageNo", currentShowPageNo);	// Oracle 12c 이상 사용하기 위함
		
		boardList = service.boardListSearch_withPaging(paraMap);
		// 글목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.)

		mav.addObject("boardList", boardList);
		// System.out.println("~~~확인용 boardList : " + boardList);
		

		// 검색시 검색조건 및 검색어 유지시키기 
		if("board_subject".equals(searchType) || 
		   "board_content".equals(searchType) ||
		   "board_subject_board_content".equals(searchType) ||
		   "board_name".equals(searchType)) {
			
			// === #107. 이전글제목, 다음글제목 보여줄 때 검색이 있는지 여부를 넘겨주기 시작 === //
	 		paraMap.put("searchType",searchType);
	 		paraMap.put("searchWord",searchWord);
		 	// === #107. 이전글제목, 다음글제목 보여줄 때 검색이 있는지 여부를 넘겨주기 끝 === //
			
			mav.addObject("paraMap", paraMap);	
		}
		
		
		// === #102. 페이지바 만들기 === //
		int blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		
		int loop = 1;
		/*
        	loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		*/
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
	    String url = "list";
	    
	    // === [맨처음][이전] 만들기 === //
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'>[맨처음]</a></li>";
	    
	    if(pageNo != 1) {  // 내가 보고자 하는 넘버가 1페이지가 아닐 때(맨처음 페이지라면 [이전]이 없음)
	    	pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
	    }
	   
	    while( !(loop > blockSize || pageNo > totalPage) ) {   // 10 보다 크거나 totalPage 보다 크면 안 된다
	    	
	    	
	    	if(pageNo == Integer.parseInt(currentShowPageNo)) {  // 내가 현재 보고자 하는 페이지(현재페이지는 a태그 뺌)
	    		pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border: solid 1px gray; color:red; padding:2px 4px'>"+pageNo+"</li>";
	    	}
	    	else { 
	    		pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
	    	}
	    		
	    	loop++;
	    	pageNo++;
	    }  // end of while ------------------------------ (10번을 반복하면 빠져나옴)
	    
	    
	    // === [다음][마지막] 만들기 === //
	    if(pageNo <= totalPage) {  // 맨 마지막 페이지라면 [다음]이 없음
	    	pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
	    }
 
	    pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
	      
	    pageBar += "</ul>"; 
	    
	    mav.addObject("pageBar", pageBar); // modelandview(뷰단페이지에 페이지바를 나타냄)
	    
	    
	    ////////////////////////////////////////////////////////////////////////
	    
	    mav.addObject("totalCount", totalCount);			   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.(데이터개수)
	    mav.addObject("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.(페이지번호)
	    mav.addObject("sizePerPage", sizePerPage);  		   // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.(1페이지당보여줄개수)
	    
	    // System.out.println("총 게시물 수: " + totalCount);
	    ////////////////////////////////////////////////////////////////////////
	    
	    // === #104. 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
	    //           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
	    //           현재 페이지 주소를 뷰단으로 넘겨준다.
	    String currentURL =  MyUtil.getCurrentURL(request);   // currentURL : 현재페이지
	    // System.out.println("~~~ 확인용 currentURL : " + currentURL);
	    
	    mav.addObject("goBackURL", currentURL); // 돌아갈 페이지

		mav.setViewName("content/community/board/list");
		//  /WEB-INF/views/mycontent1/board/list.jsp 파일을 생성한다.
		
		return mav;
	}
	
		
	// === #36. 글1개를 보여주는 페이지 요청 === //
//	@GetMapping("view")
//	@PostMapping("view")
	@RequestMapping("view")   // === #106. 특정글을 조회한 후 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 만들기 위함. === //
//  @RequestMapping : get,post 둘 다 사용할 때 사용
	public ModelAndView view(ModelAndView mav, 
			                 HttpServletRequest request) {
		
		
		String board_no ="";
		String goBackURL ="";
		String searchType ="";
		String searchWord ="";
		
		// === #115. view_2 에서 redirect 해온 것을 처리해주기 시작 === //
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
	    // redirect 되어서 넘어온 데이터가 있는지 꺼내어 와본다.
		
		if(inputFlashMap != null) { // null이 아니고 redirect 되어서 넘어온 데이터가 있다라면
			
			@SuppressWarnings("unchecked")  // 경고 표시를 하지 말라는 뜻이다.
			Map<String, String>	redirect_map = (Map<String, String>) inputFlashMap.get("redirect_map"); // return 타입이 object가 나오는데 우리는 Map이어야 한다.
			// "redirect_map" 값은  /view_2 에서  redirectAttr.addFlashAttribute("키", 밸류값); 을 할때 준 "키" 이다. 
	        // "키" 값을 주어서 redirect 되어서 넘어온 데이터를 꺼내어 온다. 
	        // "키" 값을 주어서 redirect 되어서 넘어온 데이터의 값은 Map<String, String> 이므로 Map<String, String> 으로 casting 해준다.
			
			// System.out.println("~~~ 확인용 seq : " + redirect_map.get("seq")) ;
			
			board_no = redirect_map.get("board_no");  // 내가 읽어야 할 이전글번호, 다음글번호
			searchType = redirect_map.get("searchType");
			
			try {
				searchWord = URLDecoder.decode(redirect_map.get("searchWord"), "UTF-8");  // redirect_map 안에 searchWord가 있음
							// db에 보낼 거임, 웹브라우저 URL에서 넘길 땐 %EA%B9%80%EB%AF%BC%EC%A7%80지만 db에서 넘겨줄 땐 김민지이어야 함(원복 decode)
							// 한글데이터가 포함되어 있으면 반드시 한글로 복구해주어야 한다.
				goBackURL = URLDecoder.decode(redirect_map.get("goBackURL"), "UTF-8");  // 돌아갈 페이지
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}  
			
			System.out.println("~~~ 확인용 board_no : " + board_no) ;
			System.out.println("~~~ 확인용 searchType : " + searchType) ;
			System.out.println("~~~ 확인용 searchWord : " + searchWord) ;
			System.out.println("~~~ 확인용 goBackURL : " + goBackURL) ;
			
			// === #115. view_2 에서 redirect 해온 것을 처리해주기 끝 === //
			
		}
		
		else {  // redirect 되어서 넘어온 데이터가 아닌 경우
			
			board_no = request.getParameter("board_no");        
	        goBackURL = request.getParameter("goBackURL");        
	        searchType = request.getParameter("searchType");        
	        searchWord = request.getParameter("searchWord");
	        
	        if(searchType == null) {
	           searchType = "";           
	        }
	        
	        if(searchWord == null) {
	           searchWord = "";           
	        }
			
		}  // end of if~else -------------------------------------
		
		// 공통 : 로그인 유무
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String login_member_userid = null;
		if(loginuser != null) {
			login_member_userid = loginuser.getMember_userid();
			// login_userid 는 로그인 되어진 사용자의 userid 이다. 
		}
		
		try {
			Integer.parseInt(board_no);
			
			// System.out.println("~~~ 확인용 goBackURL : " + goBackURL);
			// GET 방식일 때 : ~~~ 확인용 goBackURL : 
			// POST 방식일 때 : ~~~ 확인용 goBackURL : /board/list?searchType=&searchWord=&currentShowPageNo=7
			mav.addObject("goBackURL", goBackURL);
			
		
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("board_no", board_no);
			paraMap.put("login_member_userid", login_member_userid);
			
			
			// === #108. 이전글제목, 다음글제목 보여줄 때 검색이 있는지 여부를 넘겨주기 시작 === //
	 		paraMap.put("searchType",searchType);
	 		paraMap.put("searchWord",searchWord);
		 	// === #108. 이전글제목, 다음글제목 보여줄 때 검색이 있는지 여부를 넘겨주기 끝 === //
	 		
	 		System.out.println("board_no" + board_no);
	 		System.out.println("login_member_userid" + login_member_userid);
	 		System.out.println("searchType" + searchType);
	 		System.out.println("searchWord" + searchWord);
	 		
			
			// === #43. !!! 중요 !!! 
	        //     글1개를 보여주는 페이지 요청은 select 와 함께 
			//     DML문(지금은 글조회수 증가인 update문)이 포함되어져 있다.
			//     이럴경우 웹브라우저에서 페이지 새로고침(F5)을 했을때 DML문이 실행되어
			//     매번 글조회수 증가가 발생한다.
			//     그래서 우리는 웹브라우저에서 페이지 새로고침(F5)을 했을때는
			//     단순히 select만 해주고 DML문(지금은 글조회수 증가인 update문)은 
			//     실행하지 않도록 해주어야 한다. !!! === //
			
			// 위의 글목록보기 #44. 에서 session.setAttribute("readCountPermission", "yes"); 해두었다.
			BoardVO boardvo = null;
			
			if("yes".equals( (String)session.getAttribute("readCountPermission") )) {
			// 글목록보기인 /list 페이지를 클릭한 다음에 특정글을 조회해온 경우이다.
			// view_2를 거쳐서 온 것은 yes가 있음 
				System.out.println("~~~~~~ if(\"yes\".equals( (String)session.getAttribute(\"readCountPermission\") )) 확인");
				boardvo = service.getView(paraMap);
				// 글 조회수 증가와 함께 글 1개를 조회를 해오는 것
			//	System.out.println("~~ 확인용 글내용 : " + boardvo.getContent());
				
				session.removeAttribute("readCountPermission");
				// 중요함!! session 에 저장된 readCountPermission 을 삭제한다. 
			}
			
			else {
				// 글목록에서 특정 글제목을 클릭하여 본 상태에서
			    // 웹브라우저에서 새로고침(F5)을 클릭한 경우이다.
			//	System.out.println("글목록에서 특정 글제목을 클릭하여 본 상태에서 웹브라우저에서 새로고침(F5)을 클릭한 경우"); 
				
				boardvo = service.getView_no_increase_readCount(paraMap);
				// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
				
				if(boardvo == null) {
					System.out.println("~~~~~~ if(boardvo == null) 확인");
					mav.setViewName("redirect:/board/list");
					return mav;
				}
			}
						
			mav.addObject("boardvo", boardvo);
			
			// === #112. 이전글제목 보기, 다음글제목 보기 시 POST 방식으로 넘기기 위한 것 === //
			mav.addObject("paraMap", paraMap);
			
			System.out.println("~~~~~~ NumberFormatException 확인" + boardvo);
			mav.setViewName("content/community/board/view");
			//  /WEB-INF/views/mycontent1/board/view.jsp 파일을 생성한다. 
			
		} catch (NumberFormatException e) {
			System.out.println("~~~~~~ NumberFormatException 확인");
			mav.setViewName("redirect:community/board/list");
		}
		
		return mav;
	}
	
	
	
/* === #114. 이전글제목보기, 다음글제목보기를 할 때 글 조회수 증가를 하기 위한 것이다. === */
	@PostMapping("view_2")
	public ModelAndView view_2(ModelAndView mav, 
					           @RequestParam(defaultValue = "") String board_no,
					           @RequestParam(defaultValue = "") String goBackURL,
					           @RequestParam(defaultValue = "") String searchType,
					           @RequestParam(defaultValue = "") String searchWord,
					           HttpServletRequest request,
					           RedirectAttributes redirectArr) {  // GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 사용
		
		
		// 한글이 들어올 것들만
		try {
			searchWord = URLEncoder.encode(searchWord, "UTF-8");
			goBackURL = URLEncoder.encode(goBackURL, "UTF-8");
			
			// System.out.println("~~~ view_2 의 searchWord : " + searchWord);
			// ~~~ view_2 의 searchWord : 김민지 => 이렇게 나오면 안됨
			// ~~~ view_2 의 searchWord : %EA%B9%80%EB%AF%BC%EC%A7%80 => 이렇게 나와야 함
			
			// System.out.println("~~~ view_2 의 searchWord : " + URLDecoder.decode(searchWord, "UTF-8"));
			// URL인코딩 되어진 한글을 원래 한글모양으로 되돌려주는 것임.
			// ~~~ view_2 의 searchWord : 김민지
			
			
		} catch (UnsupportedEncodingException e) {
			
			e.printStackTrace();
		}
		
		
		
		
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		// session에 담아온다.
		
		// ==== redirect(GET방식임) 시 데이터를 넘길때 GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 를 사용하면 된다. 시작 ==== //
		Map<String, String> redirect_map = new HashMap<>();
		redirect_map.put("board_no", board_no);
		redirect_map.put("goBackURL", goBackURL);
		redirect_map.put("searchType", searchType);
		redirect_map.put("searchWord", searchWord);
		
		redirectArr.addFlashAttribute("redirect_map", redirect_map); // addFlashAttribute : 어떠한 속성값을 추가
		// redirectAttr.addFlashAttribute("키", 밸류값); 으로 사용하는데 오로지 1개의 데이터만 담을 수 있으므로 여러개의 데이터를 담으려면 Map 을 사용해야 한다.
	
		mav.setViewName("redirect:/board/view");  // redirect라서 주소만 바꿔줌
		// 실제로 redirect:/board/view 은 POST 방식이 아닌 GET 방식이다.
		// view_2에서도 redirect:/board/view에 데이터를 넘겨줘야 한다.
		// redirect 할 때 redirect_map의 정보들을 가져가라
		
		// ==== redirect(GET방식임) 시 데이터를 넘길때 GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 를 사용하면 된다. 끝 ==== //
		
		return mav;
	}
	
	
	
	
	// === #46. 글을 수정하는 페이지 요청 === //
	@GetMapping("edit/{board_no}")
	public ModelAndView requiredLogin_edit(HttpServletRequest request
			                             , HttpServletResponse response
			                             , ModelAndView mav
			                             , @PathVariable String board_no) {
		
		try {
			Long.parseLong(board_no);
			
			// 글 수정해야 할 글 1개 내용가져오기
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("board_no", board_no);
			
			BoardVO boardvo = service.getView_no_increase_readCount(paraMap);
			// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
			
			if(boardvo == null) {
				mav.setViewName("redirect:/board/list");
			}
			
			else {
				HttpSession session = request.getSession();
				ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
				
				if( loginuser.getMember_userid().equals(boardvo.getFk_member_userid()) ) {
					// 자신의 글을 수정할 경우
					// 가져온 1개글을 글수정할 폼이 있는 view 단으로 보내준다.
					
					mav.addObject("boardvo", boardvo);
					mav.setViewName("content/board/edit");
				}
				else {
					// 자신의 글이 아닌 다른 사람의 글을 수정할 경우
					
					mav.addObject("message", "다른 사용자의 글은 수정이 불가합니다");
					mav.addObject("loc", "javascript:history.back()");
					
					mav.setViewName("msg");
				}
			}
			
			return mav;
			
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/board/list");
			return mav;
		}
		
	}
	
	
	// === #47. 글을 수정하는 페이지 완료하기 === //
	@PostMapping("edit")
	public ModelAndView edit(ModelAndView mav
                           , BoardVO boardvo
                           , HttpServletRequest request) {
		
		int n = service.edit(boardvo);
		
		if(n==1) {
			mav.addObject("message", "글 수정 성공!!");
			mav.addObject("loc", request.getContextPath()+"/board/view?board_no="+boardvo.getBoard_no());
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	// === #51. 글을 삭제하는 페이지 요청 === //
	@GetMapping("del/{board_no}")
	public ModelAndView requiredLogin_del(HttpServletRequest request
			                             , HttpServletResponse response
			                             , ModelAndView mav
			                             , @PathVariable String board_no) {
		
		try {
			Long.parseLong(board_no);
			
			// 삭제해야 할 글 1개 내용가져오기
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("board_no", board_no);
			
			BoardVO boardvo = service.getView_no_increase_readCount(paraMap);
			// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
			
			if(boardvo == null) {
				mav.setViewName("redirect:/board/list");
			}
			
			else {
				HttpSession session = request.getSession();
				ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
				
				if( loginuser.getMember_userid().equals(boardvo.getFk_member_userid()) ) {
					// 자신의 글을 삭제할 경우
					// 가져온 1개글을 글삭제할 폼이 있는 view 단으로 보내준다.
					
					mav.addObject("boardvo", boardvo);
					mav.setViewName("content/board/del");
				}
				else {
					// 자신의 글이 아닌 다른 사람의 글을 삭제할 경우
					
					mav.addObject("message", "다른 사용자의 글은 삭제가 불가합니다");
					mav.addObject("loc", "javascript:history.back()");
					
					mav.setViewName("msg");
				}
			}
			
			return mav;
			
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/board/list");
			return mav;
		}
		
	}	
	
	
	// === #52. 글을 삭제하는 페이지 완료하기 === //
	@PostMapping("del")
	public ModelAndView del(ModelAndView mav,
			                @RequestParam String board_no,
			                HttpServletRequest request) {
		
		int n = service.del(board_no);
		
		if(n==1) {
			mav.addObject("message", "글 삭제 성공!!");
		    mav.addObject("loc", request.getContextPath()+"/board/list");
		    mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	// === #59. 댓글쓰기(Ajax 로 처리) === //
	@PostMapping("addComment")
	@ResponseBody
	public Map<String, Object> addComment(CommentVO commentvo) {  
		// 댓글쓰기에 첨부파일이 없는 경우
		
		int n = 0;
		
		try {
		     n = service.addComment(commentvo);
		    // 댓글쓰기(insert) 및 원게시물(tbl_board 테이블)에 댓글의 개수 증가(update 1씩 증가)하기 
		    // 이어서 회원의 포인트를 50점을 증가하도록 한다. (tbl_member 테이블에 point 컬럼의 값을 50 증가하도록 update 한다.)
		} catch(Throwable e) {
			e.printStackTrace();
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("comment_name", commentvo.getComment_name());
		map.put("n", n);
		
		return map;	
		// {"name":"서영학","n":1}
		// 또는
		// {"name":"서영학","n":0}
	}
	
	
	// === #63. 원게시물에 딸린 댓글들을 조회해오기 (Ajax 로 처리) === //
	@GetMapping("readComment")
	@ResponseBody
	public List<CommentVO> readComment(@RequestParam String comment_parentSeq){
		
		List<CommentVO> commentList = service.getCommentList(comment_parentSeq);
		
		return commentList;
		/*
		  [{"seq":"3","fk_userid":"seoyh","name":"서영학","content":"세번째 댓글쓰기 입니다","regDate":"2025-01-24 10:50:40","parentSeq":null,"status":null}
		  ,{"seq":"2","fk_userid":"seoyh","name":"서영학","content":"두번째 댓글쓰기 입니다","regDate":"2025-01-24 10:48:50","parentSeq":null,"status":null}
		  ,{"seq":"1","fk_userid":"seoyh","name":"서영학","content":"첫번째 댓글쓰기 입니다","regDate":"2025-01-24 10:46:23","parentSeq":null,"status":null}] 
		  
		  또는
		  
		  [] 
		*/
	}
	
	
	// === #68. 댓글 수정(Ajax 로 처리) === //
	@PutMapping("updateComment")
	@ResponseBody
	public Map<String, Integer> updateComment(@RequestParam Map<String, String> paraMap){
		
		int n = service.updateComment(paraMap);
		
		Map<String, Integer> map = new HashMap<>();
		map.put("n", n);
		
		return map;  // {"n":1}
	}
	
	
	// === #72. 댓글 삭제(Ajax 로 처리) === //
	@DeleteMapping("deleteComment")
	@ResponseBody
    public Map<String, Integer> deleteComment(@RequestParam Map<String, String> paraMap){
		
		int n=0;
				
		try {
		  n=service.deleteComment(paraMap);
		} catch(Throwable e) {
			e.printStackTrace();
		}
		
		Map<String, Integer> map = new HashMap<>();
		map.put("n", n);
		
		return map;  // {"n":1}
	}
	
	
	// === #89. 검색어 입력시 자동글 완성하기 3 === //
	@GetMapping("wordSearchShow")
	@ResponseBody
	public List<Map<String, String>> wordSearchShow(@RequestParam Map<String, String> paraMap) {
		
		List<String> wordList = service.wordSearchShow(paraMap); 
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(wordList != null) {
			for(String word : wordList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				mapList.add(map);
			}// end of for-------------
		}
		
		return mapList;
	  /*
		 [{"word":"java가 쉽나요?"}
		 ,{"word":"JAVA공부를 하려고 해요. 도와주세요~~"}
		 ,{"word":"프로그래밍은 Java 를 해야 하나요?"}
		 ,{"word":"javascript 는 쉬운가요?"}
		 ,{"word":"프론트 엔드를 하려면 JavaScript 를 해야 하나요?"}
		 ,{"word":"질문있어요 jQuery 와 javaScript 는 관련이 있나요?"}] 
		 
		 또는 []
	  */
	}
	
	
	

	   // ==== #118. 원게시물에 딸린 댓글들을 조회해오기 (Ajax로 처리) ==== //
	   @GetMapping("commentList")
	   @ResponseBody   // 리턴 타입이 String 이라면 문자열 그대로 출력히자민, 객체 형식이라면 json 형식으로 바꾸어준다.
	   public String commentList(@RequestParam(defaultValue = "") String comment_parentSeq,   // @RequestParam(name="parentSeq") String parentSeq
	                              @RequestParam(defaultValue = "1") String currentShowPageNo) {
	      
	      int sizePerPage = 3;  // 한 페이지당 3개의 댓글을 보여줄 것이다. !!!!!!!!!!!!!!!!!!!![중요]여기에서 보여지는 댓글 수 설정하기!!!!!!!!!!
	      
	      // **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
	      /*
	           currentShowPageNo      startRno     endRno
	           --------------------------------------------
	               1 page        ==>      1           3
	               2 page        ==>      4           6
	               3 page        ==>      7           9
	               4 page        ==>     10          12
	               ...               ...         ...
	        */
	      
	      int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1;  // 시작 행번호 
	      int endRno = startRno + sizePerPage - 1;  // 끝 행번호
	      
	      Map<String, String> paraMap = new HashMap<>();
	      
	      paraMap.put("comment_parentSeq", comment_parentSeq);
	      paraMap.put("startRno", String.valueOf(startRno));   //   "Oracle 11g 와 호환" 되는 것으로 사용하기 위함
	      paraMap.put("endRno", String.valueOf(endRno));      //   "Oracle 11g 와 호환" 되는 것으로 사용하기 위함

	      paraMap.put("currentShowPageNo", currentShowPageNo);   //   "Oracle 12c 이상과 호환" 되는 것으로 사용하기 위함
	      paraMap.put("sizePerPage", String.valueOf(sizePerPage));            //   "Oracle 12c 이상과 호환" 되는 것으로 사용하기 위함
	      
	      List<CommentVO> commentList = service.getCommentList_Paging(paraMap);
	      int totalCount = service.getCommentTotalCount(comment_parentSeq);   // 특정한 글의 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
	      
	      
	      /*
	         @ResponseBody   // 리턴 타입이 String 이라면 문자열 그대로 출력히자민, 객체 형식이라면 json 형식으로 바꾸어준다.
	                     // 이러한 특징때문에 원하는대로 개발하기 위해 아래와 같이 JSONArray 를 사용했다.
	      */
	      JSONArray jsonArr = new JSONArray();   // []
	      
	      if(commentList != null) {
	         for(CommentVO cmtvo : commentList) {
	            JSONObject jsonObj = new JSONObject();   // {}
	            jsonObj.put("comment_no", cmtvo.getComment_no());            // {"seq":"3"}
	            jsonObj.put("fk_member_userid", cmtvo.getFk_member_userid());   // {"seq":"3","fk_userid":"kimhb"}
	            jsonObj.put("comment_name", cmtvo.getComment_name());         // {"seq":"3","fk_userid":"kimhb","name":"김홍비"}
	            jsonObj.put("comment_content", cmtvo.getComment_content());      // {"seq":"3","fk_userid":"kimhb","name":"김홍비","content":"세번째 댓글쓰기 입니다."}
	            jsonObj.put("comment_regDate", cmtvo.getComment_regDate());      // {"seq":"3","fk_userid":"kimhb","name":"김홍비","content":"세번째 댓글쓰기 입니다.","regDate":"2025-01-24 10:57:28"}
	            
	            jsonObj.put("totalCount", totalCount);         // {"seq":"3","fk_userid":"kimhb","name":"김홍비","content":"세번째 댓글쓰기 입니다.","regDate":"2025-01-24 10:57:28","totalCount":23}
	            
	            jsonObj.put("sizePerPage", sizePerPage);      // {"seq":"3","fk_userid":"kimhb","name":"김홍비","content":"세번째 댓글쓰기 입니다.","regDate":"2025-01-24 10:57:28","totalCount":23,"sizePerPage":3}
	            
	            jsonArr.put(jsonObj);
	         }// end of for-------------------------------
	         
	      }// end of if(commentList != null)-----------------------
	      
	      //System.out.println(jsonArr.toString());
	      /*
	         [{"seq":"50","fk_userid":"kimhb","name":"김홍비","content":"댓글연습37","regDate":"2025-02-05 10:42:56","parentSeq":null,"status":null}
	         ,{"seq":"49","fk_userid":"kimhb","name":"김홍비","content":"댓글연습36","regDate":"2025-02-05 10:42:50","parentSeq":null,"status":null}
	         ,{"seq":"48","fk_userid":"kimhb","name":"김홍비","content":"댓글연습35","regDate":"2025-02-05 10:41:34","parentSeq":null,"status":null}]
	         
	         // 또는
	         []
	      */

	      return jsonArr.toString();
	      
	   }
	   
}