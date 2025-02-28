package com.spring.med.board.controller;

import java.util.ArrayList;
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
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.service.BookmarkService;
import com.spring.med.common.MyUtil;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/community/*")
public class BookmarkController {

    @Autowired
    private BookmarkService service;

    // 즐겨찾기 목록 조회
    @GetMapping("bookmark")
    public ModelAndView myboard(ModelAndView mav, HttpServletRequest request, 
									    		 @RequestParam(defaultValue = "") String searchType, 		 // (defaultValue = "")는 if(searchType == null) { searchType = ""; } 와 같은 뜻
												 @RequestParam(defaultValue = "") String searchWord,
												 @RequestParam(defaultValue = "1") String currentShowPageNo  // 기본페이지 "1"
												 ) {   // <== 페이징 처리 
    	
        HttpSession session = request.getSession();
        ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

        if (loginuser == null) {
            mav.setViewName("redirect:/login"); // 로그인 안 했으면 로그인 페이지로 이동
            return mav;
        }

        String login_member_userid = loginuser.getMember_userid();

        List<BoardVO> BookmarkList = null;
        
        ///////////////////////////////////////////////////////////
        
        searchWord = searchWord.trim();
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("fk_member_userid", login_member_userid);
        paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
        
        int totalCount = 0;				// 총게시물 건수
        int sizePerPage = 10;			// 한 페이지당 보여줄 게시물 건수
        int totalPage = 0;				// 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
        int n_currentShowPageNo = 0;	// 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정한다.

		// 총 게시물 건수 (totalCount)
        totalCount = service.getBookmarkTotalCount(paraMap); // Map에 searchType과 searchWord를 넣어놨음
 		
        totalPage = (int) Math.ceil((double) totalCount / sizePerPage);

        try {
            n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
            if (n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
                n_currentShowPageNo = 1;
            }
        } catch (NumberFormatException e) {
            n_currentShowPageNo = 1;
        }

        int startRno = ((n_currentShowPageNo - 1) * sizePerPage) + 1;
        int endRno = startRno + sizePerPage - 1;

        paraMap.put("startRno", String.valueOf(startRno));  // Oracle 11g 와 호환
        paraMap.put("endRno", String.valueOf(endRno));		// Oracle 11g 와 호환
     // 위, 아래 둘 중 하나 사용
        paraMap.put("currentShowPageNo", currentShowPageNo);	// Oracle 12c 이상
        
        BookmarkList = service.getBookmarkList(paraMap);
        
        mav.addObject("BookmarkList", BookmarkList);
        
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
	    String url = "myboard";
	    
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
 		    
        mav.setViewName("content/community/bookmark"); 
        // /WEB-INF/views/content/community/bookmark.jsp 파일을 생성한다.

        return mav;
    }

    // 즐겨찾기된 게시글을 서버에서 가져오기
    @GetMapping("/bookmark/list")
    @ResponseBody
    public List<Integer> getBookmarkedPosts(HttpServletRequest request) {
        Integer member_userid = (Integer) request.getSession().getAttribute("member_userid");

        if (member_userid == null) {
            return new ArrayList<>();  // 로그인 안 했으면 빈 리스트 반환
        }

        return service.getUserBookmarks(member_userid); // 사용자의 즐겨찾기된 게시글 ID 목록 반환
    }

    
    
    
    
    
    
    
    
    
    
    
    // 게시글을 즐겨찾기에 추가
    @PostMapping("/bookmark/add")
    @ResponseBody
    public String addBookmark(@RequestParam("board_no") int board_no, HttpServletRequest request) {
        Integer member_userid = (Integer) request.getSession().getAttribute("member_userid");

        if (member_userid == null) {
            return "not_logged_in";
        }

        boolean isAdded = service.addBookmark(member_userid, board_no);
        return isAdded ? "success" : "fail";
    }

    // 즐겨찾기 삭제
    @PostMapping("/bookmark/remove")
    @ResponseBody
    public String removeBookmark(@RequestParam("board_no") int board_no, HttpServletRequest request) {
        Integer member_userid = (Integer) request.getSession().getAttribute("member_userid");

        if (member_userid == null) {
            return "not_logged_in";
        }

        boolean isRemoved = service.removeBookmark(member_userid, board_no);
        return isRemoved ? "success" : "fail";
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}