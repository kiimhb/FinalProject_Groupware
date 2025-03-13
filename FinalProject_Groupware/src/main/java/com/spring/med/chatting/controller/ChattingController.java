package com.spring.med.chatting.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.chatting.domain.ChatRoomVO;
import com.spring.med.chatting.service.ChatMessageService;
import com.spring.med.chatting.service.ChatRoomRepository;
import com.spring.med.chatting.service.ChatRoomService;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.surgery.domain.SurgeryVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// === (#웹채팅관련3) ===
@Controller
@RequestMapping("/chatting/*")
public class ChattingController {
	
	@Autowired
	private ChatRoomService roomService;
	
	@Autowired
	private ChatMessageService messageService;
	
	
	// 채팅방 페이지를 불러옴
	@GetMapping("chat")
	public ModelAndView requiredLogin_multichat(HttpServletRequest request,HttpServletResponse response,
												ModelAndView mav) {
		
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		
		String creator = (String) loginuser.getMember_name();
		// System.out.println("creator" + creator);
		
		mav.addObject("creator", creator);
		mav.addObject("loginuser", loginuser);
		
		mav.setViewName("content/chatting/chatting");
		return mav;	
	}
	
	// 오픈 채팅방의 전체 목록을 불러온다.
	@GetMapping("chat/rooms")
	public ResponseEntity<List<ChatRoomVO>> getRooms(HttpServletRequest request,HttpServletResponse response) {
		List<ChatRoomVO> rooms = roomService.getAllChatRoomList();
		return ResponseEntity.ok(rooms);
	}
	
	// 채팅방 생성하기
	@PostMapping("chat/addRoom")
	@ResponseBody
	public ResponseEntity<Map<String, String>> addRoom(@RequestParam String creator,
													   @RequestParam String roomName) {
		
		ChatRoomVO newRoom = roomService.addRoom(creator, roomName); 
		
		Map<String, String> response = new HashMap<>();
		
		response.put("message", "채팅방이 생성되었습니다~");
		response.put("id", newRoom.getId()); // 생성된 방의 id 값을 받는다.
		
		return ResponseEntity.ok(response);
	}	
	
}
