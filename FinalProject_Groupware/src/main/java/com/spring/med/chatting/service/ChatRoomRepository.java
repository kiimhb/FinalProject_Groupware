package com.spring.med.chatting.service;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.spring.med.chatting.domain.ChatRoomVO;

@Repository
public interface ChatRoomRepository extends MongoRepository<ChatRoomVO, String> {

	// 모든 방을 조회한다.
	List<ChatRoomVO> findAll();
	
	
}
