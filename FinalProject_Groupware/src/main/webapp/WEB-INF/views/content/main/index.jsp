<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../header/header1.jsp" /> 

<div style="height: 700px;"><img alt="d" src="<%=ctxPath%>/images/미샤.png" style="width: 1100px;"></div>
<jsp:include page="../../footer/footer1.jsp" />    
    