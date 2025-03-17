package com.spring.med.chatting.service;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.spring.med.chatting.domain.MessageVO;

public interface ChatMessageRepository extends MongoRepository<MessageVO, String> {

}
