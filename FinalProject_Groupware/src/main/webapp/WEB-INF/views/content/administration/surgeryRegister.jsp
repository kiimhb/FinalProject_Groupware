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
    text-decoration: none ;
    background-color: transparent ;
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

<jsp:include page="../../header/header1.jsp" /> 

<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>


<script type="text/javascript">
$(document).ready(function(){  
	
	// ***** 예약일자 (오늘) 입력하기 시작 ***** //
	const today = new Date();
	const year = today.getFullYear();
 	const month = (today.getMonth()+1).toString().padStart(2, '0');
 	const day = today.getDate().toString().padStart(2, '0')
 	
 	const timeString = `\${year} \${month} \${day}`
	
	$("input.today").val(timeString);
 	// ***** 예약일자 (오늘) 입력하기 끝 ***** //
	
 	
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
	
	calendar.render();  // 풀캘린더 보여주기
	// ****** 캘린더 띄움 끝 ******//
	
	 // ****** 시간선택 옵션 시작 ******//
	
	// select 요소 보여주기 // 
	/*
	var startTime = document.getElementById("surgery_start_time");
	var endTime = document.getElementById("surgery_end_time");
	
	for(var hour=9; hour<18; hour++) {
		for(var min=0; min<60; min+=30) {
			
			var option = document.createElement("option");
			var formatHour = (hour < 10 ? "0" : "") + hour;
			var formatMin = (min === 0 ? "00" : "30");
			option.value = formatHour + ":" + formatMin;
			option.text = formatHour + ":" + formatMin;
			
			// 복제하기 
			var optionClone = option.cloneNode(true);
			
			startTime.appendChild(option); 	  // 시작시간
			endTime.appendChild(optionClone); // 종료시간
		}
	}
	*/
	
	$("select#surgery_surgeryroom_name, input#surgery_day").on("change", function(){
		
		let room = $("select#surgery_surgeryroom_name").val();
		let day = $("input#surgery_day").val();
	
		if (room && day) {

			$.ajax({
					 url:"<%= ctxPath%>/register/oktime",
					 type: "GET", 
					 data:{"surgeryroom_no":room, 
						   "surgery_day":day},
					 dataType: "json",
		    	     success:function(availableTimes){
		    	    	
						let selectbox = $("select#surgery_start_time")
						
						selectbox.empty(); // 비우기
						selectbox.append('<option value="">시작시간</option>');
						
						availableTimes.forEach(time => {
							selectbox.append(`<option value="\${time}">\${time}</option>`);
						});

		    	     },
		  	    	    error: function(request, status, error){
					   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					 }
				}); // end of $.ajax
		}
		
	});
	
	// ****** 시간선택 옵션 끝 ******// 
	
	
	
	
	
});

// 예약버튼 누름
function registerSurgery() {
	
	// 폼(form)을 전송(submit)
    const frm = document.surgeryRegisterFrm;
    frm.method = "post";
    frm.action = "<%= ctxPath%>/register/success";
    frm.submit();
}

</script>

	<div class="content">
	
		<div class="left">
			
	  		<div class="title">
	  			수술예약
	  			<div class="regimenu">
	  				<span><a href="<%= ctxPath%>/register/surgery">수술예약</a> | </span><span><a href="<%= ctxPath%>/register/hospitalization">입원예약</a></span>
	  			</div>
	  		</div>
  			
	  		
	  		<div class="form">
		  		<form name="surgeryRegisterFrm">
		  		
		  			<div class="input read">
		  				<div class="text">차트번호</div>
		  				<input type="text" value="${requestScope.order_no}" readonly/>
		  			</div>
		  			<div class="input read">
		  				<div class="text">환자명</div>
		  				<input type="text" value="${requestScope.name}" readonly/>
		  			</div>
		  			<div class="input read">
		  				<div class="text">예약일자</div>
		  				<input type="text" class="today" name="surgery_day" readonly/>
		  			</div>
		  			<div class="input">
		  				<div class="text">수술실 *</div>
	  					<select name="surgery_surgeryroom_name" id="surgery_surgeryroom_name">
	  					<c:forEach var="surgeryvo" items="${requestScope.surgeryroom}">
	  						<option value="${surgeryvo.surgeryroom_no}">${surgeryvo.surgeryroom_name}</option>
 						</c:forEach>
	  					</select>	
		  			</div>
		  			
		  			<div class="input">
		  				<div class="text">수술일자 / 시작시간 *</div>
		  				<div class="div_surgerydate">
			  				<input type="date" name="surgery_day" id="surgery_day" class="surgerydate mr-3" />
			  				<select name="surgery_start_time" id="surgery_start_time" class="surgeryStartdate">
			  					<option value="">시작시간</option>
			  				</select>
		  				</div>
		  			</div>
		  			
		  			<div class="input">
		  				<div class="text" >수술종료시간 (예상) *</div>
		  				<select name="surgery_end_time" id="surgery_end_time" class="surgeryenddate">
		  					<option value="">종료시간</option>
		  				</select>
		  			</div>
		  			<div class="input">
		  				<div class="text">수술설명 *</div>
		  				<input type="text" name="surgery_description"/>
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
	
   

<jsp:include page="../../footer/footer1.jsp" />   