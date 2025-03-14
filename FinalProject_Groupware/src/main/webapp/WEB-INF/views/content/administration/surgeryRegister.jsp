<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
 <%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/surgeryRegister.css" />
<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />

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
} 
div.fc-daygrid-day-bottom > a {
	color: white;
	background-color: #509d9c;
	height:20px;
	line-height: 22px;
	border-radius:3px;
	display: flex;
	padding-left: 5%;
} 
div.fc-title {
	color: black;
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
/* 평일 날짜 색 */
.fc-day-mon a, /* 월요일 */
.fc-day-tue a, /* 화요일 */
.fc-day-wed a, /* 수요일 */
.fc-day-thu a, /* 목요일 */
.fc-day-fri a { /* 금요일 */
  color: black;  /* 원하는 색상 */
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

<jsp:include page="../../header/header1.jsp" /> 

<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>


<script type="text/javascript">
$(document).ready(function(){  
	
	$("span.error").hide();
	
	// ***** 예약일자 (오늘) 입력하기 시작 ***** //
	const today = new Date();
	const year = today.getFullYear();
 	const month = (today.getMonth()+1).toString().padStart(2, '0');
 	const day = today.getDate().toString().padStart(2, '0');
 	
 	const timeString = `\${year} \${month} \${day}`
	
	$("input.today").val(timeString);
 	// ***** 예약일자 (오늘) 입력하기 끝 ***** //
 	
 	// 오늘 이전은 선택 불가능하도록 설정하기
 	let todayDate = new Date().toISOString().split("T")[0]; // 현재 날짜를 YYYY-MM-DD 형식으로 변환
    $("input[type='date']").attr("min", todayDate); // input 요소의 min 속성 설정
	
 	
 	// ****** 캘린더 띄움 시작 ******//
	var calendarEl = document.getElementById('calendar'); // div#calendar 위치 (보여줄 위치임)
	
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
	    dayMaxEventRows: 0, // 
	    views: {
	      timeGrid: {
	        dayMaxEventRows: 1 // adjust to 6 only for timeGridWeek/timeGridDay
	      }
	    },
	    // ===================== DB 와 연동하는 법 시작 ===================== //
	    events:function(info, successCallback, failureCallback) {

	    	 $.ajax({
	    		 url: '<%= ctxPath%>/register/surgerySchedule',
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
                     	
						 
                         if (item.surgery_day && item.surgery_start_time) {
                        	 
                        	 var startDateTime = item.surgery_day + "T" + item.surgery_start_time;  // "2025-03-18T11:30:00"
                             var endDateTime = item.surgery_day + "T" + item.surgery_end_time;  // "2025-03-18T15:00:00"	 
								
                             events.push({
                                 title: surgery_surgeryroom_name + ' (' + item.surgery_start_time.substring(0,5) + ' - ' + item.surgery_end_time.substring(0,5) + ')',
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
	        // title 부분을 수술실 이름만 표시
	        var customTitle = info.event.title;  // title은 이미 수술실 이름만 들어가 있음
	        var customTime = "";  // 시간을 제거하고 싶다면 여기에 아무것도 넣지 않거나 빈 문자열로 설정

	        // customTime을 포함해서 필요한 경우 추가적으로 정보를 표시할 수 있음
	        return {
	            html: '<div class="fc-title" style=" white-space: normal; overflow: visible; word-wrap: break-word;">' 
                     + customTitle + '</div>'
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
	
	calendar.render();  // 풀캘린더 보여주기
	// ****** 캘린더 띄움 끝 ******//
	
	// ****** 예약 가능한 시간선택 옵션 시작 ******//
	// 수술실과 날짜를 고려한 수술 가능한 시간 구하기
	$("select#surgery_surgeryroom_name, input#surgery_day").on("change", function(){
		
		let room = $("select#surgery_surgeryroom_name").val(); // 수술실 이름
		let day = $("input#surgery_day").val();	// 수술 할 날짜 
	
		if (room && day) {

			$.ajax({
					 url:"<%= ctxPath%>/register/oktime",
					 type: "GET", 
					 data:{"surgeryroom_no":room, 
						   "surgery_day":day},
					 dataType: "json",
		    	     success:function(availableTimes){
		    	    	
						let startTime = $("select#surgery_start_time")
						
						startTime.empty(); // 비우기
						
						startTime.append('<option value="0">시작시간</option>');
						
						availableTimes.forEach(time => {
							startTime.append(`<option value="\${time}">\${time}</option>`);
						});
		    	     },
		  	    	    error: function(request, status, error){
					   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					 }
				}); // end of $.ajax
		}
		
	}); // end of $("select#surgery_surgeryroom_name, input#surgery_day").on("change", function())

	
	// 시작 시간이 선택 되어지면 종료시간 선택이 가능하도록 해야됨 (가능한 시간 고려하기) 
	$("select#surgery_start_time").on("change", function(){
		
		let room = $("select#surgery_surgeryroom_name").val(); // 수술실 이름
		let day = $("input#surgery_day").val();	// 수술 할 날짜
		let startTime = $(this).val();
		let endTimeSelect = $("select#surgery_end_time");
		
		// 기존 예약되어진 일정 가져오기 -> 예약 시간이 있다면 or 예약 시간이 없다면 조건 
		$.ajax({
			url:"<%= ctxPath%>/register/reservedTime",
			type: "POST",
			data:{"surgeryroom_no":room, 
				  "surgery_day":day},
		    dataType: "json",
		    success:function(reservedTime) {   	
		    	// console.log("예약된 시간 목록:", reservedTime);
				
				let availableEndTimes = getAvaliableEndTime(startTime, reservedTime); // 종료시간 구하는 함수
				
				endTimeSelect.empty().append('<option value="0">종료시간</option>'); // 종료시간초기화
				
				availableEndTimes.forEach(time => {
					endTimeSelect.append(`<option value="\${time}">\${time}</option>`);
				});
				
				
		    },  error: function(request, status, error){
		   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		}); // end of $.ajax({
	});
	// ****** 예약 가능한 시간선택 옵션 시작 끝 ******// 
	
});


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


// 예약버튼 누름
function registerSurgery() {
	
	const surgery_surgeryroom_name = $("select#surgery_surgeryroom_name").val();
	const surgery_day = $("input#surgery_day").val();
	const surgery_start_time = $("select#surgery_start_time").val();
	const surgery_end_time = $("select#surgery_end_time").val();
	const surgery_description = $("input#surgery_description").val();
	
	// 수술실 선택
	if(surgery_surgeryroom_name == "0") {
		$("select#surgery_surgeryroom_name").parent().find("span.error").show(); // 에러메시지 표시
		return;
    }
	else {
		$("select#surgery_surgeryroom_name").parent().find("span.error").hide();  // 에러메시지 숨김
	}
	
	// 수술날짜 선택
	if(surgery_day == "") {
		$("input#surgery_day").closest(".input").find("span.error").eq(0).show(); // 에러메시지 표시 
		return;
    }
	else {
		$("input#surgery_day").parent().find("span.error").hide();  // 에러메시지 숨김
	}
	
	// 수술실 시작시간
	if(surgery_start_time == "0") {
		$("select#surgery_start_time").closest(".input").find("span.error").eq(1).show(); // 에러메시지 표시 
		return;
    }
	else {
		$("select#surgery_start_time").parent().find("span.error").hide();  // 에러메시지 숨김
	}
	
	// 수술실 종료시간
	if(surgery_end_time == "0") {
		$("select#surgery_end_time").parent().find("span.error").show(); // 에러메시지 표시 
		return;
    }
	else {
		$("select#surgery_end_time").parent().find("span.error").hide();  // 에러메시지 숨김
	}
	
	// 수술실 설명내용 
	if(surgery_description == "") {
		$("input#surgery_description").parent().find("span.error").show(); // 에러메시지 표시
		return;
    }
	else {
		$("input#surgery_description").parent().find("span.error").hide();  // 에러메시지 숨김
	}
	
	
	// 폼(form)을 전송(submit)
    const frm = document.surgeryRegisterFrm;
	const formData = new FormData(frm); // 폼데이터 직렬화
	
	const orderno = $("input#fk_order_no").val();
	// console.log(orderno);
	
	$.ajax({
		 url:"<%= ctxPath%>/register/success",
		 type:"POST", 
		 data:formData,
		 processData: false, // FormData 객체를 사용할 때는 processData를 false로 설정
         contentType: false, // FormData 객체를 사용할 때는 contentType을 false로 설정
		 dataType: "json",
	     success:function(response){
			alert(response.message);
			window.location.href = "<%= ctxPath%>/register/list";
		 },
	     error: function(error){
			let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
	   		alert(errorMessage);
	 	}

	});
}

</script>
<div id="sub_mycontent">
	<div class="content">
	
		<div class="left">
			
	  		<div class="title">
	  			수술예약
	  		</div>
  			
	  		
	  		<div class="form">
				
		  		<form name="surgeryRegisterFrm">
		  		
		  			<div class="input read">
		  				<div class="text">차트번호</div>
		  				<input type="text" name="fk_order_no" value="${requestScope.order_no}" readonly/>
		  			</div>
		  			<div class="input read">
		  				<div class="text">환자명</div>
		  				<input type="text" value="${requestScope.name}" readonly/>
		  			</div>
		  			<div class="input read">
		  				<div class="text">예약일자</div>
		  				<input type="text" class="today" name="surgery_reserve_date" readonly/>
		  			</div>
		  			<div class="input">
		  				<div class="text">수술실 * <span class="error">수술실을 선택하세요</span></div>
	  					<select name="surgery_surgeryroom_name" id="surgery_surgeryroom_name">
							<option value="0">수술실</option>
	  					<c:forEach var="surgeryvo" items="${requestScope.surgeryroom}">	
	  						<option value="${surgeryvo.surgeryroom_no}">${surgeryvo.surgeryroom_name}</option>
 						</c:forEach>
	  					</select>
		  			</div>
		  			
		  			<div class="input">
		  				<div class="text">수술일자 / 시작시간 * <span class="error">수술일자를 선택하세요</span>
															<span class="error">시간시간을 선택하세요</span></div>
		  				<div class="div_surgerydate">
			  				<input type="date" name="surgery_day" id="surgery_day" class="surgerydate mr-3"/>
			  				<select name="surgery_start_time" id="surgery_start_time" class="surgeryStartdate">
			  					<option value="">시작시간</option>
			  				</select>
		  				</div>
		  			</div>
		  			
		  			<div class="input">
		  				<div class="text">수술종료시간 (예상) * <span class="error">죵료시간을 선택하세요</span></div>
		  				<select name="surgery_end_time" id="surgery_end_time" class="surgeryenddate">
		  					<option value="">종료시간</option>
		  				</select>
		  			</div>
		  			<div class="input">
		  				<div class="text">수술설명 * <span class="error">수술설명을 입력하세요</span></div>
		  				<input type="text" name="surgery_description" id="surgery_description" value="${requestScope.surgery_description}"/>
		  			</div>	
				</form>
	  		</div>
	    </div>
		   
	    <div class="middle" style="width:50px;"></div>
	    
	    <div class="right">
			
	  	<!-- 	<div class="title">
	  			수술일정
	  		</div> -->
	  		
	  		<!-- <hr style="border-bottom:1px solid black;"> -->
			
			<div id="calendar">
				
			</div>

	    </div>
	 
	</div>
	   
    <div class="button">
    	<button type="button" class="btn" onclick="registerSurgery()">예약완료</button>
    	<button type="reset" class="btn" onclick="javascript:location.href='<%= ctxPath%>/register/list'">목록으로</button>
    </div>
	
</div> 

<jsp:include page="../../footer/footer1.jsp" />   