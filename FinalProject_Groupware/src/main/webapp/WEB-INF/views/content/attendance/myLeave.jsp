<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String ctxPath = request.getContextPath();
//     /myspring
%>

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/attendance/leave.css" />
<jsp:include page="../../header/header1.jsp" />


<div id="sub_mycontent">

	<div class="manag_h3">
		<h3> 근태관리 <휴가관리> </h3>
	</div>
	<div class="sub_leave_count">
	
	
	
	<div class="leaveList">
	
	</div>

		<div>
			<div align="center"
				style="border: solid 0px gray; width: 80%; margin: 20px auto;">${requestScope.pageBar}</div>
		</div>
		
	</div>
</div>
<jsp:include page="../../footer/footer1.jsp" />  