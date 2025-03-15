<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
//     /med-groupware
%>

<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />
 <%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/main.css" />

<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<jsp:include page="../../header/header1.jsp" />


<script type="text/javascript">

<!-- 일정관리 시작 -->
$(document).ready(function(){
var calendarE2 = document.getElementById('calendar');
var calendar = new FullCalendar.Calendar(calendarE2, {
	googleCalendarApiKey : "AIzaSyCRjnRGC34m1793GHG4maFywlczzPV4NGw",
    eventSources: [
        {
            googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
            color: 'white',
            textColor: 'red'
        }
    ],
    initialView: 'dayGridMonth',
    locale: 'ko',
    selectable: true,
    editable: false,
    headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth dayGridWeek dayGridDay'
    },
    dayMaxEventRows: true,
    
    views: {
        timeGrid: {
            dayMaxEventRows: 3
        }
    },
    events: function (info, successCallback, failureCallback) {
        $.ajax({
            url: '<%= ctxPath%>/schedule/selectSchedule',
            data: { "fk_member_userid": $('input#fk_member_userid').val() },
            dataType: "json",
            success: function (json) {
                var events = [];
                if (json.length > 0) {

                    $.each(json, function (index, item) {
                        var startdate = moment(item.schedule_startdate).format('YYYY-MM-DD HH:mm:ss');
                        var enddate = moment(item.schedule_enddate).format('YYYY-MM-DD HH:mm:ss');
                        var subject = item.schedule_subject;

                        events.push({
                        	id: item.schedule_no,
                            title: item.schedule_subject,
                            start: startdate,
                            end: enddate,
                            url: "<%= ctxPath%>/schedule/detailSchedule?schedule_no="+item.schedule_no,
                            color: item.schedule_color,
                            cid: item.fk_small_category_no
                        });

                        if (item.fk_large_category_no == 1 && item.fk_member_userid != "${sessionScope.loginuser.member_userid}" && (item.schedule_joinuser).indexOf("${sessionScope.loginuser.member_userid}") !== -1) {
                            events.push({
                                id: "0",
                                title: item.schedule_subject,
                                start: startdate,
                                end: enddate,
                                url: "<%= ctxPath%>/schedule/detailSchedule?schedule_no="+item.schedule_no,
                                color: item.schedule_color,
                                cid: "0" 
                            });
                        }
                    });
                }
                successCallback(events); 
                
            },
            error: function (request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });

    },
    dateClick: function(info) {
        $(".fc-day").css('background', 'none');
        info.dayEl.style.backgroundColor = '#b1b8cd'; // 클릭한 날짜의 배경색 변경
        $("form > input[name=chooseDate]").val(info.dateStr);

        var frm = document.dateFrm;
        frm.method = "POST";
        frm.action = "<%= ctxPath%>/schedule/insertSchedule";
        frm.submit();
    }
});

calendar.render();  // 풀캘린더 보여주기
});
<!-- 일정관리 끝 -->



<!-- 출퇴근 현황 시작 -->
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

//현재 시간 타이머 
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
<!-- 출퇴근 현황 끝 -->




//공지사항 디테일 페이지로 이동
function detailNotice(notice_no) {
	// alert(notice_no);	
	window.location.href = `<%= ctxPath%>/notice/detail/\${notice_no}`;
}



function getWeatherForecast() {
    const apiKey = "562694b7b66f34fecf5ea59b127756f2";  // 발급받은 API 키를 여기에 넣으세요.

    // 위치 정보 받기 (위도, 경도)
    const getWeatherData = (lat, lon) => {
    	const url = `https://api.openweathermap.org/data/2.5/forecast?lat=\${lat}&lon=\${lon}&units=metric&lang=kr&appid=\${apiKey}`;


        fetch(url)
            .then(response => response.json())
            .then(data => {
                if (data.cod === "200") {
                    let forecastHTML = '';
                    let forecastData = [];
                    
                    

                    data.list.forEach((forecast) => {
                        const date = new Date(forecast.dt * 1000);
                        const month = date.getMonth() + 1; 
                        const day = date.getDate(); 

                        const dateString = `\${month}월 \${day}일`;
                        
                        const weatherDescription = forecast.weather[0].description;

                        let translatedDescription = weatherDescription;

                        if (!forecastData.some(item => item.date === dateString)) {
                            forecastData.push({
                                date: dateString,
                                temp: forecast.main.temp.metric,
                                description: translatedDescription,  
                                icon: forecast.weather[0].icon,
                                highTemp: forecast.main.temp_max, 
                                lowTemp: forecast.main.temp_min 
                            });
                        }
                    });
                 
                    forecastData.forEach((forecast) => {
                        forecastHTML += `
                            <div class="forecast-item">
                                <h6>\${forecast.date}</h6>
                                <img src="https://openweathermap.org/img/wn/\${forecast.icon}@2x.png" alt="날씨 아이콘">
                                <div class="temps">
	                                <p class="high">🌡 \${forecast.highTemp}°C</p>
	                                <p class="low">🌡 \${forecast.lowTemp}°C</p>
                           		 </div>
                            </div>
                        `;
                    });
                    document.getElementById('status').textContent = `\${data.city.name} 날씨 예보`;
                    document.getElementById('weather-info').innerHTML = forecastHTML;
                } else {
                    document.getElementById('status').textContent = `오류 발생: \${data.message}`;
                }
            })
            .catch(() => {
                document.getElementById('status').textContent = "날씨 정보를 불러올 수 없습니다.";
            });
    };

    // 위치 정보 받기 (위도, 경도)
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            (position) => getWeatherData(position.coords.latitude, position.coords.longitude), // 위치 기반 날씨
            () => getWeatherData(37.5665, 126.9780) // 위치 정보 없으면 서울
        );
    } else {
        getWeatherData(37.5665, 126.9780);  // 위치 정보 지원하지 않으면 서울
    }
};

window.onload = getWeatherForecast;

</script>


<div class="main_container_width">
<div class="main_container">


	<!-- 출퇴근 현황 시작 -->
	<div class="box_attendance">
		<input type="hidden" class="member_userid" value="${requestScope.member_userid}" />
		<a class="main_h6" href="<%=ctxPath%>/commuteRecord">출퇴근 현황</a>

		<div class="main_time">
			<div class="today">Today</div>
			<div id="clock"></div>

			<i class="fa-regular fa-clock"><span class="recordText_1">&nbsp;${requestScope.member_name}</span>
				<span class="recordText">님의 출퇴근현황</span></i>
		</div>

		<div class="recordbtn">
			<div class="startbtn">
				<button type="button" class="sbtn main_att_btn"
					value="${requestScope.member_userid}">출근</button>
				<c:if test="${not empty requestScope.TodayStartRecord}">
					<c:if test="${empty TodayStartRecord.work_starttime}">
						<span class="times">출근 기록 없음</span>
					</c:if>
					<c:if test="${not empty TodayStartRecord.work_starttime}">
						<span class="times">${TodayStartRecord.work_starttime}</span>
					</c:if>
					<c:choose>
						<c:when test="${TodayStartRecord.work_startstatus eq 0}"> 정상 출근 </c:when>
						<c:when test="${TodayStartRecord.work_startstatus eq 1}"> 지각 </c:when>
						<c:when test="${TodayStartRecord.work_startstatus eq 2}"> 결근 </c:when>
					</c:choose>
				</c:if>
				<c:if test="${empty requestScope.TodayStartRecord}">
					<span class="times">출근 기록 없음</span>
				</c:if>
			</div>

			<div class="endbtn">
				<button type="button" class="ebtn main_att_btn"
					value="${requestScope.member_userid}">퇴근</button>
				<c:if test="${not empty requestScope.TodayEndRecord}">
					<c:if test="${empty TodayEndRecord.work_endtime}">
						<span class="times">퇴근 기록 없음</span>
					</c:if>
					<c:if test="${not empty TodayEndRecord.work_endtime}">
						<span class="times">${TodayEndRecord.work_endtime}</span>
					</c:if>
					<c:choose>
						<c:when test="${TodayEndRecord.work_endstatus eq 0}">퇴근</c:when>
						<c:when test="${TodayEndRecord.work_endstatus eq 1}">조퇴</c:when>
						<c:when test="${TodayEndRecord.work_endstatus eq 2}">결근</c:when>
					</c:choose>
				</c:if>
				<c:if test="${empty requestScope.TodayEndRecord}">
					<span class="times">퇴근 기록 없음</span>
				</c:if>
			</div>
		</div>
	</div>
	<!-- 출퇴근 현황 끝 -->




	<!-- 공지사항 시작 -->
	<div class="box_notice">
	
		<a  class="main_h6" href="<%=ctxPath%>/notice/list">공지사항 총 <span style="color: #f68b1f;">&nbsp;${requestScope.totalCount}건</span></a>
		

		<c:if test="${not empty requestScope.notice_list}" > 
			 <c:forEach var="nvo" items="${requestScope.notice_list}">
				<div class="main_article_one_row" data-id="${nvo.notice_fix}" onclick="detailNotice(`${nvo.notice_no}`)">

					<div class="main_article">

						<div class="main_article_title" style="${nvo.notice_fix eq '1' ? 'color:black; font-weight:bold;' : ''}">
							<c:if test="${nvo.notice_fix eq '1'}">
								<i class="fa-solid fa-thumbtack"></i>
							</c:if>
						<c:choose>
								<c:when test="${nvo.notice_dept eq 0}">
									[전체]
								</c:when>
								<c:when test="${nvo.notice_dept eq 1}">
									[진료부]
								</c:when>
								<c:when test="${nvo.notice_dept eq 2}">
									[간호부]
								</c:when>
								<c:when test="${nvo.notice_dept eq 3}">
									[경영지원부]
								</c:when>
							</c:choose>${nvo.notice_title}
							<c:if test="${not empty nvo.notice_fileName}">
								<i class="fa-solid fa-paperclip" style="color: #509d9c;"></i>
							</c:if>
						</div>
					</div>

				<div class="main_article_info">${nvo.notice_write_date}
					<c:choose>
						<c:when
							test="${nvo.fk_child_dept_no >= 1 and nvo.fk_child_dept_no <= 7}">
							진료부
						</c:when>
						<c:when
							test="${nvo.fk_child_dept_no >= 8 and nvo.fk_child_dept_no <= 10}">
							간호부
						</c:when>
						<c:when
							test="${nvo.fk_child_dept_no >= 11 and nvo.fk_child_dept_no <= 13}">
							경영지원부
						</c:when>
					</c:choose>
				</div>
			</div>
	</c:forEach>
</c:if>
	<c:if test="${empty requestScope.notice_list}">
		<div class="main_article_one_row">등록된 공지사항이 없습니다.</div>
	</c:if>
</div>
<!-- 공지사항 끝 -->




<!-- 오늘의 환자 명단 시작 -->	
<div class="box_reservation">
<a class="main_h6" href="<%=ctxPath%>/patient/list">오늘의 환자 명단</a>

<table class="index_patient">
<thead>
	<tr>
		<th>진료번호</th>
		<th>진료일자</th>
		<th>진료과</th>
		<th>환자명</th>
	</tr>
</thead>
<tbody>
	<c:if test="${not empty requestScope.patientList}">
		<c:forEach var="pvo" items="${requestScope.patientList}">
			<tr class="index_patient_tr" onclick="javascript:location.href='<%= ctxPath%>/patient/detail/${pvo.patient_no}'" >
				<td>${pvo.patient_no}</td>
				<td>${pvo.patient_visitdate}</td>
				<td>${pvo.child_dept_name}</td>
				<td>${pvo.patient_name}</td>
			</tr>
		</c:forEach>
	</c:if>
	<c:if test="${empty requestScope.patientList}">
		<tr><td>진료기록이 있는 환자가 없습니다</td></tr>
	</c:if>
	</tbody>
</table>
</div>	
<!-- 오늘의 환자 명단 끝 -->	



<!-- 결재문서함 시작 -->	
<div class="box_payment">
	<a class="main_h6" class="dropdown-item" href="<%=ctxPath%>/approval/approvalPendingList">전자결재</a>

		<table>
			<thead>
				<tr>
					<td>기안부서</td>
					<td>기안자</td>
					<td>제목</td>
					<td>상태</td>
					<td>작성일</td>
				</tr>
			</thead>
			<tbody>
				<c:if test="${not empty requestScope.pendingList}">			
					<%-- ============ 긴급한 기안문 ============ --%>		
					<c:forEach var="approvalvo" items="${requestScope.pendingList}" varStatus="pending_status"> 
						<c:if test="${approvalvo.draft_urgent eq '1' && approvalvo.approval_status eq '결재예정'}">
							<%-- 첨부파일 없는 경우 --%>
							<c:if test="${empty approvalvo.draft_file_name}">
									<input type="hidden" value="${approvalvo.draft_no}"/>
								<tr>
									<td>${approvalvo.parent_dept_name}</td>
									<td>${approvalvo.member_name}</td>
									<td style="text-align:left;"><i class="fa-solid fa-bell fa-shake" style="color: #f68b1f;"></i>&nbsp;&nbsp;${approvalvo.draft_subject}</td>
									<td>${approvalvo.draft_status}</td>
									<td>${approvalvo.draft_write_date}</td>
								</tr>
							</c:if>	
							<%-- 첨부파일 있는 경우 --%>
							<c:if test="${not empty approvalvo.draft_file_name}">
									<input type="hidden" value="${approvalvo.draft_no}"/>
								<tr>									
									<td>${approvalvo.parent_dept_name}</td>
									<td>${approvalvo.member_name}</td>
									<td style="text-align:left;"><i class="fa-solid fa-bell fa-shake" style="color: #f68b1f;"></i>&nbsp;&nbsp;${approvalvo.draft_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color: #cb2525;"></i></td>
									<td>${approvalvo.draft_status}</td>
									<td>${approvalvo.draft_write_date}</td>
								</tr>
							</c:if>	
						</c:if>
					</c:forEach>
					
					<%-- ============ 일반 기안문 ============ --%>	
					<c:forEach var="approvalvo" items="${requestScope.pendingList}" varStatus="pending_status"> 
						<c:if test="${approvalvo.draft_urgent eq '0' || (approvalvo.draft_urgent eq '1' && approvalvo.approval_status ne '결재예정')}">
							<%-- 첨부파일 없는 경우 --%>
							<c:if test="${empty approvalvo.draft_file_name}">
									<input type="hidden" value="${approvalvo.draft_no}"/>
								<tr>
									<td>${approvalvo.parent_dept_name}</td>
									<td>${approvalvo.member_name}</td>
									<td style="text-align:left;">${approvalvo.draft_subject}</td>
									<td>${approvalvo.draft_status}</td>
									<td>${approvalvo.draft_write_date}</td>
								</tr>
							</c:if>	
							<%-- 첨부파일 있는 경우 --%>
							<c:if test="${not empty approvalvo.draft_file_name}">
								<input type="hidden" value="${approvalvo.draft_no}"/>
								<tr>
									<td>${approvalvo.parent_dept_name}</td>
									<td>${approvalvo.member_name}</td>
									<td style="text-align:left;">${approvalvo.draft_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color: #cb2525;"></i></td>
									<td>${approvalvo.draft_status}</td>
									<td>${approvalvo.draft_write_date}</td>
								</tr>
							</c:if>	
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${empty requestScope.pendingList}">	
					<tr>
						<td colspan="7">결재 예정인 문서가 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

</div>
<!-- 결재문서함 끝 -->		
	
	
<!-- 일정관리 시작 -->	
	<div class="box_schedule">
		<a class="main_h6" href="<%=ctxPath%>/schedule/scheduleManagement"  style="margin-left: 9px;">일정관리</a>
		<div>
			<div id="wrapper1">
				<input type="hidden" value="${sessionScope.loginuser.member_userid}"
					id="fk_member_userid" />
				<%-- value="${sessionScope.loginuser.member_userid}" --%>
					<%-- 풀캘린더가 보여지는 엘리먼트  --%>
					<div id="calendar"></div>
			</div>
			<%-- === 마우스로 클릭한 날짜의 일정 등록을 위한 폼 === --%>
			<form name="dateFrm">
				<input type="hidden" name="chooseDate" />
			</form>
		</div>
	</div>
<!-- 일정관리 끝 -->	
	
	
	
	
	

<!-- 날씨 시작 -->
	<div class="box_weather">
		<p class="main_h6" id="status" class="loading"></p>
		<div class="weather-container">
			<div class="weather-info" id="weather-info"></div>
		</div>
	</div>
	<!-- 날씨 끝 -->	
	
	
	
	
	
	
	
	</div>
</div>
<jsp:include page="../../footer/footer1.jsp" />    
    