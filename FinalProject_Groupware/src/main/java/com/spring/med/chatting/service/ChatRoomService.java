package com.spring.med.chatting.service;

import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.chatting.domain.ChatRoomVO;

@Service
public class ChatRoomService {
	
	@Autowired
	private ChatRoomRepository chatRoomRepository;
	
	
	// 방 목록을 조회한다.
	public List<ChatRoomVO> getAllChatRoomList() {
		return chatRoomRepository.findAll();
	}

	// 채팅방을 생성한다.
	public ChatRoomVO addRoom(String creator, String roomName) {
		
		ChatRoomVO newroom = new ChatRoomVO();
		newroom.setRoomName(roomName);
		newroom.setCreator(creator);
		newroom.setCreateRoomDate(new Date());
		newroom.setParticipants(Collections.singletonList(creator)); // 초기 참가자는 방생성자만 존재한다.
		
		chatRoomRepository.save(newroom);
		
		return newroom;
	}
	
}
