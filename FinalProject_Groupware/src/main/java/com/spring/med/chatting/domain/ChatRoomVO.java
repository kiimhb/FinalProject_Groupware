package com.spring.med.chatting.domain;

import java.util.Date;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Data;

@Data
@Document(collection = "chat_rooms") // chat_rooms 컬렉션에 저장
public class ChatRoomVO { // 채팅룸VO
	
	@Id
	private String id; // 몽고디비의 고유한 id
	
	private String roomName; 	// 방이름 
	private String creator;  	// 방생성자
	private Date createRoomDate; // 방생성일자
	private List<String> participants; // 참가자 목록 (empno 또는 userId를 저장)
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public Date getCreateRoomDate() {
		return createRoomDate;
	}
	public void setCreateRoomDate(Date createRoomDate) {
		this.createRoomDate = createRoomDate;
	}
	public List<String> getParticipants() {
		return participants;
	}
	public void setParticipants(List<String> participants) {
		this.participants = participants;
	}

}
