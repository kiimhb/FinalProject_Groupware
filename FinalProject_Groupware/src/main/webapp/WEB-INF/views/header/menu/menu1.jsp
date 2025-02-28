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
		<div class="dropdown">
			<button type="button" class="dropdown-btn"><i class="fa-solid fa-bell"></i></button>
			<!-- <div class="dropdown-content">
				<div class="notification">
					[전체]공지사항 [급여관련 변경사항] ..... <span>5초 전</span>
				</div>
				<div class="notification">
					[전체]공지사항 [급여관련 변경사항] ..... <span>1일 전</span>
				</div>
				<div class="notification">
					[부서]공지사항 [휴가기획서 결재관] <span>3일 전</span>
				</div>
				<div class="notification">
					[부서]공지사항 [외래 안전교육관련] <span>3일 전</span>
				</div>
				<div class="notification">
					[전체]공지사항 [기안서 마감기간 관] <span>한달 전</span>
				</div>
			</div> -->
		</div>

		<a href="<%=ctxPath%>" class="navbar_menu1"><i class="fa-solid fa-comments"></i></a>
		</div>
	</nav>