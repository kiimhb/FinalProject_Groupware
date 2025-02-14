package com.spring.med.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.board.service.BoardService;
import com.spring.med.board.domain.BoardVO;
import com.spring.med.common.MyUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/board/*")
public class BoardController {
	
	@Autowired  // Type 에 따라 알아서 Bean 을 주입해준다.
	private BoardService service;

	// === #01. 게시판 글쓰기 폼페이지 요청 === //
	@GetMapping("add")
	public ModelAndView add(ModelAndView mav) {


		mav.setViewName("content/community/board/add"); 
		// /WEB-INF/views/content/community/board/add.jsp 파일을 생성한다.

		return mav;
	}
	
	
	  // === #03. 게시판 글쓰기 완료 요청 === // 
	  @PostMapping("add") public ModelAndView add(ModelAndView mav, BoardVO boardvo) {
		  
	  int n = service.add(boardvo); // <== 파일첨부가 없는 글쓰기  
	  
	  mav.setViewName("content/community/board/add"); //
	  // /WEB-INF/views/content/community/board/add.jsp 파일을 생성한다.
	  
	  return mav; 
	  }
	 
	
	
	@GetMapping("list")
	public ModelAndView list(ModelAndView mav, HttpServletRequest request) {

		/*
		 * List<BoardVO> boardList = null;
		 * 
		 * // === 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 === // boardList =
		 * service.boardListNoSearch();
		 * 
		 * mav.addObject("boardList", boardList);
		 */
		mav.setViewName("content/community/board/list"); 
		// /WEB-INF/views/content/community/board/list.jsp 파일을 생성한다.

		return mav;
	}
}


