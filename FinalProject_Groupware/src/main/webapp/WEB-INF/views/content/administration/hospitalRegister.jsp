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
	
	$("span.error").hide();
	
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
	
	// ****** 입력폼 유효성 검사하기 시작 ******//
	/* 입원시작일자 유효성 검사하기 */
	$("input[name='hospitalize_start_day']").blur((e) => {

	   if($(e.target).val() == "") {
			$("div.form :input, div.form select").prop("disabled", true);
	        $(e.target).prop("disabled", false);

	      	$(e.target).closest(".input").find("span.error").eq(0).show(); // 에러메시지 표시 
	   }
		else {
			$("div.form :input, div.form select").prop("disabled", false); 
			$(e.target).closest(".input").find("span.error").eq(0).hide(); // 에러메시지 표시 
		}	
	});
		
	/* 입원실 유효성 검사하기 */
	$("select[name='fk_hospitalizeroom_no']").blur((e) => {

	   if($(e.target).val() == "") {
			$("div.form :input, div.form select").prop("disabled", true);
	        $(e.target).prop("disabled", false);

	        $(e.target).closest(".input").find("span.error").show(); // 에러메시지 표시 
	   }
		else {
			$("div.form :input, div.form select").prop("disabled", false); 
			$(e.target).closest(".input").find("span.error").hide();  // 에러메시지 숨김
		}	
	});
	// ****** 입력폼 유효성 검사하기 끝 ******//
	

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
	
	
	// 시작일 변경되면 함수 시작 -> 입원시작일과 입원종료일을 고려한 입원실 잔여석 알아오기 
	$("input[name='hospitalize_start_day'").on("change", function(){
		
		const order_no = $("input[name='fk_order_no']").val();
		const hospitalize_start_day = $("input[name='hospitalize_start_day']").val(); // 입원일자 
		const hospitalize_end_day = $("input[name='hospitalize_end_day']").val(); // 퇴원일자 
			
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
					roomSelect.empty(); // 기존 옵션 초기화 
					
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
		error: function(error){
			let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
	   		alert(errorMessage);
	 	}
	});
}
</script>

	<div class="content">
	
		<div class="left">
			
	  		<div class="title">
	  			입원예약
	  			
	  		</div>
  			
	  		<form name="hospitalizeRegister">
	  		
		  		<div class="form ">
		  			<input type="hidden" value="${requestScope.order_no}" name="fk_order_no">
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
		  				<input type="text" class="today" name="hospitalize_reserve_date" readonly/>
		  			</div>
		  			<div class="input read">
		  				<div class="text">입원기간</div>
		  				<input type="text" class="order_howlonghosp" name="order_howlonghosp" data-id="${requestScope.order_howlonghosp}" value="${requestScope.order_howlonghosp} 일" readonly/>
		  			</div>
		  			<div class="input">
		  				<div class="text">입원일자 / 퇴원일자 * <span class="error">입원일자를 선택하세요</span><span class="error">퇴원일자를 선택하세요</span></div>
		  				<input type="date" class="date mr-3" name="hospitalize_start_day" /><input type="date" class="date" name="hospitalize_end_day" readonly/>
		  			</div>
		  			<div class="input">
		  				<div class="text">입원실 *<span class="error">입원실을 선택하세요</span></div>
			  				<select name="fk_hospitalizeroom_no" class="hospitalizeroom_no">
			  						<option value="">입원실</option>
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