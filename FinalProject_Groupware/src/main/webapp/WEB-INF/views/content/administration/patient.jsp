<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />

<jsp:include page="../../header/header1.jsp" /> 

	<div>
		환자 조회 페이지 입니다. 
	</div>


<jsp:include page="../../footer/footer1.jsp" />   