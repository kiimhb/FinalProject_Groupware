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



<div style="border:solid 1px red; margin: 0.3% 10%; text-align:center;">
	<span style="font-size:15pt;">진료정보 입력</span>
</div>
<div style="margin: 0% 10%;">	
	<span>소화기내과 백강혁 전문의</span>
</div>
	<div id="patient_info" style="margin: 0% 10%;">
		<table id="patient_info" class="table text-center" style="background-color:#b3d6d2; margin:0.1%;"> <%-- width: 69.5%; position:fixed --%>
			<thead>
				<tr>
					<th style="border:solid 1px black">오더번호</th>
					<th style="border:solid 1px black">환자성함</th>
					<th style="border:solid 1px black">환자성별</th>
					<th style="border:solid 1px black">환자나이(만)</th>
					<th style="border:solid 1px black">초진재진</th>				
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="border:solid 1px black">A12345</td>
					<td style="border:solid 1px black">이순신</td>
					<td style="border:solid 1px black">남</td>
					<td style="border:solid 1px black">42세</td>
					<td style="border:solid 1px black">재진</td>
				</tr>
			</tbody>
		</table>
	</div>
<div id="container" style="width:100%;">	
	<div id="orderEnter" style="margin:0% 10%; border:solid 1px green; height:570px; overflow-y:scroll;">		
		<div style="display:flex; justify-content:center; border:solid 1px orange;">
			<div style="border:solid 1px purple; margin:auto; width:33%; text-align:center">
				<span>진료내역</span>
			</div>
			<div style="border:solid 1px purple; margin:auto; width:33%; text-align:center">
				<span>증상</span>
			</div>
			<div style="border:solid 1px purple; margin:auto; width:33%; text-align:center">
				<span>캘린더</span>
			</div>
		</div>
		
		<div style="display:inline-block; width:100%;">
			<div style="margin: 0% 0.17%; float:left; border:solid 1px black; width:33%; height:450px; overflow:auto;">
			
				<li style="list-style-type: none; margin: 5% 0%;">
				<a href="#" class="menu-toggle"> 
					<span style="margin:5% 3% ;">이순신</span> 
					<span>2025/01/02 (7일전)</span> <i class="fa-solid fa-chevron-down"></i>
				</a>
			         <div class="submenu">
			            <a class="dropdown-item" href="">각종</a> 
			            <a class="dropdown-item" href="">질환과</a> 
			            <a class="dropdown-item" href="">질병</a>
			         </div>
		         </li>
		         
		        <li style="list-style-type: none; margin: 5% 0%;">
				<a href="#" class="menu-toggle"> 
					<span style="margin:5% 3% ;">이순신</span>
					<span>2024/12/28 (10일전)</span> <i class="fa-solid fa-chevron-down"></i>
				</a>
			         <div class="submenu">
			            <a class="dropdown-item" href="">각종</a> 
			            <a class="dropdown-item" href="">질환과</a> 
			            <a class="dropdown-item" href="">질병</a>
			         </div>
		         </li>
		         
		         <li style="list-style-type: none; margin: 5% 0%;">
				<a href="#" class="menu-toggle"> 
					<span style="margin:5% 3% ;">이순신</span>
					<span>2024/12/15 (15일전)</span> <i class="fa-solid fa-chevron-down"></i>
				</a>
			         <div class="submenu">
			            <a class="dropdown-item" href="">각종</a> 
			            <a class="dropdown-item" href="">질환과</a> 
			            <a class="dropdown-item" href="">질병</a>
			         </div>
		         </li>
		         <li style="list-style-type: none; margin: 5% 0%;">
				<a href="#" class="menu-toggle"> 
					<span style="margin:5% 3% ;">이순신</span>
					<span>2024/12/15 (15일전)</span> <i class="fa-solid fa-chevron-down"></i>
				</a>
			         <div class="submenu">
			            <a class="dropdown-item" href="">각종</a> 
			            <a class="dropdown-item" href="">질환과</a> 
			            <a class="dropdown-item" href="">질병</a>
			         </div>
		         </li>
					
			</div>
			
			<div style="margin: 0% 0.17%; float:left; border:solid 1px blue; width:33%; height:300px;">
				<textarea style="width: 100%; height:300px; resize:none;">접수시 간단증상</textarea>	
			</div>
			
			<div style="margin: 0% 0.16%; float:right; border:solid 1px green; width:33%; height:300px;">
				<div style="height:300px;">달력</div>
				<div style="float:right; margin-top:1%;">
					<button>수술 지시</button>
					<button>입원 지시</button>	
				</div>		
			</div>
		</div>
		
		<div id="orderNpay" style="height:630px; border:solid 1px red;">
		
			<div id="orderSearch" style="margin:1% 0.1%;">
				<span>오더 검색</span>
				<input type="text" style="width: 600px; border: none; border-bottom: 1px solid black;"></input>
			</div>
			<div style="border:solid 1px red; height:150px; margin:0% 0.1%;">
							
			
			</div>
			
			<div id="medicineSearch" style="border:solid 1px black; height:150px;">
				<span>오더 검색</span>
				<input type="text" style="width: 600px; border: none; border-bottom: 1px solid black;"></input>
			</div>
		
		
		</div>
		
	</div> <%-- end of orderEnter --%>
	
</div>











<jsp:include page="../../footer/footer1.jsp" /> 