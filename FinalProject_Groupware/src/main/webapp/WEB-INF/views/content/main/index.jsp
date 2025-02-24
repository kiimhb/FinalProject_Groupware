<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
//     /med-groupware
%>

 <%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/main.css" />
<jsp:include page="../../header/header1.jsp" />

 <div class="main_container">

<div class="box_notice">공지사항</div>
<div class="box_attendance">출퇴근 현황</div>
<div class="box_reservation">오늘 환자 예약 명단</div>
<div class="box_schedule">
<jsp:include page="index_schedule.jsp"/>
	
	

</div>
<div class="box_weather">날씨</div>
<div class="box_payment">전자결재</div>

</div>

<jsp:include page="../../footer/footer1.jsp" />    
    