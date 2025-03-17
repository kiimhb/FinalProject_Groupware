<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/detailPatient.css" />
<meta name="viewport" content="width=device-width, initial-scale=1">

<jsp:include page="../../header/header1.jsp" /> 

<style type="text/css">
/* 캘린더 헤더 */
.fc-header-toolbar { 
	height: 30px;
}
div.fc-daygrid-day-bottom > a {
	color: white;
	height:20px;
	background-color: #509d9c;
	line-height: 22px;
	border-radius:3px;
	display: flex;
	padding-left: 5%;
}
/* 캘린더 평일 */
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

	// 오늘 이전은 선택 불가능하도록 설정하기
 	let todayDate = new Date().toISOString().split("T")[0]; // 현재 날짜를 YYYY-MM-DD 형식으로 변환
    $("input[type='date']").attr("min", todayDate); // input 요소의 min 속성 설정
	
	
	var calendar;

	if (calendar) {
        calendar.destroy(); // 이전 캘린더 인스턴스 삭제
    }
	
	var calendarEl = document.getElementById('calendar'); // div#calendar 위치 (보여줄 위치임)

	/* 캘린더 띄움 시작 */
	calendar = new FullCalendar.Calendar(calendarEl, {
		
		initialView: 'dayGridMonth',
        locale: 'ko',
        selectable: true,
	    editable: false,
	    headerToolbar: {
	    	start: 'title', // will normally be on the left. if RTL, will be on the right
	    	center: '',
	    	end: 'today prev,next'
	    },
		displayEventTime: false,
		dayMaxEventRows: 2, // 기본적으로 모든 이벤트는 제한 없음
		views: {
	      timeGrid: {
	        dayMaxEventRows: 2 
	      }
	    },
	    // ===================== DB 와 연동하는 법 시작 ===================== //
	    events:function(info, successCallback, failureCallback) {

	    	 $.ajax({
	    		 url: '<%= ctxPath%>/patient/selectSchedule',
                 data:{"patient_no":$("input[name='patient_no']").val()},
                 dataType: "json",
                 success:function(json) {
										 
                	 // console.log(JSON.stringify(json));

                	 var events = [];

                	 // 가져온 데이터를 FullCalendar의 events 배열 형식으로 변환
                     json.forEach(function(item) {

						 let surgery_surgeryroom_name = "";
											                     	 
	                 	 if(item.surgery_surgeryroom_name == 1) {
	                 		 surgery_surgeryroom_name = "RoomA";
	                 	 }
	                 	 else if(item.surgery_surgeryroom_name == 2) {
	                 		 surgery_surgeryroom_name = "RoomB";
	                 	 }
	                 	 else if(item.surgery_surgeryroom_name == 3) {
	                 		 surgery_surgeryroom_name = "RoomC";
	                 	 }
	                 	 else {
	                 		 surgery_surgeryroom_name = "RoomD";
	                 	 }
						                	 

                         if (item.hospitalize_start_day && item.hospitalize_end_day) {
                             events.push({
								title: item.fk_hospitalizeroom_no + "호",
                                start: item.hospitalize_start_day,
                                end: item.hospitalize_end_day,
								color: "lightblue"
                             });
                         }
                         
                         if (item.order_createTime) {
                             events.push({
                                 title: "진료",
                                 start: item.order_createTime,
                                 color: "lightgreen"
                             });
                         }
						 
						 if (item.surgery_day && item.surgery_start_time && item.surgery_surgeryroom_name && item.surgery_end_time) {
                         	  var startDateTime = item.surgery_day + "T" + item.surgery_start_time;  // "2025-03-18T11:30:00"
                              var endDateTime = item.surgery_day + "T" + item.surgery_end_time;  // "2025-03-18T15:00:00"	 
 							  // console.log("수술일정들어옴" + item.surgery_surgeryroom_name + ' (' + item.surgery_start_time.substring(0,5) + ' - ' + item.surgery_end_time.substring(0,5) + ')');
                              events.push({
                                  title: '수술 ' + '(' + item.surgery_start_time.substring(0,5) + ')',
                                  start: startDateTime,
                                  end: endDateTime,
                                  color: "lightcoral"
                              });
                          }
						  
                     });
                    	successCallback(events); 
	    	 		},
			    	error: function(request, status, error){
			            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				    }	
	    	 }); // end of  $.ajax
	    },
		eventContent: function(info) {
			var customTitle = info.event.title;  // title은 이미 수술실 이름만 들어가 있음

		    return {
		        html: '<div style="background-color: #509d9c; color: white; padding: 3px 3px; border-radius: 5px; font-size:8pt; width:100%; white-space: nowrap; overflow: hidden; word-wrap: break-word;">'
		                   + customTitle +
		               '</div>'
		    };
		},
	    // ===================== DB 와 연동하는 법 끝 ===================== //
	 	// 풀캘린더에서 날짜 클릭할 때 발생하는 이벤트(일정에 대한 간단한 설명문 보여줌)
     	dateClick: function(info) {
      	 	// alert('클릭한 Date: ' + info.dateStr); // 클릭한 Date: 2021-11-20
      	    $(".fc-day").css('background','none'); // 현재 날짜 배경색 없애기
      	    info.dayEl.style.backgroundColor = '#b1b8cd'; // 클릭한 날짜의 배경색 지정하기
      	    $("form > input[name=chooseDate]").val(info.dateStr);
      	    
      	    // alert("상세일정내용");
      	  }
	});
	/* 캘린더 띄움 끝 */
	
	calendar.render();	
	
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
			
	// 퇴원일 자동 입력하기
	$("input[name='hospitalize_start_day']").on("change", function(e){
		// alert("수정")
		const start_day = $(e.target).val(); // 시작날짜 
		
		const order_howlonghosp = $("input.order_howlonghosp").data("id"); // 입원일수
		
		var endDate = new Date(start_day);
		endDate.setDate(endDate.getDate() + parseInt(order_howlonghosp));
		
		const year = endDate.getFullYear();
	 	const month = (endDate.getMonth()+1).toString().padStart(2, '0');
	 	const day = endDate.getDate().toString().padStart(2, '0');
		
	 	const hospitalize_end_day = `\${year}-\${month}-\${day}`;
	 	
	 	$("input[name='hospitalize_end_day']").val(hospitalize_end_day); // 입원 일수에 따라 종료날짜 자동입력
	});

	
	// 시작일 변경되면 함수 시작 -> 입원시작일과 입원종료일을 고려한 입원실 잔여석 알아오기 
	$("input[name='hospitalize_start_day'").on("change", function(){
		
			const order_no = $("input[name='fk_order_no']").val();
			const hospitalize_start_day = $("input[name='hospitalize_start_day']").val(); // 입원일자 
			const hospitalize_end_day = $("input[name='hospitalize_end_day']").val(); // 퇴원일자 
			
			// console.log(hospitalize_start_day + hospitalize_end_day);
			
			if(hospitalize_start_day && hospitalize_end_day) {
				
					$.ajax({
						url:"<%= ctxPath%>/register/okroom",
						type: "GET", 
						data:{"hospitalize_start_day":hospitalize_start_day,
								  "hospitalize_end_day":hospitalize_end_day},
				        dataType: "json",
						success:function(okSeat){		 
								// alert(JSON.stringify(okSeat)); 
								
								const roomSelect = $("select.hospitalizeroom_no");
								roomSelect.empty(); // 기존 옵션 초기
								
								let html = ``;
								
								// 2인실 
							    let tworoom = okSeat.filter(room => room.hospitalizeroom_capacity == 2);
								if(tworoom.length > 0) {
									html += `<optgroup label="2인실">`;
										tworoom.forEach(room => {
											let disabled = room.ok_seat == 0 ? 'disabled' : ''; // 잔여자리 없으면 disabled 추가 
											html += `<option value="\${room.hospitalizeroom_no}" \${disabled}>\${room.hospitalizeroom_no}호 ( \${room.ok_seat} / \${room.hospitalizeroom_capacity} )</option>`;
										});
										html += `</optgroup>`;
								}
								
								// 4인실 
							    let fourroom = okSeat.filter(room => room.hospitalizeroom_capacity == 4);
								if(fourroom.length > 0) {
									html += `<optgroup label="4인실">`;
										fourroom.forEach(room => {
											let disabled = room.ok_seat == 0 ? 'disabled' : ''; // 잔여자리 없으면 disabled 추가 
											html += `<option value="\${room.hospitalizeroom_no}" \${disabled}>\${room.hospitalizeroom_no}호 ( \${room.ok_seat} / \${room.hospitalizeroom_capacity} )</option>`;
										});
										html += `</optgroup>`;
								}

								roomSelect.append(html);		
						},
		  	    	    error: function(request, status, error){
					   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					    }
						
			});
		}	
	}); // end of $("input[name='hospitalize_start_day'").on("change", function(){
	
			
}); //end of ready 

// 종료 가능한 시간 선택하기 (동일 시간대 동일 수술실 중복 피하기)
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
	
	
// 진료상세설명 보여주기
function trlist(order_detail, orderno) {

	if(order_detail == "") {
		$("div.detailrecord").html("진료 설명이 없습니다.").css("color","gray");
	} else {
		$("div.detailrecord").html(order_detail).css("color","black");
		
	}

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

// 입원 수정하기 체크박스 클릭 
function checkedHospitalizeUpdate() {
	
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
		const fk_hospitalizeroom_no = clicktr.find("td.fk_hospitalizeroom_no").data("id");
		const hospitalize_start_day = clicktr.find("td.hospitalize_start_day").text().trim();
		const hospitalize_end_day = clicktr.find("td.hospitalize_end_day").text().trim();
	
		$("input[name='patient_name']").val(patient_name);
		$("input[name='hospitalize_reserve_date']").val(timeString);
		$("input[name='hospitalize_start_day']").val(hospitalize_start_day);
		$("input[name='hospitalize_end_day']").val(hospitalize_end_day);
		$("select.hospitalizeroom_no").val("");
}


// 초기화 클릭한 경우
function reset() {
	// alert("초기화누름")
	const room = $("input.room").val();
	
	$("select.room").val(room); // 수술실 이름
	$("input.surgeryday").val(""); // 수술날짜
	$("select#surgery_start_time").val(""); // 수술 시작시간
	$("select#surgery_end_time").val(""); // 수술 종료시간
	
};

// 수술 수정 완료하기 
function registerUpdate() {
	
	const checkedRadio = $("input[name='radio']:checked"); // 체크된 체크박스 찾음
 	const clicktr = checkedRadio.closest("tr"); 		   // 내가 선택한 행 찾기
	
 	// 보낼 데이터
	const fk_order_no = clicktr.find("input.orderno").data("id"); // 내가 체크한 orderno
	const surgery_surgeryroom_name = $("select.room").val(); // 수정한 수술실 이름
	const surgery_day = $("input#surgery_day").val(); // 수술할 날짜
	const surgery_start_time = $("select#surgery_start_time").val(); // 수술시작시간
	const surgery_end_time = $("select#surgery_end_time").val(); // 수술시작시간
	const jubun = $("input[name='jubun']").val();
	
	$.ajax({
		url:"<%= ctxPath%>/register/surgeryUpdate",
		type: "PATCH",
		data: { "fk_order_no":fk_order_no,
				"surgery_surgeryroom_name":surgery_surgeryroom_name,
				"surgery_day":surgery_day,
				"surgery_start_time":surgery_start_time,
				"surgery_end_time":surgery_end_time,
				"jubun":jubun},
	    dataType: "json",
	    success:function(response) {  
	    	alert(response.message);
	    	location.reload(true);
	    	
		},error: function(error){
			let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
	   		alert(errorMessage);
	 	}
	});
	
}

// 입원 수정하기 
function hospitalizeUpdate() {
	
	const checkedRadio = $("input[name='radio2']:checked"); // 체크된 체크박스 찾음
 	const clicktr = checkedRadio.closest("tr"); 		    // 내가 선택한 행 찾기
	
	// 보낼 데이터
	const fk_order_no = clicktr.find("input[name='radio2']").val(); 					// 내가 체크한 orderno
	const hospitalize_no = $("input.hospitalize_no").val(); 							// 내가 체크한 hospitalize_no
	const fk_hospitalizeroom_no = $("select[name='fk_hospitalizeroom_no']").val(); 		// 내가 체크한 fk_hospitalizeroom_no
	const hospitalize_start_day	 = $("input#hospitalize_start_day").val(); 				// 입원일자
	const hospitalize_end_day = $("input#hospitalize_end_day").val(); 					// 퇴원일자
	const jubun = $("input[name='jubun']").val();
	
	$.ajax({
		url:"<%= ctxPath%>/register/hospitalizeUpdate",
		type: "PATCH",
		data: { "fk_order_no":fk_order_no,
				"hospitalize_no":hospitalize_no,
				"fk_hospitalizeroom_no":fk_hospitalizeroom_no,
				"hospitalize_start_day":hospitalize_start_day,
				"hospitalize_end_day":hospitalize_end_day,
				"jubun":jubun},
	    dataType: "json",
	    success:function(response) {  
	    	alert(response.message);
	    	location.reload(true);
		},error: function(error){
			let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
	   		alert(errorMessage);
	 	}
	});

}
</script>

<div id="sub_mycontent">
      <div class="header">
		
	  		<div class="title">
	  			환자상세조회
	  		</div>	
	  		<div class="info">
				<table class="table table-bordered chart">
					<thead class="charthead bg-light">
						<tr>
							<th>환자번호</th>
							<th>이름</th>
							<th>성별</th>
							<th>나이</th>
							<th>초진 / 재진</th>
						</tr>
					</thead>
					<tbody>
						<tr><input type="hidden" name="jubun" value="${requestScope.jubun}"/>
							<input type="hidden" name="patient_no" value="${requestScope.detail_patient.patient_no}"/>
							<td>${requestScope.detail_patient.patient_no}</td>
							<td id="patient_name">${requestScope.detail_patient.patient_name}</td>
							<td>${requestScope.detail_patient.patient_gender}</td>
							<td>${requestScope.detail_patient.age}</td>
							<c:choose>
								<c:when test="${requestScope.detail_patient.patient_status eq 0}">
									<td>초진</td>
								</c:when>
								<c:when test="${requestScope.detail_patient.patient_status eq 1}">
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
	  				<thead class="bg-light">
	  					<tr>
	  						<th>내원일</th>
	  						<th>진료명</th>
	  						<th>진료과</th>	
	  					</tr>
	  				</thead>
	  				<tbody>
						<c:forEach var="pvo" items="${requestScope.order_list}">
		  					<tr class="trlist" data-id="${pvo.order_no}" onclick="trlist('${pvo.order_symptom_detail}',${pvo.order_no})">
		  						<td>${pvo.order_createTime}</td>
								<td>${fn:substring(pvo.order_symptom_detail, 0, 8)}...</td>
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
		  			<div class="detail_title">수술예약 관리</div>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div style="width:50%;">
	  				<div class="detail_title">수술 수정</div>
	  			</div>
	  		</div>
	  	
	  		<div class="bottom">
	  		
		  		<!-- 현재 날짜를 가져온다. 과거기록인지 미래기록인지 구분을 위해 -->
				<c:set var="today" value="<%= new java.text.SimpleDateFormat(\"yyyy-MM-dd\").format(new java.util.Date()) %>" />
			
		  		<div class="reservation2">
		  			<table class="table surgerytable">
		  				<thead class="bg-light">
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
							
								<c:set var="pastRecordSurgery" value="false" />	
								
								<c:forEach var="svo" items="${requestScope.surgery_list}">
								
									<c:set var="surgeryPast" value="${svo.surgery_day < today}" />
									<c:choose>
										<c:when test="${!surgeryPast}">
											<tr>
												<input type="hidden" name="fk_order_no" value="${svo.order_no}" />
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
										</c:when>
										
										<c:otherwise>
											<c:if test="${pastRecordSurgery == 'false'}">
												<tr class="trText">
													<td class="fasttr" colspan="6" style="text-align: center;">지난수술기록</td>
												</tr>
												<c:set var="pastRecordSurgery" value="true" />
												<tr>
													<td>x</td>
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
					  								<td id="order_surgeryType_name">${svo.order_surgeryType_name}</td>
					  								<td><span id="member_name">${svo.member_name}</span>선생님</td>
												</tr>
											</c:if>
										</c:otherwise>
										
									</c:choose>
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
		  				<input type="text" name="patient_name" class="patientinput name" value="" disabled/>
		  			</div>
		  			<div class="input">
		  				<div class="text">예약변경일자</div>
		  				<input type="text" name="surgery_reserve_date" class="patientinput surgeryupdateday" value="" disabled/>
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
	  					<button type="reset" class="btn reset" onclick="reset()">초기화</button>
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
		  			<div class="detail_title">입원예약 관리</div>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div style="width:50%;">
	  				<div class="detail_title">입원 수정</div>
	  			</div>
	  		</div>
	  	
	  		<div class="bottom">
	  		
		  		<div class="reservation2">
		  			<table class="table">
		  				<thead class="bg-light">
		  					<tr>
			  					<th>선택</th>
			  					<th>입원일자</th>
			  					<th>퇴원일자</th>
			  					<th>입원실</th>	  			
		  					</tr>
		  				</thead>
		  				<tbody>

							<c:if test="${not empty requestScope.hospitalize_list}">
							
						 		<c:set var="pastRecordsPrinted" value="false" />	
						 		
								<c:forEach var="hvo" items="${requestScope.hospitalize_list}">

								    <input type="hidden" class="hospitalize_no"  value="${hvo.hospitalize_no}"/>
									<input type="hidden" class="order_howlonghosp" data-id="${hvo.order_howlonghosp}">

									<c:set var="isPast" value="${hvo.hospitalize_start_day < today}" />
									
										<c:choose>
											<c:when test="${!isPast}">
												<tr class="future">
													<td><input type="radio" name="radio2" class="${hvo.hospitalize_no}" value="${hvo.order_no}" onclick="checkedHospitalizeUpdate()" /></td>
							  						<td class="hospitalize_start_day">${hvo.hospitalize_start_day}</td>
							  						<td class="hospitalize_end_day">${hvo.hospitalize_end_day}</td>
							  						<td class="fk_hospitalizeroom_no" data-id="${hvo.fk_hospitalizeroom_no}">${hvo.fk_hospitalizeroom_no}호</td>
												</tr>	
											</c:when>
												
											<c:otherwise>
												<c:if test="${pastRecordsPrinted == 'false'}">
													<tr class="trText">
														<td class="fasttr" colspan="4" style="text-align: center;">지난입원기록</td>
													</tr>
													<c:set var="pastRecordsPrinted" value="true" />
												</c:if>
												
												<tr class="past">
													<td>x</td>
													<td class="hospitalize_start_day">${hvo.hospitalize_start_day}</td>
							  						<td class="hospitalize_end_day">${hvo.hospitalize_end_day}</td>
							  						<td class="fk_hospitalizeroom_no" data-id="${hvo.fk_hospitalizeroom_no}">${hvo.fk_hospitalizeroom_no}호</td>
												</tr>
											</c:otherwise>								
										</c:choose>
								</c:forEach>
							</c:if>
							
							<c:if test="${empty requestScope.hospitalize_list}">
									<tr><td>${requestScope.hospitalizeMessage}</td></tr>
							</c:if>
		  				</tbody>
		  			</table>
		  		</div>
		  		
		  		<div style="width:20px;"></div>
		  		
		  		<div class="reservation2 updatefrm">
		  			
		  			<div class="input">
		  				<div class="text">환자명</div>
		  				<input type="text" class="patientinput" name="patient_name" disabled/>
		  			</div>
					<div class="input">
		  				<div class="text">예약변경일자</div>
		  				<input type="text" class="patientinput" name="hospitalize_reserve_date" disabled/>
		  			</div>
	
		  			<div class="input">
		  				<div class="text">입원일자</div>
		  				<input type="date" id="hospitalize_start_day" name="hospitalize_start_day" class="patientinput "/>
		  			</div>
						<div class="input">
		  				<div class="text">퇴원일자</div>
			  			<input type="date" id="hospitalize_end_day" name="hospitalize_end_day" class="patientinput "/>
	  				</div>
					<div class="input">
		  				<div class="text">입원실</div>
						<select name="fk_hospitalizeroom_no" class="hospitalizeroom_no">
		  						<option value="">입원실</option>
	  					</select>
  					</div>
		  			<div class="button btn2">
  						<button type="button" class="btn" onclick="hospitalizeUpdate()">수정하기</button>
	  					<button type="reset" class="btn reset" onclick="reset()">초기화</button>
		  			</div>
		  		</div>
	  	</div>
  	</div>
  	<!-- second 끝  -->

  	</div>
  	
  	<div class="backbtn">
  		<button type="button" class="btn back" onclick="history.back();">목록으로</button>
  	</div>
  	
</div>
		

<jsp:include page="../../footer/footer1.jsp" />   