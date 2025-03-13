package com.spring.med.chatting.domain;

import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;


@Document(collection = "chat_message") // "chatting" 컬렉션(==테이블명) 에 저장되는 도큐먼트를 Mongo_messageVO class 로 사용하겠다는 말이다.
@Component
public class MessageVO { // 메세지

	@Id
	private String _id;     // "id" 또는 "_id" 라는 필드가 있으면 이 필드가 자동으로 도큐먼트의 "ObjectId" 인 "_id" 로 사용된다. 
   
	private String roomId;  // 채팅방 id
  	private String message; // 메세지 내용이다. 
  	private String type;    // all 이면 전체에게 채팅메시지를 보냄 / one 이면 특정 사람에게 메시지를 보냄
	private String to;      // 특정 웹소켓 id 1대1에서
	   
	private String userid;      // 사용자ID
	private String name;        // 사용자명
	private String currentTime; // 채팅한 시간 (오후 5:05) 
	

	/*
	    Date 타입의 변수를 사용하기 위해서 
	    @DateTimeFormat(iso = ISO.DATE_TIME) 어노테이션을 부여해 준 것이다.
	*/
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date created; // 채팅한 년월일시분초
	
	
	public String get_id() {
	 return _id;
	}
	
	public void set_id(String _id) {
	 this._id = _id;
	}
	
	public String getMessage() {
	 return message;
	}
	
	public void setMessage(String message) {
	 this.message = message;
	}
	
	public String getType() {
	 return type;
	}
	
	public void setType(String type) {
	 this.type = type;
	}
	
	public String getTo() {
	 return to;
	}
	
	public void setTo(String to) {
	 this.to = to;
	} 
	
	public String getUserid() {
	 return userid;
	}
	
	public void setUserid(String userid) {
	 this.userid = userid;
	}
	
	public String getName() {
	 return name;
	}
	
	public void setName(String name) {
	 this.name = name;
	}
	
	public String getCurrentTime() {
	 return currentTime;
	}
	
	public void setCurrentTime(String currentTime) {
	 this.currentTime = currentTime;
	}
	
	public Date getCreated() {
	 return created;
	}
	
	public void setCreated(Date created) {
	 this.created = created;
	}

	public String getRoomId() {
		return roomId;
	}

	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}
	
	
	public static MessageVO convertMessage(String source) {
		
		Gson gson = new Gson();
	
		MessageVO messagevo = gson.fromJson(source, MessageVO.class);
		// source 는 JSON 형태로 되어진 문자열
		// gson.fromJson(source, MessageVO.class); 은 
		// JSON 형태로 되어진 문자열 source를 실제 MessageVO 객체로 변환해준다.
		
		return messagevo;
	}
	
	
}
