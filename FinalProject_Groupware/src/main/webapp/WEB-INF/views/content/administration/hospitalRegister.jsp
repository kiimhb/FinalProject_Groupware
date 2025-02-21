<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
 <%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/hospitalRegister.css" />
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
	
	
	// 퇴원일 자동 입력하기
	$("input[name='hospitalize_start_day']").on("change", function(e){
		
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
	
});

// 입원예약하기 클릭 
function registerHospitalize() {
	
	const queryString = $("form[name='hospitalizeRegister']").serialize();
	
	$.ajax({
		url:"<%= ctxPath%>/register/successreserve",
		type:"POST", 
		data:queryString,
		dataType: "json",
		success:function(response){
			alert(response.message);
			window.location.href = "<%= ctxPath%>/register/list";
		},
	    error: function(request, status, error){
		   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	});
}
</script>

	<div class="content">
	
		<div class="left">
			
	  		<div class="title">
	  			입원예약
	  			<div class="regimenu">
	  				<span><a href="<%= ctxPath%>/register/surgery">수술예약</a> | </span><span><a href="<%= ctxPath%>/register/hospitalization">입원예약</a></span>
	  			</div>
	  		</div>
  			
	  		<form name="hospitalizeRegister">
	  		
		  		<div class="form">
		  			<input type="hidden" value="${requestScope.order_no}" name="fk_order_no">
		  			<div class="input">
		  				<div class="text">차트번호</div>
		  				<input type="text" value="${requestScope.order_no}" disabled/>
		  			</div>
		  			<div class="input">
		  				<div class="text">환자명</div>
		  				<input type="text" value="${requestScope.name}" disabled/>
		  			</div>
		  			<div class="input">
		  				<div class="text">예약일자</div>
		  				<input type="text" class="today" name="hospitalize_reserve_date" disabled/>
		  			</div>
		  			<div class="input">
		  				<div class="text">입원기간</div>
		  				<input type="text" class="order_howlonghosp" name="order_howlonghosp" data-id="${requestScope.order_howlonghosp}" value="${requestScope.order_howlonghosp} 일" disabled/>
		  			</div>
		  			<div class="input">
		  				<div class="text">입원일자 / 퇴원일자 *</div>
		  				<input type="date" class="date mr-3" name="hospitalize_start_day" /><input type="date" class="date" name="hospitalize_end_day"/>
		  			</div>
		  			<div class="input">
		  				<div class="text">입원실 *</div>
			  				<select name="fk_hospitalizeroom_no" class="hospitalizeroom_no">
			  					<optgroup label="4인실">
			  					<c:forEach var="hvo" items="${requestScope.hospitalizeroom}">
			  						<c:set var="okseat" value="-" />
			  						<c:forEach var="seat" items="${requestScope.okSeat}">
			  							<c:if test="${hvo.hospitalizeroom_no == seat.hospitalizeroom_no}">
			  								<c:set var="okseat" value="${seat.ok_seat}" />
			  							</c:if>
			  						</c:forEach>
			  						<option value="${hvo.hospitalizeroom_no}">${hvo.hospitalizeroom_no}호 (${okseat}/4)</option>
		 						</c:forEach>
		 						</optgroup>
		 						
		 						<optgroup label="2인실">
			  					<c:forEach var="hvo" items="${requestScope.hospitalizeroom_2}">
			  						<c:set var="okseat" value="-" />
			  						<c:forEach var="seat" items="${requestScope.okSeat}">
			  							<c:if test="${hvo.hospitalizeroom_no == seat.hospitalizeroom_no}">
			  								<c:set var="okseat" value="${seat.ok_seat}" />
			  							</c:if>
			  						</c:forEach>
			  						<option value="${hvo.hospitalizeroom_no}">${hvo.hospitalizeroom_no}호(${okseat}/2)</option>
		 						</c:forEach>
		 						</optgroup>
		 						
		  					</select>		
		  				</div>
		  			</div>
		  		</form>
	    </div>
	    
	    <div class="middle" style="width:50px;"></div>
	    
	    <div class="right">
			
			<div id="calendar">
				
			</div>

	    </div>
	 
	</div>
	   
    <div class="button">
    	<button type="button" class="btn" onclick="registerHospitalize()">예약완료</button>
    	<button type="reset" class="btn" onclick="javascript:location.href='<%= ctxPath%>/register/list'">목록으로</button>
    </div>
	
   

<jsp:include page="../../footer/footer1.jsp" />   