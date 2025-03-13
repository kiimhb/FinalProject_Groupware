<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.net.InetAddress" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> <!-- Spring security taglib을 사용 --> 
--%>

<%-- ===== header 페이지 만들기 ===== --%>
<%
	String ctxPath = request.getContextPath();
    //     /myspring
%> 

<%
    // === (#웹채팅관련2) === 
    // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) ===
    
    InetAddress inet = InetAddress.getLocalHost();
     String serverIP = inet.getHostAddress();
     
 	// System.out.println("serverIP : " + serverIP);
 	// serverIP : 192.168.0.219
 
    // === 서버 포트번호 알아오기 === //
    int portnumber = request.getServerPort();
 	// System.out.println("portnumber : " + portnumber);
 	// portnumber : 9090
 
    String serverName = "http://"+serverIP+":"+portnumber;
 	// System.out.println("serverName : " + serverName);
 	// serverName : http://192.168.0.208:9090

%>

   
<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />


<%-- 
<%
	String ctxPath = request.getContextPath();
    //     /myspring    

    // === #221. (웹채팅관련3) === 
    // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) === 
    
 // InetAddress inet = InetAddress.getLocalHost();
 // String serverIP = inet.getHostAddress();
     
 // System.out.println("serverIP : " + serverIP);
 // serverIP : 192.168.0.219

 // String serverIP = "192.168.0.219";
    String serverIP = "43.203.242.79"; 
    // 자신의 EC2 퍼블릭 IPv4 주소임. // 아마존(AWS)에 배포를 하기 위한 것임. 
    // 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다. 
 
    // === 서버 포트번호 알아오기 === //
    int portnumber = request.getServerPort();
 // System.out.println("portnumber : " + portnumber);
 // portnumber : 9090
 
    String serverName = "http://"+serverIP+":"+portnumber;
 // System.out.println("serverName : " + serverName);
 // serverName : http://192.168.0.219:9090 

%>
--%>
<script type="text/javascript">
function toggleAlarm() {
	  var AlarmBox = document.getElementById("Alarm_box");
	  // 알림 박스가 보일 때는 숨기고, 숨겨져 있을 때는 보이게 하기
	  if (AlarmBox.style.display === "block") {
		  AlarmBox.style.display = "none";
	  } else {
		  AlarmBox.style.display = "block";
	  }
	}


</script>


    <%-- 상단 네비게이션 시작 --%>
	<nav class="navbar">
	 
		<a class="navbar-brand" href="<%=ctxPath%>/index">
		    <div class="logo-container">
		        <img class="logo-img" src="<%=ctxPath%>/image/main_logo.png">
		        <div class="logo-text">
		            <span class="main_logo">마포아삭병원</span>
		            <span class="main_logo2">Asak Medical Center</span>
	        	</div>
		    </div>
		</a>
		
		<div class="navbar_menu">
		
			<button type="button"  class="dropdown-btn nav_button_css" onclick="toggleAlarm()">
				<i class="fa-solid fa-bell nav_i_css1"></i>
			</button>

			<div id="Alarm_box" class="Alarm_box">
				<div class="Alarm_main_box"> <p>빨리합시다.</p><p>빨리합시다.</p><p>빨리합시다.</p><p>빨리합시다.</p></div>
				<div  class="Alarm_sub_box"> 알림이 0건 있습니다. </div>
			</div>
	

		<button type="button" class="nav_button_css" >
		<i class="fa-solid fa-comments nav_i_css2" onclick="location.href='<%=ctxPath%>/chatting/chat'"></i>
		</button>
		</div>
	</nav>