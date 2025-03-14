<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
   
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
	
	// 월 표시하기 (한달단위)
	const now = new Date();
	const month = now.getMonth() + 1;
	$("span.month").html(month+"월");
	

	// 사번알아오기
	const member_userid = $("input.member_userid").val();	
	
	
	// 페이지 로딩과 동시에 오늘 출근을 이미 했는지 여부 확인 (출근 버튼 비활성화)
	$.ajax({
		url:"<%= ctxPath%>/already_check_in",
		type: "GET", 
		data:{"member_userid":member_userid},
        dataType: "json",
        success:function(response){	
       		if(response.already_check_in) {
        		$("button.sbtn").attr("disabled", true); // 출근 기록이 있으면 출근 버튼 비활성화
        	}
        },
 	    	error: function(request, status, error){
	   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // end of $.ajax 
	
	
	
	// 페이지 로딩과 동시에 오늘 퇴근을 이미 했는지 여부 확인 (퇴근 버튼 비활성화)
	$.ajax({
		url:"<%= ctxPath%>/already_check_out",
		type: "GET", 
		data:{"member_userid":member_userid},
        dataType: "json",
        success:function(response){	
       		if(response.already_check_out) {
        		$("button.ebtn").attr("disabled", true); // 퇴근 기록이 있으면 비활성화
        	}
        },
 	    	error: function(request, status, error){
	   		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	}); // end of $.ajax 
	

	// 출근하기 버튼 
	$("button.sbtn").on("click", function(){

		const member_userid = $(this).val();	// 사번알아오기
		const work_starttime = nowtime(); 		// 지금시간
		
		$.ajax({
			url:"<%= ctxPath%>/check_in",
			type: "POST", 
			data:{"member_userid":member_userid,
				  "work_starttime":work_starttime},
	        dataType: "json",
	        success:function(response){	
	        	alert(response.message);
	        	$("button.sbtn").attr("disabled", true); 
	        	location.reload(true);
	        },
 	    	error: function(error){
   	    		let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
 	   	   		alert(errorMessage);
		    }
		
		}); // end of $.ajax 
		
	}); // end of $("button.sbtn").on("click", function()
	
	
	// 퇴근하기 버튼 
	$("button.ebtn").on("click", function(){
		
		const member_userid = $(this).val();	// 사번알아오기
		const work_endtime = nowtime(); 		// 지금시간
		const work_recorddate = nowday(); // 오늘 년-월-일
		
		// alert(member_userid+work_endtime+work_recorddate);
		
		$.ajax({
			url:"<%= ctxPath%>/check_out",
			type: "POST",
			data:{"member_userid":member_userid,
				  "work_recorddate":work_recorddate,
				  "work_endtime":work_endtime},
	        dataType: "json",
	        success:function(response){	
	        	alert(response.message);
	        	$("button.ebtn").attr("disabled", true); 
	        	location.reload(true);
	        },
 	    	error: function(error){
   	    		let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
 	   	   		alert(errorMessage);
		    }
		
		}); // end of $.ajax 
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

 	const timeString = `\${year}-\${month}-\${day} (\${dayOfWeek}) \${ampm} \${displayhours}:\${minutes}:\${seconds}`
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
<div id="sub_mycontent">
     <div class="header">
	
     		<div class="record">
     			<span class="name">${requestScope.member_name}</span> 님의 출퇴근 관리
     			<input type="hidden" class="member_userid" value="${requestScope.member_userid}" />
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
      			<i class="fa-regular fa-clock"><span class="subtitle mr-2">&nbsp;&nbsp;<span class="month"></span>&nbsp;${requestScope.member_name}님의 <span class="recordText">출근기록</span></span></i>
      			<button type="button" class="sbtn btn mr-2" value="${requestScope.member_userid}">출근</button>
      		</div>
      		 
     			<div class="endbtn">
     				<i class="fa-regular fa-clock ml-2"><span class="subtitle mr-2">&nbsp;&nbsp;<span class="month"></span>&nbsp;${requestScope.member_name}님의 <span class="recordText">퇴근기록</span></span></i>
      			<button type="button" class="ebtn btn ml-2" value="${requestScope.member_userid}">퇴근</button>
      		</div>
			
      </div>	
      
      <!-- 기록 조회  -->
      <div class="recordlist">	
		
     		<div class="start mr-2">
			<table>
				<c:if test="${not empty requestScope.StartRecordList}">
					<c:forEach var="svo" items="${requestScope.StartRecordList}">
						<tr>	
							<td>
								<span class="day pl-3">${svo.work_recorddate}</span>
								<c:if test="${empty svo.work_starttime}">
									<span class="times">출근 기록 없음</span>
								</c:if>
								<c:if test="${not empty svo.work_starttime}">
									<span class="times">${svo.work_starttime}</span>
								</c:if>
				      			<c:choose>
									<c:when test="${svo.work_startstatus eq 0}">
										<td>출근</td>
									</c:when>
									<c:when test="${svo.work_startstatus eq 1}">
										<td>지각</td>
									</c:when>
									<c:when test="${svo.work_startstatus eq 2}">
										<td>결근</td>
									</c:when>
								</c:choose>
							</td>
						</tr>	
					</c:forEach>
				</c:if>	
				<c:if test="${empty requestScope.StartRecordList}">
					<tr><td>이번달 출근 기록이 없습니다...</td></tr>	
				</c:if>															
			</table>
     		</div>
     		
     	
     		<div class="end ml-2">
			<table>
				<c:if test="${not empty requestScope.EndRecordList}">
					<c:forEach var="evo" items="${requestScope.EndRecordList}">
						<tr>	
							<td>
								<span class="day pl-3">${evo.work_recorddate}</span>
				      			
								<c:if test="${empty evo.work_endtime}">
									<span class="times">퇴근 기록 없음</span>
								</c:if>
								<c:if test="${not empty evo.work_endtime}">
									<span class="times">${evo.work_endtime}</span>
								</c:if>
				      			<c:choose>
									<c:when test="${evo.work_endstatus eq 0}">
										<td>퇴근</td>
									</c:when>
									<c:when test="${evo.work_endstatus eq 1}">
										<td>조퇴</td>
									</c:when>
									<c:when test="${evo.work_endstatus eq 2}">
										<td>결근</td>
									</c:when>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:if>	
				<c:if test="${empty requestScope.EndRecordList}">
					<tr><td>이번달 퇴근 기록이 없습니다...</td></tr>	
				</c:if>	
			</table>
     		</div>
      </div>
      
     </div>
</div>
       
</body>
</html>

<jsp:include page="../../footer/footer1.jsp" />  