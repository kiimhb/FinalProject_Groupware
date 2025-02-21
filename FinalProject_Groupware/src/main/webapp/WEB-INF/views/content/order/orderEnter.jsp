<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>

<%
	String firstPatient_no = request.getParameter("firstPatient_no");
%>


<jsp:include page="../../header/header1.jsp" />

<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>


<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>


<script type="text/javascript">


$(document).ready(function(){  

	
	var calendarEl = document.getElementById('calendar'); //
	
	var calendar = new FullCalendar.Calendar(calendarEl, {
		
		initialView: 'dayGridMonth',
        locale: 'ko',
        selectable: true,
	    editable: false,
	    headerToolbar: {
	    	start: 'title', // will normally be on the left. if RTL, will be on the right
	    	center: '',
	    	end: 'today prev,next'
	    },
	    dayMaxEventRows: true, // for all non-TimeGrid views
	    views: {
	      timeGrid: {
	        dayMaxEventRows: 3 // adjust to 6 only for timeGridWeek/timeGridDay
	      }
	    },
     	dateClick: function(info) {
      	 	// alert('클릭한 Date: ' + info.dateStr); // 클릭한 Date: 2021-11-20
      	    $(".fc-day").css('background','none'); // 현재 날짜 배경색 없애기
      	    info.dayEl.style.backgroundColor = '#b1b8cd'; // 클릭한 날짜의 배경색 지정하기
      	    $("form > input[name=chooseDate]").val(info.dateStr);
      	    
      	    alert("날짜 클릭");
      	  }
	});
	/* 캘린더 띄움 끝 */
	
	calendar.render();  // 풀캘린더 보여주기
	
	

	document.getElementById("readyToSymptomDetail").addEventListener("click", function() {
	    this.value = "";
	});

	
});



function clickOrderList(){
	
	alert(${requestScope.clickpatient.patient_no});
	
	$.ajax({
		  url:"<%= ctxPath%>/order/clickOrderRecord",
		  data:{"clickPatient_no":"${requestScope.clickpatient.patient_no}"},
		  dataType:"json",
		  success:function(json){
			  console.log(JSON.stringify(json));
		  },
		  error: function(request, status, error){
		      alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		  }
	});
	
	
}

</script>

<style type="text/css">
/* ========== full calendar css 시작 ========== */


a, a:hover, .fc-daygrid {
    color: #000;
    text-decoration: none;
    background-color: transparent;
    cursor: pointer;
} 

.fc-sat { color: #0000FF; }    /* 토요일 */
.fc-sun { color: #FF0000; }    /* 일요일 */
/* ========== full calendar css 끝 ========== */

ul{
	list-style: none;
}

button.btn_normal{
	background-color: #990000;
	border: none;
	color: white;
	width: 50px;
	height: 30px;
	font-size: 12pt;
	padding: 3px 0px;
	border-radius: 10%;
}

button.btn_edit{
	border: none;
	background-color: #fff;
}
</style>



<div style="border:solid 1px red; margin: 0.3% 10%; text-align:center;">
	<span style="font-size:15pt;">진료정보 입력</span>
</div>

<div style="margin: 0% 10%;">	
	<span>${sessionScope.loginuser.member_name}&nbsp;님&nbsp;&nbsp;${sessionScope.loginuser.child_dept_name}&nbsp;&nbsp;${sessionScope.loginuser.member_position}</span>
</div>


	<div id="patient_info" style="margin: 0% 10%;">
		<table id="patient_info" class="table text-center" style="background-color:#b3d6d2; margin:0.1%;"> <%-- width: 69.5%; position:fixed --%>
			<thead>
				<tr>
					<th style="border:solid 1px black">성함</th>
					<th style="border:solid 1px black">성별</th>
					<th style="border:solid 1px black">나이(만)</th>
					<th style="border:solid 1px black">내역</th>				
				</tr>
			</thead>
			<c:if test="${not empty requestScope.firstPatient}">
				<tbody>
					<tr>
						<td style="border:solid 1px black">${firstPatient.patient_name}</td>
						<td style="border:solid 1px black">${firstPatient.patient_gender}</td>
						<td style="border:solid 1px black">${firstPatient.age}세</td>
						<td style="border:solid 1px black">${firstPatient.jin}</td>
					</tr>
				</tbody>
			</c:if>
			<c:if test="${not empty requestScope.clickPatient}">
				<tbody>
					<tr>
						<td style="border:solid 1px black">${clickPatient.patient_name}</td>
						<td style="border:solid 1px black">${clickPatient.patient_gender}</td>
						<td style="border:solid 1px black">${clickPatient.age}세</td>
						<td style="border:solid 1px black">${clickPatient.jin}</td>						
					</tr>					
				</tbody>				
			</c:if>			
		</table>
	</div>
	
	
	
	
<div id="container" style="width:100%;">	
	<div id="enterContainer" style="margin:0% 10%; border:solid 1px green; height:570px; overflow-y:scroll;">
		<form name="orderEnter">		
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
					
					<c:if test="${not empty requestScope.orderList}">
						<c:forEach var="orderList" items="${requestScope.orderList}">
							<li style="list-style-type: none; margin: 5% 0%;">										
							<a href="#" class="menu-toggle"> 
								<span style="margin:5% 3% ;">${orderList.patient_name}</span> 
								<span>${orderList.order_createTime}&nbsp;&nbsp;${orderList.timediff}&nbsp;&nbsp;${orderList.child_dept_name}</span> <i class="fa-solid fa-chevron-down"></i>
							</a>
						         <div class="submenu">
						         	<a class="dropdown-item" href="">${orderList.order_symptom_detail}</a>
						            <a class="dropdown-item" href="">${orderList.order_desease_name}</a> 						            
						            <c:if test="${not empty orderList.order_surgeryType_name}">
						            	<a class="dropdown-item" href="">${orderList.order_surgeryType_name}</a>
						            </c:if>
						            <c:if test="${orderList.order_ishosp eq 1}">
						            	<a class="dropdown-item" href="">${orderList.order_howlonghosp}일 입원</a>
						            </c:if>
						         </div>
					         </li>
				         </c:forEach>
			         </c:if>
				
				</div>
				
				<div style="margin: 0% 0.17%; float:left; width:33%; height:385px;">
					<textarea id="readyToSymptomDetail" style="width: 100%; height:385px; padding:4% 4%; resize:none;">${clickPatient.patient_symptom}</textarea>	
				</div>
				
				<div style="margin: 0% 0.16%; border:solid 1px black; float:right; width:33%; height:385px;">
					<div id="calendar" style=""></div>
					<div style="float:right; margin-top:1%;">
						<button>수술 지시</button>
						<button>입원 지시</button>	
					</div>		
				</div>
			</div>
			
			<div id="orderNpay" style="height:630px; border:solid 1px red;">
			
				<div id="orderSearch" style="margin:1% 1%;">
					<span>오더 검색</span>
					<input type="text" style="width: 585px; border: none; border-bottom: 1px solid black;"></input>
					<button>돋보기</button>
				</div>
				<div style="border:solid 1px red; height:150px; margin:0% 0.1%;">
					
				</div>
							
				
				<div id="medicineSearch" style="margin:1% 1%;">
					<span>약 검색</span>
					<input type="text" style="width: 600px; border: none; border-bottom: 1px solid black;"></input>
					<button>돋보기</button>
				</div>
				<div style="border:solid 1px red; height:100px; margin:0% 0.1%;">
					<span>트리메부틴 말레산염</span> &nbsp;&nbsp;&nbsp;
					<button type="button" class="btn btn-light ml-1">아침</button>
					<button type="button" class="btn btn-light ml-1">점심</button>
					<button type="button" class="btn btn-light ml-1">저녁</button>
					
					
					<label for="before">식전</label>
					<input type="radio" name="beforeafter" value="식전" id="before" />
					<label for="after" >식후</label>
					<input type="radio" name="beforeafter" value="식후" id="after" />
					
					
					
					<button type="button" style="float:right;">등록</button>
				</div>
				
				<div id="pay" style="margin:1% 0.1%; border:solid 1px blue; height:150px;">
					<span style="margin:1% 0.1%;">수납 내역</span>
					<div class="row">
					    <div class="col-md-4" style="text-align:center;">감기약</div>
					    <div class="col-md-4 offset-md-4" style="text-align:center;">20000원</div>
					</div>
					<div class="row">
					    <div class="col-md-4" style="text-align:center;">타이레놀</div>
					    <div class="col-md-4 offset-md-4" style="text-align:center;">10000원</div>
					</div>				
					<div class="row">
					    <div class="col-md-4" style="">총액</div>
					    <div class="col-md-4 offset-md-4" style="text-align:center;">30000원</div>
					</div>
				</div>
			</div>
		</form>			
	</div> <%-- end of orderEnter --%>
</div>











<jsp:include page="../../footer/footer1.jsp" /> 