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
	
	
	// ****** 예약 가능한 시간선택 옵션 시작 ******//
	// 수술실과 날짜를 고려한 수술 가능한 시간 구하기
	$("input#surgery_day, select.room").on("change", function(){
		
		const surgery_room = $("select.room").val(); // 수술실이름
		const surgery_day = $("input#surgery_day").val(); // 수술날짜 
		
		if (surgery_room && surgery_day) {

			$.ajax({
					 url:"<%= ctxPath%>/register/oktime",
					 type: "GET", 
					 data:{"surgeryroom_no":surgery_room, 
						   "surgery_day":surgery_day},
					 dataType: "json",
		    	     success:function(availableTimes){
		    	    	
						let startTime = $("select#surgery_start_time");
						
						startTime.empty(); // 비우기
						startTime.append('<option value="" disabled>시작시간</option>');
						
						availableTimes.forEach(time => {
							startTime.append(`<option value="\${time}">\${time}</option>`);
						});
		    	     },
		  	    	    error: function(request, status, error){
					   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					 }
				}); // end of $.ajax
		}
		
	}); // end of $("select#surgery_surgeryroom_name, input#surgery_day").on("
	
	// 시작 시간이 선택 되어지면 종료시간 선택이 가능하도록 해야됨 (가능한 시간 고려하기) 
	$("select#surgery_start_time").on("change", function(){
		
		const surgery_room = $("select.room").val(); // 수술실이름
		const surgery_day = $("input#surgery_day").val(); // 수술날짜 
		let startTime = $(this).val(); // 시작시간
		let endTimeSelect = $("select#surgery_end_time"); // 종료시간위치
		
		// 기존 예약되어진 일정 가져오기 -> 예약 시간이 있다면 or 예약 시간이 없다면 조건 
		$.ajax({
			url:"<%= ctxPath%>/register/reservedTime",
			type: "POST",
			data:{"surgeryroom_no":surgery_room, 
				  "surgery_day":surgery_day},
		    dataType: "json",
		    success:function(reservedTime) {   	
		    	// console.log("예약된 시간 목록:", reservedTime);
				
				let availableEndTimes = getAvaliableEndTime(startTime, reservedTime); // 종료시간 구하는 함수
				
				endTimeSelect.empty().append('<option value="" disabled>종료시간</option>'); // 종료시간초기화
				
				availableEndTimes.forEach(time => {
					endTimeSelect.append(`<option value="\${time}">\${time}</option>`);
				});
				
				
		    },  error: function(request, status, error){
		   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		}); // end of $.ajax({
	});		
			
			
});

//종료 가능한 시간 선택하기 (동일 시간대 동일 수술실 중복 피하기)
function getAvaliableEndTime(startTime, reservedTime) {
	
	let allTimes = [
        "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
        "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
        "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00"
	]; // 종료 예약이 가능한 모든 시간 출력하기 

	let avaliabledEndTimes = []; // 종료 가능한 시간 담기 배열
	let startIndex = allTimes.indexOf(startTime);
	
	if(startIndex !== -1) {
		let earliestReservedStart = null;
		
		reservedTime.forEach(reserved => {
			
			let reservedStartIndex = allTimes.indexOf(reserved.surgery_start_time);
			
			if(reservedStartIndex > startIndex) {
				if(!earliestReservedStart || reservedStartIndex < earliestReservedStart) {
					earliestReservedStart = reservedStartIndex;
				}
			}
			
		});
		
		if(earliestReservedStart) {
			avaliabledEndTimes = allTimes.slice(startIndex + 1, earliestReservedStart); // 예약된 시간 전까지만 허용
		} else {
			avaliabledEndTimes = allTimes.slice(startIndex + 1); // 예약 없으면 끝까지 가능
		}
	}
	return avaliabledEndTimes;
}
	
	
	
function trlist(order_detail, orderno) {
	
	// alert(order_detail + orderno);
	$("div.detailrecord").html(order_detail);
	
};

// 수술 수정하기 체크박스 체크할 경우
function checkedSurgeryUpdate() {
	
	// ***** 예약일자 (오늘) 입력하기 시작 ***** //
	const today = new Date();
	const year = today.getFullYear();
 	const month = (today.getMonth()+1).toString().padStart(2, '0');
 	const day = today.getDate().toString().padStart(2, '0')
 	
 	const timeString = `\${year}-\${month}-\${day}`
 	// ***** 예약일자 (오늘) 입력하기 끝 ***** //
	
 	// 내가 선택한 행의 정보를 가져오기
 	const clicktr = $(event.target).closest("tr");
 	
	const patient_name = $("td#patient_name").text().trim();	
	const surgery_day = clicktr.find("td#surgery_day").text().trim();
	const surgery_room = clicktr.find("input.room").val();
	const order_surgeryType_name = clicktr.find("td#order_surgeryType_name").text().trim();
		
	$("input.name").val(patient_name); // 환자명
	$("input.department").val(); // 수술부서
	$("select.room").val(surgery_room); // 수술실 이름
	$("input.surgeryday").val(surgery_day); // 수술날짜
	$("select#surgery_start_time").val(""); // 수술 시작시간
	$("select#surgery_end_time").val(""); // 수술 종료시간
	$("input.surgeryupdateday").val(timeString); 
};

// 초기화 클릭한 경우
function surgeryUpdatereset() {
	// alert("초기화누름")
	
	const room = $("input.room").val();
	
	$("select.room").val(room); // 수술실 이름
	$("input.surgeryday").val(""); // 수술날짜
	$("select#surgery_start_time").val(""); // 수술 시작시간
	$("select#surgery_end_time").val(""); // 수술 종료시간
	
};

// 수정 완료하기 
function registerUpdate() {
	
	const checkedRadio = $("input[name='radio']:checked"); // 체크된 체크박스 찾음
 	const clicktr = checkedRadio.closest("tr"); 		   // 내가 선택한 행 찾기
	
 	// 보낼 데이터
	const fk_order_no = clicktr.find("input.orderno").data("id"); // 내가 체크한 orderno
	const surgery_surgeryroom_name = $("select.room").val(); // 수정한 수술실 이름
	const surgery_day = $("input#surgery_day").val(); // 수술할 날짜
	const surgery_start_time = $("select#surgery_start_time").val(); // 수술시작시간
	const surgery_end_time = $("select#surgery_end_time").val(); // 수술시작시간
	
	console.log("fk_order_no"+fk_order_no+"surgery_surgeryroom_name"+surgery_surgeryroom_name+"surgery_day"+surgery_day+"surgery_start_time"+surgery_start_time+"surgery_end_time"+surgery_end_time);
	// surgery_dayundefined surgery_start_timeundefined surgery_end_timeundefined

	$.ajax({
		url:"<%= ctxPath%>/register/surgeryUpdate",
		type: "PATCH",
		data: { "fk_order_no":fk_order_no,
				"surgery_surgeryroom_name":surgery_surgeryroom_name,
				"surgery_day":surgery_day,
				"surgery_start_time":surgery_start_time,
				"surgery_end_time":surgery_end_time },
	    dataType: "json",
	    success:function(json) {  
	    	alert(json.message);
	    	location.reload(true);
	    	
	    },  error: function(request, status, error){
	   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	});
	
}


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
							<td id="patient_name">${requestScope.detail_patient.patient_name}</td>
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
		  			<div class="list ml-3"><a href="">수술예정</a>&nbsp;&nbsp;|</div>
		  			<div class="list">&nbsp;&nbsp;<a href="">과거수술기록</a></div>
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
			  					<th>수술일</th>
			  					<th>수술시간</th>
			  					<th>수술실</th>
			  					<th>수술명</th>
			  					<th>담당의</th>			  			
		  					</tr>
		  				</thead>
					<form name="surgeryUpdateFrm">	
		  				<tbody>
							<c:if test="${not empty requestScope.surgery_list}">
								<c:forEach var="svo" items="${requestScope.surgery_list}">
				  					<tr><input type="hidden" name="fk_order_no" value="${svo.order_no}" />
				  						<td><input type="radio" name="radio" class="orderno" data-id="${svo.order_no}" onclick="checkedSurgeryUpdate()" /></td>
				  						<td id="surgery_day">${svo.surgery_day}</td>
				  						<td><span id="surgery_start_time">${svo.surgery_start_time}</span> ~ <span id="surgery_end_time">${svo.surgery_end_time}</span></td>
										
										<c:choose>
											<c:when test="${svo.surgery_surgeryroom_name eq 1}">
												<td class="surgery_room">roomA</td>
											</c:when>
											<c:when test="${svo.surgery_surgeryroom_name eq 2}">
												<td class="surgery_room">roomB</td>
											</c:when>
											<c:when test="${svo.surgery_surgeryroom_name eq 3}">
												<td class="surgery_room">roomC</td>
											</c:when>
											<c:when test="${svo.surgery_surgeryroom_name eq 4}">
												<td class="surgery_room">roomD</td>
											</c:when>
										</c:choose>
										<input type="hidden" class="room" value="${svo.surgery_surgeryroom_name}" />
				  						<td id="order_surgeryType_name">${svo.order_surgeryType_name}</td>
				  						<td><span id="member_name">${svo.member_name}</span>선생님</td>
				  					</tr>
								</c:forEach>
							</c:if>
							<c:if test="${empty requestScope.surgery_list}">
								<tr>
									<td>${requestScope.surgeryMessage}</td>
								</tr>
							</c:if>
		  				</tbody>
		  			</table>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div class="reservation2 updatefrm">
		  			
				
		  			<div class="input">
		  				<div class="text">환자명</div>
		  				<input type="text" name="patient_name" class="patientinput name" value="" style="background-color:#eee;" disabled/>
		  			</div>
		  			<div class="input">
		  				<div class="text">예약변경일자</div>
		  				<input type="text" name="surgery_reserve_date" class="patientinput surgeryupdateday" value="" style="background-color:#eee;" disabled/>
		  			</div>
		  			<div class="input">
		  				<div class="text">수술실</div>
		  				<select class="room" name="surgery_surgeryroom_name">
			  				<c:forEach var="surgeryvo" items="${requestScope.surgeryroom}">
		  						<option class="room" value="${surgeryvo.surgeryroom_no}">${surgeryvo.surgeryroom_name}</option>
	 						</c:forEach>
		  				</select>
		  			</div>
		  			<div class="input">
		  				<div class="text">수술일자</div>
		  				<input type="date" id="surgery_day" name="surgery_day" class="patientinput surgeryday"/>
		  			</div>
		  			<div class="input">
		  				<div class="text">시작시간 / 종료시간</div>
		  				<select name="surgery_start_time" id="surgery_start_time" class="surgeryStartdate mr-2">
			  					<option value="">시작시간</option>
			  			</select>
			  			<select name="surgery_end_time" id="surgery_end_time" class="surgeryenddate">
		  					<option value="">종료시간</option>
		  				</select>
		  			</div>
		  		</form>	
		  			<div class="button">
  						<button type="button" class="btn" onclick="registerUpdate()">수정하기</button>
	  					<button type="reset" class="btn reset" onclick="surgeryUpdatereset()">초기화</button>
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