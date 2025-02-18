<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>



<jsp:include page="../../header/header1.jsp" />

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>


<div style="font-size:28pt; text-align:center; border:solid 1px red; margin: 4% 10%; background-color:#b3d6d2;"><span>진료대기환자</span></div>


<div style="border:solid 1px blue;">	
	<div style="border:solid 1px green; margin:0 10% 2% 10%;"class="">
		<table class="table text-center" id="patientWaiting">
				<tr>
					<th style="border:solid 1px black">이름</th>
					<th style="border:solid 1px black">성별</th>
					<th style="border:solid 1px black">나이</th>
					<th style="border:solid 1px black">진료구분</th>
					<th style="border:solid 1px black">증상</th>				
				</tr>
			<c:forEach var="pvo" items="${requestScope.patientList}">
			<a style="cursor:pointer; "href="#"></a>
				<tr>
					<td>${pvo.patient_name}</td>
					<td>${pvo.patient_gender}</td>
					<td>${pvo.patient_jubun}</td>
					<td>${pvo.child_dept_name}</td>
					<td>${pvo.patient_symptom}</td>				
				</tr>
			</c:forEach>
					
		</table>
	
		<%-- 페이지바 === --%>
	    <div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
			
		
	</div>
</div>












<jsp:include page="../../footer/footer1.jsp" /> 