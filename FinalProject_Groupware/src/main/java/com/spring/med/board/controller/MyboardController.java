package com.spring.med.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.board.domain.BoardVO;
import com.spring.med.board.service.BoardService;
import com.spring.med.board.service.MyboardService;
import com.spring.med.common.MyUtil;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/community/*")
public class MyboardController {

    @Autowired
    private MyboardService service;

    // 내가 쓴 글 목록 조회
    @GetMapping("myboard")
    public ModelAndView myBoard(ModelAndView mav, HttpServletRequest request,
                                @RequestParam(defaultValue = "") String searchType,
                                @RequestParam(defaultValue = "") String searchWord,
                                @RequestParam(defaultValue = "1") String currentShowPageNo) {

    	HttpSession session = request.getSession();
        ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

        if (loginuser == null) {
            mav.setViewName("redirect:/login"); // 로그인 안 했으면 로그인 페이지로 이동
            return mav;
        }

        String login_member_userid = loginuser.getMember_userid();

        List<BoardVO> myBoardList = null;
        
        ///////////////////////////////////////////////////////////

        searchWord = searchWord.trim();
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);
        paraMap.put("fk_member_userid", login_member_userid);

        int totalCount = service.getMyBoardTotalCount(paraMap);
        int sizePerPage = 10;
        int totalPage = (int) Math.ceil((double) totalCount / sizePerPage);

        int n_currentShowPageNo = 1;
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

        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));

        myBoardList = service.getMyBoardList(paraMap);
        mav.addObject("myBoardList", myBoardList);

        String pageBar = generatePageBar(n_currentShowPageNo, totalPage, searchType, searchWord, "myboard");
        mav.addObject("pageBar", pageBar);

        mav.addObject("totalCount", totalCount);
        mav.addObject("currentShowPageNo", currentShowPageNo);
        mav.addObject("sizePerPage", sizePerPage);

        mav.setViewName("content/communit/myboard");
        return mav;
    }

    private String generatePageBar(int currentPage, int totalPage, String searchType, String searchWord, String url) {
        int blockSize = 10;
        int loop = 1;
        int pageNo = ((currentPage - 1) / blockSize) * blockSize + 1;

        StringBuilder pageBar = new StringBuilder("<ul style='list-style:none;'>");

        pageBar.append("<li style='display:inline-block; width:70px; font-size:12pt;'><a href='").append(url)
                .append("?searchType=").append(searchType).append("&searchWord=").append(searchWord)
                .append("&currentShowPageNo=1'><<</a></li>");

        if (pageNo != 1) {
            pageBar.append("<li style='display:inline-block; width:50px; font-size:12pt;'><a href='").append(url)
                    .append("?searchType=").append(searchType).append("&searchWord=").append(searchWord)
                    .append("&currentShowPageNo=").append(pageNo - 1).append("'><</a></li>");
        }

        while (!(loop > blockSize || pageNo > totalPage)) {
            if (pageNo == currentPage) {
                pageBar.append("<li style='display:inline-block; width:30px; font-size:12pt; border: solid 1px gray; color:red; padding:2px 4px'>")
                        .append(pageNo).append("</li>");
            } else {
                pageBar.append("<li style='display:inline-block; width:30px; font-size:12pt;'><a href='").append(url)
                        .append("?searchType=").append(searchType).append("&searchWord=").append(searchWord)
                        .append("&currentShowPageNo=").append(pageNo).append("'>").append(pageNo).append("</a></li>");
            }
            loop++;
            pageNo++;
        }

        if (pageNo <= totalPage) {
            pageBar.append("<li style='display:inline-block; width:50px; font-size:12pt;'><a href='").append(url)
                    .append("?searchType=").append(searchType).append("&searchWord=").append(searchWord)
                    .append("&currentShowPageNo=").append(pageNo).append("'>></a></li>");
        }

        pageBar.append("<li style='display:inline-block; width:70px; font-size:12pt;'><a href='").append(url)
                .append("?searchType=").append(searchType).append("&searchWord=").append(searchWord)
                .append("&currentShowPageNo=").append(totalPage).append("'>>></a></li>");
        pageBar.append("</ul>");

        return pageBar.toString();
    }

    
    
 // 내가 쓴 글 1개 조회 (view.jsp로 이동)
    @RequestMapping("view")
    public ModelAndView myboardView(ModelAndView mav
    								, HttpServletRequest request) {

        HttpSession session = request.getSession();
        ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");

        if (loginuser == null) {
            mav.setViewName("redirect:/login");
            return mav;
        }

        String login_member_userid = loginuser.getMember_userid();
        
        String board_no ="";
		String goBackURL ="";
		String searchType ="";
		String searchWord ="";

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("board_no", board_no);
        paraMap.put("login_member_userid", login_member_userid);

        BoardVO boardvo = service.getMyBoardView(paraMap);

        if (boardvo == null) {
            mav.setViewName("redirect:/community/myboard");
            return mav;
        }

        mav.addObject("boardvo", boardvo);
        mav.setViewName("content/community/board/view"); // 기존 view.jsp와 동일한 뷰 사용
        return mav;
    }
}
    
    
    
    
