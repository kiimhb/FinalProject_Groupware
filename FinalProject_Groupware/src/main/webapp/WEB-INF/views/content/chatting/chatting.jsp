<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/chatting/chatting.css" />
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- === (#웹채팅관련4) === -->

<jsp:include page="../../header/header1.jsp" /> 

<script type="text/javascript">
	
let websocket;
let currentRoomId = null;

$(document).ready(function(){

	getChatRoomList(); // 채팅방 목록 불러오기 
	
	//////////////////////////////////////////////////////////////////////////
	
	// === 메시지 입력후 엔터하기 === //
    $("input.chatText").keyup(function(key){
       if(key.keyCode == 13) {
          $("button.submit").click(); 
       }
    });
	
	// 메시지 보내기 // 
	let isOnlyOneDialog = false;
	
	$("button.submit").click(function() {
		
		if( $("input.submit").val() != "") {

			let messageVal = $("input.chatText").val();
			messageVal = messageVal.replace(/<script/gi, "&lt;script");
			// 스크립트 공격을 막으려고 한 것임.
			
			messageObj = {};
			messageObj.message = messageVal;
			messageObj.type="all";
			messageObj.to="all";
			messageObj.userid = $("input#member_userid").val(); // 보낸사람아이디
			messageObj.name = $("input#member_name").val(); // 보낸사람 이름
			messageObj.roomId = currentRoomId;	// 채팅방 id

			const to = $("input#to").val();
			
			if(to !== "") {
				messageObj.type="one";
				messageObj.to=to;
			}

			websocket.send(JSON.stringify(messageObj));
			
			
			const now = new Date();
            let ampm = "오전 ";
            let hours = now.getHours();
            
            if(hours > 12) {
               hours = hours - 12;
               ampm = "오후 ";
            }
            
            if(hours == 0) {
               hours = 12;
            }
            
            if(hours == 12) {
				ampm = "오후 ";
            }
            
            let minutes = now.getMinutes();
            
            if(minutes < 10) {
              minutes = "0"+minutes;
            }
          
            const currentTime = ampm + hours + ":" + minutes; 
			
						
			if(isOnlyOneDialog == false) { // 귀속말이 아닌 경우
                 $("div.chat_box").append("<div class='chattingbox'>" + messageVal + "</div> <div class='currentTime'>"+currentTime+"</div> <div class='both'>&nbsp;</div>");                                                                                                                                                            
            }
			else { // 귀속말인 경우. 글자색을 빨강색으로 함.
                 $("div.chat_box").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all; color: red;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>");     
            }
			
			$("div.chatingScreen").scrollTop(99999999);           
            $("input.chatText").val("");
            $("input.chatText").focus();
		}
		
	});
	
	// 나가기 버튼을 클릭하였을 경우
	$("div.outroom").on("click", function() {
		
		if(confirm("채팅방을 나가시겠습니까?")) {
			
			websocket.close();
			
			alert("채팅방을 나갔습니다.");
			window.location.href = `<%= ctxPath%>/chatting/chat`;
		} else {
			alert("나가기 취소");
		}
		
	});
	
	$("button#successRoom").on("click", function(){
		$("div#addChatingRoom").modal('hide');
	});
	
}); // end of $(document).ready(function()

// 채팅방 만들기
function createChatRoom(creator) {
	
	const roomName = $("input[name='roomName']").val();
	
	$.ajax({
		url: "chat/addRoom",
		method:"POST",
		dataType: "json",
		data: {"creator":creator,
			   "roomName":roomName},
		success:function(json){
			getChatRoomList(); // 채팅방 목록 새로고침하기
			enterRoom(json.id); // 채팅방 입장	
		},
	    error: function(request, status, error){
	   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	    }
	});
}

// 채팅방 목록 불러오기
function getChatRoomList() {
	
	fetch("chat/rooms") // 서버에서 채팅방 목록을 가져오는 것이다.
	.then(response => response.json())	// 응답을 json 형태로 
	.then(data => { // 변환된 데이터이다.
		let chatRoomList = document.querySelector(".chatRoomList"); // 채팅방 목록을 표시할 요소
		
		chatRoomList.innerHTML = ""; // 기존 목록 초기화 
		
		data.forEach(room => { // 가져온 채팅방 데이터를 하나씩 처리한다.
			
			let roomDiv = document.createElement("div"); // 채팅방을 나타내는 div 요소를 생성한다.
			
			roomDiv.classList.add("oneRoom"); // div의 클래스명은 oneRoom 이다.
			roomDiv.setAttribute("data-id", room.id)
			// 채팅방 이름 및 프로필 표시
			roomDiv.innerHTML = `<div class="chatroomName">\${room.roomName}</div>`; // 채팅방 이름 및 이미지 표시
								 
			// 채팅방 클릭 시 입장하는 이벤트	
			roomDiv.onclick = function() {
				enterRoom(roomDiv.getAttribute("data-id"), room.roomName); // 채팅방 클릭할경우 입장하는 것이다.
				boldTitle(roomDiv); // 현재방 타이틀 강조하기
			}
				
			// 채팅방 목록을 요소에 추가한다.
			chatRoomList.appendChild(roomDiv); 
		});
		
	})
	. catch(error => alert("채팅방 목록 불러오기 실패", error))
}


// 채팅방 참가하기
function enterRoom(roomId, roomName) {
	
	$("div.titleRoomName").text(roomName);
	$("div.chat_box").html("");
	$("div.memberList").html("");
	
	currentRoomId = roomId;
	
	const url = window.location.host; // 웹브라우저에 주소창의 포트까지 가져옴.
	const pathname = window.location.pathname; // 최초 '/' 부터 오른쪽에 있는 모든 경로
	const appCtx = pathname.substring(0, pathname.lastIndexOf("/")); // "전체 문자열".lastIndexOf("검사할 문자");
	const root = url + appCtx;
	const wsUrl = "ws://" + root + "/multichatstart/";
	// 웹소켓통신을 하기위해서는 http:// 을 사용하는 것이 아니라 ws:// 을 사용해야 한다. 

    // 새로운 WebSocket 연결
	websocket = new WebSocket(wsUrl + roomId);
	alert(wsUrl + roomId);
	
	let messageObj = {}; // 자바스크립트 객체 생성함.
	
	var ctxPath = `<%= ctxPath %>`;  // JSP 변수를 JavaScript 변수로 변환
	// alert(ctxPath);
	
	// === 웹소켓에 최초로 연결이 되었을 경우에 실행되어지는 콜백함수 정의하기 === //
	websocket.onopen = function(){
		alert("웹소켓 연결됨");
	}
	
	// === 메시지 수신시 콜백함수 정의 === //
	websocket.onmessage = function(event) {
		// console.log(event.data);
		// event.data 는 수신 되어진 메시지이다.
		if(event.data.substr(0,1)=="⊆") { // 채팅방 접속자 목록 불러오기
			$("div.memberList").html(event.data.substring(1));
		}
		else { // 수신받은 채팅문자이다.
			// console.log("채팅 메시지 수신", event.data);
			$("div.chat_box").append(event.data);
   		 	$("div.chat_box").append("<br>");
   		 	$("div.chat_box").scrollTop(999999999);
		}
	};
	
	// === 웹소켓 연결 해제 시 콜백함수 정의하기 === //
    websocket.onclose = function(){
    	alert("웹소켓연결종료됨");
		removeboldTitle();
    }
	
}

// 현재 참가중인 채팅방 글자색 바뀌도록
function boldTitle(selectRoom) {
	
	document.querySelectorAll(".oneRoom").forEach(room => {
        room.style.fontWeight = "normal";
    }); // 모든 채팅방 스타일 초기화
	
	selectRoom.style.fontWeight = "bold"; // 참가중인 채팅방만 bold 적용
}

// 참가중인 채팅방 나가면 글자 원래대로
function removeboldTitle() {
	document.querySelectorAll(".oneRoom").forEach(room => {
        room.style.fontWeight = "normal";
    });
}
</script>
	
	<div id="container">
		<input type="hidden" id="member_userid" value="${requestScope.loginuser.member_userid}">
		<input type="hidden" id="member_name" value="${requestScope.loginuser.member_name}">
		<input type="hidden" id="to" />
		
		<!-- 채팅방 목록을 보여준다. -->
		<div class="left">
			<div class="chatTitle">오픈채팅방<i class="plus fa-solid fa-plus" data-toggle="modal" data-target="#addChatingRoom"></i></div>

			<div class="chatRoomList">
				
			</div>
		</div>

		<!-- 실시간 채팅이 이루어지는 곳이다. -->
		<div class="middle">
		
			<div class="roomname">
				<div class="titleRoomName"></div>	
				<div class="outroom">나가기</div>
			</div>
			
			
			<div class="chatingScreen">
				<div class="chat_profile">
					<!-- 프로필사진 -->
				</div>
				<div class="chat_box">
					<!-- 채팅박스 -->
				</div>
			</div>
			<div class="chatText">
				<input type="text" class="chatText" placeholder="Enter Message"/>
				<button type="button" class="btn submit" value="전송">전송</button>
			</div>
		</div>	
		
		<!-- 채팅에 참가한 직원들 목록이 보인다. -->
		<div class="right">
			<div class="chatMember">대화상대</div>
			<div class="memberList">
				
				
			</div>
		</div>		

	</div>
	<!-- 채팅방 생성하기 modal 만들기 시작 -->
	<div class="modal fade" id="addChatingRoom" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered modal-ml">
		  <div class="modal-content">
			<!-- Modal header -->
			<div class="modal-header">
			  <h5 class="modal-title">채팅방 생성하기</h5>
			  <button type="button" class="close" data-dismiss="modal">&times;</button>
			</div>
			<!-- Modal body -->
			<div class="modal-body">
				<div class="inputRoomName">
					<div>생성자</div>
					<input type="text" name="creator" value="${requestScope.creator}" readonly />
				</div>
				<div class="inputRoomName">
					<div>채팅방 이름</div>
					<input type="text" name="roomName" placeholder="채팅방 이름을 입력하세요" />
				</div>
			</div>
			<!-- Modal footer -->
			<div class="modal-footer">
			  <button type="button" id="successRoom" class="addChatingRoom btn" onclick="createChatRoom('${requestScope.creator}')">작성하기</button>
			  <button type="button" class="btn btn-dark" data-dismiss="modal">Close</button>
			</div>
		  </div>
		</div>
	</div>
	<!-- modal 만들기 끝 -->	

<jsp:include page="../../footer/footer1.jsp" />   