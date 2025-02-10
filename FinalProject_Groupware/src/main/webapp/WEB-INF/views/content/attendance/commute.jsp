<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/attendance/commute.css" />

<jsp:include page="../../header/header1.jsp" /> 

	<div class="content">
		<div class="header">
			헤더입니다.
		</div>
		<div class="time">
			타이머입니다.
		</div>
		<div class="view">
			자료입니다.
		</div>
	</div>

<jsp:include page="../../footer/footer1.jsp" />   