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

<style type="text/css">
/* ========== full calendar css 시작 ========== */
div#calendar{
	width:640px;
	height:400px;
}

a.fc-dom-24, a.fc-dom-24:hover, .fc-daygrid {
    color: #FF0000;
    text-decoration: none;
    background-color: transparent;
    cursor: pointer;
} 

.fc-sat { color: #0000FF; }    /* 토요일 */
.fc-sun { color: #FF0000; }    /* 일요일 */
/* ========== full calendar css 끝 ========== */

ul{
	list-style: none;
}

button.btn_edit{
	border: none;
	background-color: #fff;
}
</style>

<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<jsp:include page="../../header/header1.jsp" />


<script type="text/javascript">
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
</script>



 <div class="main_container">

<div class="box_notice">공지사항</div>
<div class="box_attendance">출퇴근 현황</div>
<div class="box_reservation">오늘 환자 예약 명단</div>
	<div class="box_schedule">
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
	<div class="box_weather">날씨</div>
<div class="box_payment">전자결재</div>

</div>

<jsp:include page="../../footer/footer1.jsp" />    
    