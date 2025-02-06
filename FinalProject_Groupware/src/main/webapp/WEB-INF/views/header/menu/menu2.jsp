<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> <!-- Spring security taglib을 사용 --> --%>

<%-- ===== header 페이지 만들기 ===== --%> 
<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

    <%-- 상단 네비게이션 시작 --%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top mx-4 py-3">
		<!-- Brand/logo --> 
		<a class="navbar-brand" href="<%=ctxPath%>/index" style="margin-right: 10%;"><img src="<%=ctxPath%>/images/sist_logo.png" /></a>
		
		<!-- 아코디언 같은 Navigation Bar 만들기 -->
	    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
	      <span class="navbar-toggler-icon"></span>
	    </button>
		
		<div class="collapse navbar-collapse" id="collapsibleNavbar">
		  <ul class="navbar-nav h6"> <%-- .h6 는 글자크기임 --%>  
		     <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle text-info" href="#" id="navbarDropdown" data-toggle="dropdown">Home</a> 
		                                     <%-- .text-info 는 글자색으로 청록색임 --%>  
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		           <a class="dropdown-item" href="<%=ctxPath%>/index">Home</a>
		      <%-- <a class="dropdown-item" href="<%=serverName%><%=ctxPath%>/chatting/multichat">웹채팅</a>  --%>
		        </div>
		     </li>
		     
		     <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle text-info" href="#" id="navbarDropdown" data-toggle="dropdown">로그인</a>  
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		           <c:if test="${empty sessionScope.loginuser}">
			           <a class="dropdown-item" href="#">회원가입</a>
			           <a class="dropdown-item" href="<%=ctxPath%>/member/login">로그인</a>
		           </c:if>
		           				
				   <c:if test="${not empty sessionScope.loginuser}">
					   <a class="dropdown-item" href="#">나의정보</a>
					   <a class="dropdown-item" href="<%=ctxPath%>/member/logout">로그아웃</a>
				   </c:if>
		        </div>
		     </li>
		     
		     <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle text-info" href="#" id="navbarDropdown" data-toggle="dropdown">인사관리</a>  
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		           <a class="dropdown-item" href="<%=ctxPath%>/emp/employeeList">직원목록</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/emp/chart">통계차트</a>
		        </div>
		     </li>
		     
  			 <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle text-info" href="#" id="navbarDropdown" data-toggle="dropdown">제품정보</a>  
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		           <a class="dropdown-item" href="#">제품목록</a>
		        </div>
		     </li>
	 	    
		     <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle text-info" href="#" id="navbarDropdown" data-toggle="dropdown">일정관리</a>  
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		           <a class="dropdown-item" href="<%=ctxPath%>/schedule/scheduleManagement">일정관리</a>
		        </div>
		     </li>
		     
		    <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle text-info" href="#" id="navbarDropdown" data-toggle="dropdown">공공데이터</a>  
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		           <a class="dropdown-item" href="<%=ctxPath%>/opendata/seoul_bicycle_rental">서울따릉이지도</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/opendata/seoul_bicycle_rental_insert">오라클입력및조회</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/opendata/korea_tour_api">한국관광공사사진</a>
		        </div>
		    </li>
		     
		    <!-- ==== 인터셉터 알아보기 ====  -->
		    <li class="nav-item dropdown">
		        <a class="nav-link dropdown-toggle text-info" href="#" id="navbarDropdown" data-toggle="dropdown">인터셉터알아보기</a>  
		        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
		           <a class="dropdown-item" href="<%=ctxPath%>/interceptor/anyone/anyone_a">누구나접근_A</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/interceptor/anyone/anyone_b">누구나접근_B</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/interceptor/member_only/member_a">회원누구나접근_A</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/interceptor/member_only/member_b">회원누구나접근_B</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/interceptor/special_member/special_member_a">특정회원만접근_A</a>
		           <a class="dropdown-item" href="<%=ctxPath%>/interceptor/special_member/special_member_b">특정회원만접근_B</a>
		        </div>
		    </li>
		    
		    <!-- ==== (#스프링보안14) Spring Security(스프링 보안) 알아보기 ====  -->
		    
		      
     	 </ul>
       </div>
		
	  <%-- === #49. 로그인이 성공되어지면 로그인되어진 사용자의 이메일 주소를 출력하기 === --%>
	   <c:if test="${not empty sessionScope.loginuser}">
		  <div style="float: right; font-size: 9pt;">
			 <span style="color: navy; font-weight: bold;">${sessionScope.loginuser.email}</span> 님<br>로그인중.. 
		  </div>
	   </c:if>
	
	  <%-- ==== (#스프링보안14) Spring Security(스프링 보안) 알아보기 ==== --%>
	   <c:if test="${not empty sessionScope.sesMemberinfo}">
			<div style="float: right; font-size: 9pt;">
			  <span style="color: navy; font-weight: bold;">${sessionScope.sesMemberinfo.member_id}</span> 님<br>로그인중.. 
			</div>
	   </c:if>
	   	
	</nav>
	<%-- 상단 네비게이션 끝 --%>
	

	<div style="margin: auto; padding: 5px 0 15px 0; width: 80%;">
		
		<%-- 광고 캐러젤 시작--%>
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
    	  <!-- Indicators -->
    	  <ol class="carousel-indicators">
		      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
		      <li data-target="#myCarousel" data-slide-to="1"></li>
	      </ol>

          <!-- Wrapper for slides -->
          <div class="carousel-inner">
		      <div class="carousel-item active">
		         <img src="<%=ctxPath%>/images/advertisement_01.png" alt="붐펫" class="d-block w-100">
		      </div>
		
		      <div class="carousel-item">
		         <img src="<%=ctxPath%>/images/advertisement_02.png" alt="어도비" class="d-block w-100">
		      </div>
    	  </div>

	      <!-- Left and right controls -->
	      <a class="carousel-control-prev" href="#myCarousel" role="button" data-slide="prev">
	         <span class='carousel-control-prev-icon' aria-hidden='true'></span>
	         <span class="sr-only">Previous</span>
	      </a>
	      <a class="carousel-control-next" href="#myCarousel" role="button" data-slide="next">
	         <span class='carousel-control-next-icon' aria-hidden='true'></span>
	         <span class="sr-only">Next</span>
	      </a>
	   </div>
       <%-- 광고 캐러젤 끝--%>
      
	</div>
	    