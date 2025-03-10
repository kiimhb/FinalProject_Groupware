package com.spring.med.memo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.memo.domain.MemoVO;
import com.spring.med.memo.service.MemoService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/memo/*")
public class MemoController {


  @Autowired // Type 에 따라 알아서 Bean 을 주입해준다. 
  private MemoService service;
 

	// 메모장 폼 페이지 요청
	@GetMapping("memowrite")
	public ModelAndView memo(ModelAndView mav, HttpServletRequest request) {

		// 1. DB에서 메모 목록 가져오기
	    List<MemoVO> memoList = service.getMemoList();

	    // 2. JSP로 전달할 데이터 설정
	    mav.addObject("memoList", memoList);


		mav.setViewName("content/memo/memowrite"); 
		// /WEB-INF/views/content/memo/memowrite.jsp 파일을 생성한다.

		return mav;
	}
	
	
	
	
	// 중요메모
	@GetMapping("importantmemo")
	public ModelAndView importantmemo(ModelAndView mav) {


		mav.setViewName("content/memo/importantmemo"); 
		// /WEB-INF/views/content/memo/importantmemo.jsp 파일을 생성한다.

		return mav;
	}
	
	// 중요메모
	@GetMapping("trash")
	public ModelAndView trash(ModelAndView mav) {


		mav.setViewName("content/memo/trash"); 
		// /WEB-INF/views/content/memo/trash.jsp 파일을 생성한다.

		return mav;
	}
}
