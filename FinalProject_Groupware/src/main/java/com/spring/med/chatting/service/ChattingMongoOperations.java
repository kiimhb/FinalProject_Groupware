package com.spring.med.chatting.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import com.spring.med.chatting.domain.MessageVO;

@Service
public class ChattingMongoOperations {

	@Autowired
 	private MongoOperations mongo; 

	
	public List<MessageVO> listChatting(String roomId) {
			
			List<MessageVO> list = null;
			
			try {
				// >>> 정렬결과 조회 <<< //
				Query query = new Query();
				query.addCriteria(Criteria.where("roomId").is(roomId));  // roomId로 필터링
				query.with(Sort.by(Sort.Direction.ASC, "created"));
				
				
				list = mongo.find(query, MessageVO.class);
				
				// System.out.println("Retrieved Messages: " + list);

			} catch(Exception e) {
				e.printStackTrace();
			}
			
			return list;
	}
	
}
