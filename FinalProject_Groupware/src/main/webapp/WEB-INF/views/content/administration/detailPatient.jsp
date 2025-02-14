<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/detailPatient.css" />

<jsp:include page="../../header/header1.jsp" /> 

<style type="text/css">
/* 캘린더 헤더 */
.fc-header-toolbar { 
	height: 30px;
}
/* 캘린더 글자색 */
a, 
a:hover, 
.fc-daygrid {
    color: #000;
    text-decoration: none;
    background-color: transparent;
    cursor: pointer;
} 

/* 주말 날짜 색 */
.fc-day-sun a {
  color: red;
  text-decoration: none;
}
.fc-day-sat a {
  color: blue;
  text-decoration: none;
}

#fc-dom-1 {
	font-size: 16pt;
	padding-left: 4%;
	border-left: 5px solid #006769;	
	width:300px;
}
.fc-button {
	font-size: 10pt !important;
	background-color: #4c4d4f !important;
	border: none !important; 
}
</style>


<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>


<script type="text/javascript">
$(document).ready(function(){  
	
	var calendarEl = document.getElementById('calendar'); // div#calendar 위치 (보여줄 위치임)
	
	/* 캘린더 띄움 시작 */
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
	 	// 풀캘린더에서 날짜 클릭할 때 발생하는 이벤트(일정에 대한 간단한 설명문 보여줌)
     	dateClick: function(info) {
      	 	// alert('클릭한 Date: ' + info.dateStr); // 클릭한 Date: 2021-11-20
      	    $(".fc-day").css('background','none'); // 현재 날짜 배경색 없애기
      	    info.dayEl.style.backgroundColor = '#b1b8cd'; // 클릭한 날짜의 배경색 지정하기
      	    $("form > input[name=chooseDate]").val(info.dateStr);
      	    
      	    alert("상세일정내용");
      	  }
	});
	/* 캘린더 띄움 끝 */
	
	calendar.render();  // 풀캘린더 보여주기
	
});

function trlist(order_detail, orderno) {
	
	// alert(order_detail + orderno);
	$("div.detailrecord").html(order_detail);
		
};


</script>
	
      <div class="header">
		
	  		<div class="title">
	  			환자상세조회
	  		</div>	
	  		<div class="info">
				<table class="table table-bordered chart">
					<thead class="charthead">
						<tr>
							<th>차트번호</th>
							<th>이름</th>
							<th>성별</th>
							<th>나이</th>
							<th>초진 / 재진</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>${requestScope.detail_patient.order_no}</td>
							<td>${requestScope.detail_patient.patient_name}</td>
							<td>${requestScope.detail_patient.patient_gender}</td>
							<td>${requestScope.detail_patient.age}</td>
							<c:choose>
								<c:when test="${requestScope.detail_patient.patient_status eq 0}">
									<td>초진</td>
								</c:when>
								<c:when test="${requestScope.detail_patient.patient_status eq 0}">
									<td>재진</td>
								</c:when>
							</c:choose>
						</tr>
					</tbody>
				
				</table>
	  		</div>

	  </div>
	  
	  <div class="content">
	  	
	  	<div class="left">
	  		<div class="detail_title">
	  			진료내역
	  		</div>

	  		<div class="recordList">
	  			<table class="table recordtable table-hover">
	  				<thead>
	  					<tr>
	  						<th>내원일</th>
	  						<th>진료명</th>
	  						<th>진료과</th>	
	  					</tr>
	  				</thead>
	  				<tbody>
						<c:forEach var="pvo" items="${requestScope.order_list}">
		  					<tr class="trlist" data-id="${pvo.order_no}" onclick="trlist('${pvo.order_symptom_detail}',${pvo.order_no})">
		  						<td>${pvo.patient_visitdate}</td>
								<td>${pvo.patient_symptom}</td>
		  						<td>${pvo.child_dept_name}</td>
		  					</tr>
						</c:forEach>
	  				</tbody>
	  			</table>
	  		</div>
	  		
  			<div class="detailrecord">
  				
  			</div>
	  	</div>
  		<div style="width:20px;"></div>
	  	<div class="right">
	  		<div id="calendar">
	  			
	  		</div>
	  		
	  	</div>

	  </div>
	  
	  <div class="reservation">
	  
	  	<!-- 수술관리 -->
	  	<!-- first 시작  -->
	  	<div class="first">
	  		
	  		<div class="top">
		  		<div class="menu" style="width:50%;">
		  			<div class="detail_title">예약 수술 관리</div>
		  			<div class="list ml-3">수술예정&nbsp;&nbsp;|</div>
		  			<div class="list">&nbsp;&nbsp;과거수술기록</div>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div style="width:50%;">
	  				<div class="detail_title">수술 수정</div>
	  			</div>
	  		</div>
	  	
	  		<div class="bottom">
	  		
		  		<div class="reservation2">
		  			<table class="table">
		  				<thead >
		  					<tr>
			  					<th>선택</th>
			  					<th>수술일자</th>
			  					<th>수술부서</th>
			  					<th>수술실</th>
			  					<th>수술명</th>
			  					<th>담당의</th>			  			
		  					</tr>
		  				</thead>
		  				<tbody>
		  					<tr>
		  						<td><input type="checkbox"/></td>
		  						<td>2025-03-03 17:00</td>
		  						<td>호흡기내과</td>
		  						<td>Room C</td>
		  						<td>맹장수술</td>
		  						<td>김홍비 의사</td>
		  					</tr>
		  				</tbody>
		  			</table>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div class="reservation2 updatefrm">
		  		
		  			<div class="input">
		  				<div class="text">이름</div>
		  				<input type="text" class="patientinput" />
		  			</div>
		  			<div class="input">
		  				<div class="text">수술부서</div>
		  				<input type="text" class="patientinput" />
		  			</div>
		  			<div class="input">
		  				<div class="text">수술실</div>
		  				<input type="text" class="patientinput" />
		  			</div>
		  			<div class="input">
		  				<div class="text">수술일</div>
		  				<input type="text" class="patientinput date mr-2" />
		  				<input type="text" class="patientinput date" />
		  			</div>
		  			<div class="input">
		  				<div class="text">담당의</div>
		  				<input type="text" class="patientinput" />
		  			</div>
		  			<div class="button">
  						<button type="button" class="btn">수정하기</button>
	  					<button type="reset" class="btn reset">초기화</button>
		  			</div>

		  		</div>
	  		</div>
	  		
	  	</div> 	
	  	<!-- first 끝  -->
	  	
	  	<!-- 입원관리 -->
	  	<!-- second 시작  -->
	  	<div class="second">
	  		
		  		<div class="top">
		  		<div class="menu" style="width:50%;">
		  			<div class="detail_title">예약 입원 관리</div>
		  			<div class="list ml-3">입원예정 |</div>
		  			<div class="list">&nbsp;과거입원기록</div>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div style="width:50%;">
	  				<div class="detail_title">입원 수정</div>
	  			</div>
	  		</div>
	  	
	  		<div class="bottom">
	  		
		  		<div class="reservation2">
		  			<table class="table">
		  				<thead>
		  					<tr>
			  					<th>선택</th>
			  					<th>입원일자</th>
			  					<th>퇴원일자</th>
			  					<th>입원실</th>
			  					<th>담당간호사</th>			  			
		  					</tr>
		  				</thead>
		  				<tbody>
		  					<tr>
		  						<td><input type="checkbox"/></td>
		  						<td>2025-03-03</td>
		  						<td>2025-03-04</td>
		  						<td>1001호</td>
		  						<td>신가은</td>
		  					</tr>
		  				</tbody>
		  			</table>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div class="reservation2 updatefrm">
		  		
		  			<div class="input">
		  				<div class="text">이름</div>
		  				<input type="text" class="patientinput" />
		  			</div>
		  			<div class="input">
		  				<div class="text">입원실</div>
		  				<input type="text" class="patientinput" />
		  			</div>
		  			<div class="input">
		  				<div class="text">입원일자</div>
		  				<input type="text" class="patientinput" />
		  			</div>
		  			<div class="input">
		  				<div class="text">퇴원일자</div>
		  				<input type="text" class="patientinput date mr-2" />
		  				<input type="text" class="patientinput date" />
		  			</div>
		  			<div class="button btn2">
  						<button type="button" class="btn">수정하기</button>
	  					<button type="reset" class="btn reset">초기화</button>
		  			</div>
		  		</div>
	  	</div>
  	</div>
  	<!-- second 끝  -->
  	
  	
  	</div>
  	
  	<div class="backbtn">
  		<button type="button" class="btn back" onclick="history.back();">목록으로</button>
  	</div>

		

<jsp:include page="../../footer/footer1.jsp" />   