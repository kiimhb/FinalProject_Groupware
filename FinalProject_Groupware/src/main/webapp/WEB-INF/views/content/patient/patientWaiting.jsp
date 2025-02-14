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


<div style="font-size:28pt; text-align:center; border:solid 1px red; margin: 4% 20%; background-color:#b3d6d2;"><span>진료대기환자</span></div>


<div style="border:solid 1px blue;">	
	<div style="border:solid 1px green; margin:0 20% 2% 20%;"class="">
		<table class="table text-center" id="patientWaiting">
			<tr>
				<th style="border:solid 1px black">이름</th>
				<th style="border:solid 1px black">성별</th>
				<th style="border:solid 1px black">나이</th>
				<th style="border:solid 1px black">진료구분</th>
				<th style="border:solid 1px black">증상</th>				
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>		
			</tr>
			
			
		</table>
	
	</div>
</div>












<jsp:include page="../../footer/footer1.jsp" /> 