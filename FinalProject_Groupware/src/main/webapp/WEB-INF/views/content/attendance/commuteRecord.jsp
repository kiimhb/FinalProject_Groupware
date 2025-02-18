<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%
String ctxPath = request.getContextPath();
//     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/attendance/commuteRecord.css" />

<jsp:include page="../../header/header1.jsp" />

<script type="text/javascript">
$(document).ready(function(){  
	
	// 타이머 표시
	clock();
	
	// 출근하기 버튼 
	$("button.sbtn").on("click", function(){
		
		
		
	});
	
	
	// 퇴근하기 버튼 
	$("button.ebtn").on("click", function(){
		
		
		
	});
	
	
});

// 현재 시간 타이머 
function clock() {
	
 	const now = new Date();
 	const daysOfWeek = ["일","월","화","수","목","금","토"];
 	const dayOfWeek = daysOfWeek[now.getDay()];
 	const year = now.getFullYear();
 	const month = (now.getMonth()+1).toString().padStart(2, '0');
 	const day = now.getDate().toString().padStart(2, '0')
 	
 	const hour = now.getHours();
 	const minutes = now.getMinutes().toString().padStart(2, '0');
 	const seconds = now.getSeconds().toString().padStart(2, '0');

 	let ampm = 'AM';
 	let displayhours = hour;
 	
 	if(hour >= 12) {
 		ampm = 'PM';
 		displayhours = hour % 12;
 		if(displayhours === 0) {
 			displayhours = 12;
 		}
 		
 	}

 	const timeString = `\${year}-\${month}-\${day} (\${dayOfWeek}) \${displayhours}:\${minutes}:\${seconds} \${ampm}`
	document.getElementById('clock').textContent = timeString;
}

// 1 초마다 타이머 업데이트
setInterval(clock, 1000); 

// 현재 날짜
function nowday() {
	const currentDate = new Date();
			
	const year = currentDate.getFullYear();
	const month = currentDate.getMonth() + 1;
	const day = currentDate.getDate();
	
	const nowday = `\${year}-\${String(month).padStart(2, '0')}-\${String(day).padStart(2, '0')}`;	
	return `\${nowday}`
}

// 현재시간
function nowtime() {
	const currentDate = new Date();
			
	const hours = currentDate.getHours();
	const minutes = currentDate.getMinutes();
	const seconds = currentDate.getSeconds();
	
	const time = `\${String(hours).padStart(2, '0')}:\${String(minutes).padStart(2, '0')}:\${String(seconds).padStart(2, '0')}`;
	
	return `\${time}`
}


</script>
<body>
      <div class="header">
		
      		<div class="record">
      			<span class="name">이혜연</span> 님의 출퇴근 관리
      		</div>
			
      </div>
	  
      <div class="time">
      		<div class="today">Today</div>
      		<div id="clock"></div>	
      </div>
      
      <div class="view mb-3">
      
          <!-- 기록 버튼  -->
	      <div class="recordbtn">
	      
	      		<div class="startbtn">
	      			<i class="fa-regular fa-clock"><span class="subtitle mr-2">&nbsp;&nbsp;이혜연 님의 <span class="recordText">출근기록</span></span></i>
	      			<button type="button" class="sbtn btn mr-2">출근</button>
	      		</div>
	      		 
      			<div class="endbtn">
      				<i class="fa-regular fa-clock ml-2"><span class="subtitle mr-2">&nbsp;&nbsp;이혜연님의 <span class="recordText">퇴근기록</span></span></i>
	      			<button type="button" class="ebtn btn ml-2">퇴근</button>
	      		</div>
				
	      </div>	
	      
	      <!-- 기록 조회  -->
	      <div class="recordlist">	
			
      		<div class="start mr-2">
				<table>
					<tr>	
						<td>
							<span class="day pl-3">2024-12-12</span>
			      			<span class="times">08:59:00</span>
			      			<span class="status">출근</span>
						</td>
					</tr>																	
				</table>
      		</div>
      		
      	
      		<div class="end ml-2">
				<table>
					<tr>	
						<td>
							<span class="day pl-2">2024-12-12</span>
			      			<span class="times">18:00:00</span>
			      			<span class="status">퇴근</span>
						</td>
					</tr>
				</table>
      		</div>
	      </div>
	      
      </div>

       
</body>
</html>

<jsp:include page="../../footer/footer1.jsp" />  