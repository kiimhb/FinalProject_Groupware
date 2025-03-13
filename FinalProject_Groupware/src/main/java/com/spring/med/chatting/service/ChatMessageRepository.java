package com.spring.med.chatting.service;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.spring.med.chatting.domain.MessageVO;

public interface ChatMessageRepository extends MongoRepository<MessageVO, String> {

	// 특정 채팅방의 메세지 내용을 조회하는 메소드
	
	
	// 특정 채팅방의 메시지를 시간순으로 정렬하여 조회하는 메소드 (필요시)
	
	
	
}
