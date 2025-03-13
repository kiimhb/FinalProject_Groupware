package com.spring.med.chatting.controller;

import java.io.IOException;
import java.net.http.HttpRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;

import com.spring.med.chatting.domain.MessageVO;
import com.spring.med.chatting.service.ChatMessageRepository;
import com.spring.med.chatting.service.ChattingMongoOperations;
import com.spring.med.management.domain.ManagementVO_ga;

// === (#웹채팅관련6) === // 
@Component
public class WebsocketEchoHandler extends TextWebSocketHandler {
	
	// === 웹소켓서버에 연결한 클라이언트 사용자들을 저장하는 리스트 === 
	private final List<WebSocketSession> connectedUsers = new ArrayList<>();
	
	// 방별로 관리하기 위함 (대화참여자 목록도 존재)
	private final Map<String, Set<WebSocketSession>> chatRooms = new ConcurrentHashMap<>();
	
    // ======= 몽고DB 시작 ======= //
    // === (#웹채팅관련8) === //
	@Autowired
	private MessageVO chatmessage = new MessageVO();
	
    @Autowired
    private ChatMessageRepository chatMessageRepository;
    
    @Autowired
    private ChattingMongoOperations chattingMongo;
    // ======= 몽고DB 끝 ======= // 

	// init-method 초기화 메소드
	public void init() throws Exception {}
	
	// 채팅방에 입장했을 경우
	@Override
	public void afterConnectionEstablished(WebSocketSession wsession) throws Exception {
		
		// 웹소켓에 연결된 사용자 리스트 추가
		connectedUsers.add(wsession);
		
		// URL 에서 채팅방 아이디 가져오기 
		String path = wsession.getUri().getPath();
		// path/med-groupware/chatting/multichatstart/67ca7e75d20865c18164ef6e
		String[] pathparts = path.split("/");
		String roomId = pathparts[pathparts.length - 1];
		
		if(roomId == null) {
			wsession.close();
			return;
		}	
		
		// 현재의 세션이 이미 참가 중인 방이 있는지 확인
	    String currentRoomId = (String) wsession.getAttributes().get("roomId");
	    // System.out.println("currentRoomId"+currentRoomId);
	    if (currentRoomId != null && !currentRoomId.equals(roomId)) {
	    	removeSessionChatRoom(currentRoomId, wsession);
	        updateParticipantList(currentRoomId);
	    }

		// roomId 세션에 저장
		wsession.getAttributes().put("roomId", roomId);
		// 방이 없으면 생성 (동기화된 Set 사용)
		chatRooms.putIfAbsent(roomId, Collections.synchronizedSet(new HashSet<>()));
		// 방에 사용자 추가
		chatRooms.get(roomId).add(wsession);
		
		// 참가자 목록 갱신하기
		updateParticipantList(roomId);
		
		// 로그인 사용자 정보 가져오기
		ManagementVO_ga loginuser = (ManagementVO_ga) wsession.getAttributes().get("loginuser");
		
		// 입장 메시지를 해당 채팅방 사용자에게 전송한다.
		String joinMessage = loginuser.getMember_name() + "님이 채팅방에 입장했습니다.";
		for(WebSocketSession session : chatRooms.get(roomId)) {
			session.sendMessage(new TextMessage("<div style='text-align: center; color:#4c4d4f;'>" + joinMessage + "</div><br>"));
		}
		
        // =========================== 몽고DB 시작 =========================== //
		List<MessageVO> list = chattingMongo.listChatting(roomId);
		SimpleDateFormat sdfrmt = new SimpleDateFormat("yyyy년 MM월 dd일 E요일", Locale.KOREA);
		
		if(list != null && list.size() > 0) {	// 이전에 나누었던 대화내용이 있다라면 
			for(int i=0; i<list.size(); i++) {
				
				String str_created = sdfrmt.format(list.get(i).getCreated()); // 대화내용을 나누었던 날짜를 읽어온다. 
				// 대화내용의 날짜가 같은 날짜인지 새로운 날짜인지 알기위한 용도임.
				boolean is_newDay = true; 
				
				// 다음번 내용물에 있는 대화를 했던 날짜가 이전 내용물에 있는 대화를 했던 날짜와 같다라면
				if(i>0 && str_created.equals(sdfrmt.format(list.get(i-1).getCreated())) ) { 		
					is_newDay = false;	// 이 대화내용은 새로운 날짜의 대화가 아님을 표시한다. 
				}
				
				if(is_newDay) {
					wsession.sendMessage(
						new TextMessage("<div style='text-align: center;'>" + str_created + "</div>")
	                ); // 대화를 나누었던 날짜를 배경색을 회색으로 하여 보여주도록 한다.
				}

				// 본인이 작성한 채팅메시지일 경우라면
				if(loginuser.getMember_userid().equals(list.get(i).getUserid())) {   
	                wsession.sendMessage(
                		new TextMessage("<div class='chattingbox'>" + list.get(i).getMessage() + "</div> <div class='currentTime'>"+list.get(i).getCurrentTime()+"</div> <div style='clear: both;'>&nbsp;</div>")  
            		);
	            }
				else { // 다른 사람이 작성한 채팅메시지일 경우라면.. 작성자명이 나오고 흰배경색으로 보이게 한다.    
	                wsession.sendMessage(
	                	new TextMessage("<span style='font-weight:bold; cursor:pointer;' class='loginuserName'>" + list.get(i).getName()+ "</span><br><div class='leftchattingbox'>"+ list.get(i).getMessage() +"</div> <div style='display: inline-block; padding: 20px 0 0 5px; font-size: 7pt;'>"+list.get(i).getCurrentTime()+"</div> <div>&nbsp;</div>" ) 
	                );     
	            }
				
			} // end of for
		}
        // =========================== 몽고DB 끝  =========================== //
	} // end of public void afterConnectionEstablished(WebSocketSession wsession) throws Exception
	
	
	// 접속한 사용자 갱신하기 
	private void updateParticipantList(String roomId) throws IOException {

		Set<WebSocketSession> sessionsInRoom = chatRooms.get(roomId);
		if(sessionsInRoom == null || sessionsInRoom.isEmpty()) {
			return;
		}

		StringBuilder v_html = new StringBuilder("⊆");  
        for (WebSocketSession session : new HashSet<>(sessionsInRoom)) {

            ManagementVO_ga user = (ManagementVO_ga) session.getAttributes().get("loginuser");
            String ctxPath = (String) session.getAttributes().get("ctxPath");
            // System.out.println("ctxPath"+ctxPath);
            
            if (user != null) {
                v_html.append("<div class='oneMemberList'>")
                      .append("<div class='memberProfile'><img src='")
                      .append(ctxPath).append("/resources/profile/")
                      .append(user.getMember_pro_filename()).append("' /></div>")
                      .append("<div class='memberName'>").append(user.getMember_name()).append("</div>")
                      .append("</div>");
            }
        }

        // 방 안의 모든 세션에 사용자 목록 전송
        for (WebSocketSession session : new HashSet<>(sessionsInRoom)) {
            session.sendMessage(new TextMessage(v_html.toString()));
        }
	    
	}
	
	// 메시지 전송하기 
	@Override
	public void handleTextMessage(WebSocketSession wsession, TextMessage message) throws Exception {

		try {	
			
			Map<String, Object> map = wsession.getAttributes();	
			ManagementVO_ga loginuser = (ManagementVO_ga) map.get("loginuser");
			MessageVO messageVO = MessageVO.convertMessage(message.getPayload());
			
			String roomId = messageVO.getRoomId(); // 클라이언트에게 보낸 방번호
			
			// System.out.println("채팅 전 roomId: " + roomId);
            // System.out.println("현재 chatRooms 상태: " + chatRooms);
                	
			Date now = new Date(); // 현재시각 
	        String currentTime = String.format("%tp %tl:%tM",now,now,now); 
	        
	        // 채팅방에 참여하고 있는 모든 사용자들의 세션 
	        Set<WebSocketSession> connectedUsersInRoom = chatRooms.get(roomId);
	        // System.out.println("connectedUsersInRoom"+connectedUsersInRoom);
	        
	        if(connectedUsersInRoom != null) {
        		for(WebSocketSession webSocketSession : connectedUsersInRoom) {
        			if(!wsession.getId().equals(webSocketSession.getId())) {
        				webSocketSession.sendMessage(new TextMessage("<span style='display:inline'>"
						 + "</span>&nbsp;<span style='font-weight:bold; cursor:pointer;' class='loginuserName'>" 
						 + loginuser.getMember_name()+"</span><br><div style='background-color: #eee; display: inline-block; max-width: 60%; padding: 7px; border-radius: 15%; word-break: break-all;'>"
						 + messageVO.getMessage()+"</div> <div style='display: inline-block; padding: 20px 0 0 5px; font-size: 7pt;'>"
						 + currentTime +"</div> <div>&nbsp;</div>"));
        			}
        		}
        	}
	    
    		else { // type 이 "all" 이 아닌경우 
			    			
    		}//  if(roomId != null && !roomId.isEmpty())   		

	        // =========================== 몽고DB 시작 =========================== //
	    	if("all".equals(messageVO.getType())) {
		    	
		    	String id = String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); 
		        id += System.nanoTime();
		    	chatmessage.set_id(id);
		    	chatmessage.setUserid(loginuser.getMember_userid()); // 보낸사람
		    	chatmessage.setName(loginuser.getMember_name());
		    	chatmessage.setMessage(messageVO.getMessage());
		    	chatmessage.setType(messageVO.getType());
		    	chatmessage.setRoomId(roomId);
		    	chatmessage.setCreated(new Date());
		    	chatmessage.setTo(messageVO.getTo());
		    	chatmessage.setCurrentTime(currentTime);
		      
		    	chatMessageRepository.save(chatmessage);
	    	}
		} catch(Exception e) {
			e.printStackTrace();
		}
        // =========================== 몽고DB 끝 =========================== //	
	
	}// end of public void handleTextMessage(WebSocketSession wsession, TextMessage message) throws Exception {
	
	
	// 세션 제거하기
	public void afterConnectionClosed(WebSocketSession wsession, CloseStatus status) throws IOException {
		
		connectedUsers.remove(wsession);

		String roomId = (String) wsession.getAttributes().get("roomId");
		if (roomId != null) {
	        removeSessionChatRoom(roomId, wsession);
	        updateParticipantList(roomId); // 즉시 참가자 목록 갱신
	    }
		
		Map<String, Object> map = wsession.getAttributes();
		ManagementVO_ga loginuser = (ManagementVO_ga) map.get("loginuser");
			
		
		for (WebSocketSession webSocketSession : connectedUsers) {
	            
            // 퇴장했다라는 메시지를 자기자신을 뺀 나머지 모든 사용자들에게 메시지를 보내도록 한다.
            if (!wsession.getId().equals(webSocketSession.getId())) { 
                 try {
					webSocketSession.sendMessage(
					    new TextMessage("<div style='text-align: center; color:#4c4d4f;'>" + loginuser.getMember_name() + " 님이 퇴장하였습니다. </div><br>")
					 );
				} catch (IOException e) {
					e.printStackTrace();
				}
            }
    
		} // end of for --------------------
	}
	
	// 방에서 나갈 때 세션 제거하는 
	public void removeSessionChatRoom(String roomId, WebSocketSession wsession) {
		Set<WebSocketSession> sessionsInRoom = chatRooms.get(roomId);
	    if (sessionsInRoom != null) { // 방이 존재하는 경우
	        sessionsInRoom.remove(wsession); // 사용자가 방을 떠나면 세션에서 제거하는 것이다.
	        
	        if (sessionsInRoom.isEmpty()) { // 사용자가 떠난 후 방이 비어 있으면 삭제 (빈 방일 경우)
	            chatRooms.remove(roomId); // 방을 삭제한다. 
	        }
	    }
	}
	

}
