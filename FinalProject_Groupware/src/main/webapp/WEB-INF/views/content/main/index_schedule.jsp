<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
String ctxPath = request.getContextPath();
//     /med-groupware
%>
<style type="text/css">

div#wrapper1{
	float: left; display: inline-block; width: 20%; margin-top:250px; font-size: 13pt;
}

div#wrapper2{
	display: inline-block; width: 80%; padding-left: 20px;
}

/* ========== full calendar css 시작 ========== */
.fc-header-toolbar {
	height: 30px;
}

a, a:hover, .fc-daygrid {
    color: #000;
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

button.btn_normal{
	background-color: #990000;
	border: none;
	color: white;
	width: 50px;
	height: 30px;
	font-size: 12pt;
	padding: 3px 0px;
	border-radius: 10%;
}

button.btn_edit{
	border: none;
	background-color: #fff;
}
</style>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd'  // Input Display Format 변경
   ,showOtherMonths: true   // 빈 공간에 현재월의 앞뒤월의 날짜를 표시
   ,showMonthAfterYear:true // 년도 먼저 나오고, 뒤에 월 표시
   ,changeYear: true        // 콤보박스에서 년 선택 가능
   ,changeMonth: true       // 콤보박스에서 월 선택 가능                
   ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
   ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
   ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
   ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트             
});

// input 을 datepicker로 선언
$("input#fromDate").datepicker();                    
$("input#toDate").datepicker();
	    
// From의 초기값을 한달전 날짜로 설정
$('input#fromDate').datepicker('setDate', '-1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)

// To의 초기값을 오늘 날짜로 설정
//$('input#toDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	

// To의 초기값을 한달후 날짜로 설정
$('input#toDate').datepicker('setDate', '+1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	

// ==== 풀캘린더와 관련된 소스코드 시작(화면이 로드되면 캘린더 전체 화면 보이게 해줌) ==== //
var calendarEl = document.getElementById('calendar');
   
var calendar = new FullCalendar.Calendar(calendarEl, {

	googleCalendarApiKey : "AIzaSyDv62y6d1jVP7jjlzS_Xp14YHjIFVB2z5A",
   eventSources :[ 
       {
       //  googleCalendarId : '대한민국의 휴일 캘린더 통합 캘린더 ID'
           googleCalendarId : 'ko.south_korea#holiday@group.v.calendar.google.com'
         , color: 'white'   // 옵션임! 옵션참고 사이트 https://fullcalendar.io/docs/event-source-object
         , textColor: 'red' // 옵션임! 옵션참고 사이트 https://fullcalendar.io/docs/event-source-object 
       } 
   ],
// === 구글캘린더를 이용하여 대한민국 공휴일 표시하기 끝 === //

   initialView: 'dayGridMonth',
   locale: 'ko',
   selectable: true,
   editable: false,
   headerToolbar: {
   	  left: 'prev,next today',
         center: 'title',
         right: 'dayGridMonth dayGridWeek dayGridDay'
   },
   dayMaxEventRows: true, // for all non-TimeGrid views
   views: {
     timeGrid: {
       dayMaxEventRows: 3 // adjust to 6 only for timeGridWeek/timeGridDay
     }
   },
//===================== DB와 연동하는 법 시작 ===================== //
events: function (info, successCallback, failureCallback) {
    $.ajax({
        url: '<%=ctxPath%>/schedule/selectSchedule',
        data: { "fk_member_userid": $('input#fk_member_userid').val() },
        dataType: "json",
        success: function (json) {
            /*
               json의 값 예
               [{"schedule_enddate":"2021-11-26 18:00:00.0","fk_large_category_no":"2","schedule_color":"#009900","schedule_no":"1","fk_small_category_no":"4","schedule_subject":"파이널 프로젝트 코딩","schedule_startdate":"2021-11-08 09:00:00.0","fk_member_userid":"seoyh"}]
            */
            var events = [];
            if (json.length > 0) {
            	
                $.each(json, function (index, item) {
                    var startdate = moment(item.schedule_startdate).format('YYYY-MM-DD HH:mm:ss');
                    var enddate = moment(item.schedule_enddate).format('YYYY-MM-DD HH:mm:ss');
                    var subject = item.schedule_subject;

                    // 사내 캘린더로 등록된 일정을 풀캘린더에 보여주기
                    // 일정등록시 사내 캘린더에서 선택한 소분류에 등록된 일정을 풀캘린더 달력 날짜에 나타내어지게 한다.
                    if ($("input:checkbox[name=com_small_category_no]:checked").length <= $("input:checkbox[name=com_small_category_no]").length) {
                        
                    	for (var i = 0; i < $("input:checkbox[name=com_small_category_no]:checked").length; i++) {
                            
                    		if ($("input:checkbox[name=com_small_category_no]:checked").eq(i).val() == item.fk_small_category_no) {
                            	// alert("캘린더 소분류 번호 : " + $("input:checkbox[name=com_small_category_no]:checked").eq(i).val());
                                events.push({
                                    id: item.schedule_no,
                                    title: item.schedule_subject,
                                    start: startdate,
                                    end: enddate,
                                    url: "<%=ctxPath%>/schedule/detailSchedule?schedule_no="+item.schedule_no,
                                    color: item.schedule_color,
                                    cid: item.fk_small_category_no // 체크박스 value값과 일치해야 함.
                                });
                            }
                        }
                    }

                    // 내 캘린더로 등록된 일정을 풀캘린더에 보여주기
                    // 일정등록시 사내 캘린더에서 선택한 소분류에 등록된 일정을 풀캘린더 달력 날짜에 나타내어지게 한다.
                    if ($("input:checkbox[name=my_small_category_no]:checked").length <= $("input:checkbox[name=my_small_category_no]").length) {
                       
                    	for (var i = 0; i < $("input:checkbox[name=my_small_category_no]:checked").length; i++) {
                            
                    		if ($("input:checkbox[name=my_small_category_no]:checked").eq(i).val() == item.fk_small_category_no &&
                                item.fk_member_userid == "${sessionScope.loginuser.member_userid}") { // "${sessionScope.loginuser.member_userid}"
                            	// alert("캘린더 소분류 번호 : " + $("input:checkbox[name=my_small_category_no]:checked").eq(i).val());
                                events.push({
                                    id: item.schedule_no,
                                    title: item.schedule_subject,
                                    start: startdate,
                                    end: enddate,
                                    url: "<%=ctxPath%>/schedule/detailSchedule?schedule_no="+item.schedule_no,
                                    color: item.schedule_color,
                                    cid: item.fk_small_category_no
                                });
                            }
                        }
                    }

                 // 공유받은 캘린더(다른 사용자가 내캘린더로 만든 것을 공유받은 경우임)
                    if (item.fk_large_category_no == 1 && item.fk_member_userid != "${sessionScope.loginuser.member_userid}" && (item.schedule_joinuser).indexOf("${sessionScope.loginuser.member_userid}") !== -1) {
                    	
                        events.push({
                            id: "0", // "0" 인 이유는  배열 events 에 push 할때 id는 고유해야 하는데 위의 사내캘린더 및 내캘린더에서 push 할때 id값으로 
	                           		 // item.scheduleno 을 사용하였다. item.scheduleno 값은 DB에서 1 부터 시작하는 시퀀스로 사용된 값이므로 0 값은 
	                           		 // 위의 사내캘린더나 내캘린더에서 사용되지 않으므로 여기서 고유한 값을 사용하기 위해 0 값을 준 것이다.
	                           		 // 고유해야 하기 때문에 "0" 사용   
                            title: item.schedule_subject,
                            start: startdate,
                            end: enddate,
                            url: "<%=ctxPath%>/schedule/detailSchedule?schedule_no=" + item.schedule_no,
                            color: item.schedule_color,
                            cid: "0" // 공유받은 캘린더의 체크박스 value가 "0"
                        }); // end of events.push({})-------
                    } // end of if ------------------
                }); // end of $.each(json, function (index, item) {})-------------------------
            }
			// console.log(events);
            successCallback(events);
        },
        error: function (request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    });
}, // end of events:function(info, successCallback, failureCallback) {}
// ===================== DB와 연동하는 법 끝 ===================== //


// 풀캘린더에서 날짜 클릭할 때 발생하는 이벤트(일정 등록창으로 넘어간다)
dateClick: function(info) {
    // alert('클릭한 Date: ' + info.dateStr); // 클릭한 Date: 2021-11-20
    $(".fc-day").css('background', 'none'); // 현재 날짜 배경색 없애기
    info.dayEl.style.backgroundColor = '#b1b8cd'; // 클릭한 날짜의 배경색 지정하기
    $("form > input[name=chooseDate]").val(info.dateStr);
    
    var frm = document.dateFrm;
    frm.method = "POST";
    frm.action = "<%=ctxPath%>/schedule/insertSchedule";
					frm.submit();
				},

				// === 사내캘린더, 내캘린더, 공유받은캘린더의 체크박스에 체크유무에 따라 일정을 보여주거나 숨기는 로직 === 
				eventDidMount : function(arg) {
					var arr_calendar_checkbox = document
							.querySelectorAll("input.calendar_checkbox");
					// 사내캘린더, 내캘린더, 공유받은캘린더의 모든 체크박스

					arr_calendar_checkbox.forEach(function(item) { // item 이 사내캘린더, 내캘린더, 공유받은캘린더 에서의 모든 체크박스 중 하나인 체크박스임
						if (item.checked) {
							// 사내캘린더, 내캘린더, 공유받은캘린더 에서의 체크박스중 체크박스에 체크를 한 경우 라면

							if (arg.event.extendedProps.cid === item.value) { // item.value는 체크박스의 value 값
								// console.log("일정을 보여주는 cid : " + arg.event.extendedProps.cid);
								// console.log("일정을 보여주는 체크박스의 value값(item.value) : " + item.value);

								arg.el.style.display = "block"; // 풀캘린더에서 일정을 보여줌
							}
						} else {
							// 체크박스에 체크가 해제된 경우
							if (arg.event.extendedProps.cid === item.value) {
								// console.log("일정을 숨기는 cid : " + arg.event.extendedProps.cid);
								// console.log("일정을 숨기는 체크박스의 value값(item.value) : " + item.value);

								arg.el.style.display = "none"; // 풀캘린더에서 일정을 숨김
							}
						}
					}); // end of arr_calendar_checkbox.forEach(function(item) {})

				}

			});

	calendar.render(); // 풀캘린더 보여주기

	var arr_calendar_checkbox = document
			.querySelectorAll("input.calendar_checkbox");
	// 사내캘린더, 내캘린더, 공유받은캘린더 에서의 체크박스임

	arr_calendar_checkbox.forEach(function(item) {
		item.addEventListener("change", function() {
			// console.log(item);
			calendar.refetchEvents(); // 모든 소스의 이벤트를 다시 가져와 화면에 다시 표시합니다.
		});
	});
});
</script>

<div style="margin-left: 80px; width: 88%;">
	<div id="wrapper1">
		<input type="hidden" value="${sessionScope.loginuser.member_userid}"
			id="fk_member_userid" />
		<%-- value="${sessionScope.loginuser.member_userid}" --%>

		<input type="checkbox" id="allComCal" class="calendar_checkbox"
			checked />&nbsp;&nbsp;<label for="allComCal">사내 캘린더</label>

		<%-- 사내 캘린더 추가를 할 수 있는 직원은 직위코드가 3 이면서 부서코드가 4 에 근무하는 사원이 로그인 한 경우에만 가능하도록 조건을 걸어둔다.  	
	     <c:if test="${sessionScope.loginuser.fk_pcode =='3' && sessionScope.loginuser.fk_dcode == '4' }"> --%>
		<c:if test="${sessionScope.loginuser.member_grade =='1'}">
			<button class="btn_edit" style="float: right;"
				onclick="addComCalendar()">
				<i class='fas'>&#xf055;</i>
			</button>
		</c:if>
		<%-- </c:if> --%>

		<%-- 사내 캘린더를 보여주는 곳 --%>
		<div id="companyCal" style="margin-left: 50px; margin-bottom: 10px;"></div>


		<input type="checkbox" id="allMyCal" class="calendar_checkbox" checked />&nbsp;&nbsp;<label
			for="allMyCal">내 캘린더</label>
		<button class="btn_edit" style="float: right;"
			onclick="addMyCalendar()">
			<i class='fas'>&#xf055;</i>
		</button>

		<%-- 내 캘린더를 보여주는 곳 --%>
		<div id="myCal" style="margin-left: 50px; margin-bottom: 10px;"></div>

		<input type="checkbox" id="sharedCal" class="calendar_checkbox"
			value="0" checked />&nbsp;&nbsp;<label for="sharedCal">공유받은
			캘린더</label>
	</div>

	<div id="wrapper2">
		<%-- 풀캘린더가 보여지는 엘리먼트  --%>
		<div id="calendar" style="margin: 100px 0 50px 0;"></div>
	</div>

</div>


<%-- === 내 캘린더 추가 Modal === --%>
<div class="modal fade" id="modal_addMyCal" role="dialog"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">

			<!-- Modal header -->
			<div class="modal-header">
				<h4 class="modal-title">내 캘린더 추가</h4>
				<button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
			</div>

			<!-- Modal body -->
			<div class="modal-body">
				<form name="modal_frm">
					<table style="width: 100%;" class="table table-bordered">
						<tr>
							<td style="text-align: left;">소분류명</td>
							<td><input type="text" class="add_my_small_category_name" /></td>
						</tr>
						<tr>
							<td style="text-align: left;">만든이</td>
							<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.member_name}</td>
							<%-- ${sesscionScope.loginuser.name} --%>
						</tr>
					</table>
				</form>
			</div>

			<!-- Modal footer -->
			<div class="modal-footer">
				<button type="button" id="addMy" class="btn btn-success btn-sm"
					onclick="goAddMyCal()">추가</button>
				<button type="button" class="btn btn-danger btn-sm modal_close"
					data-dismiss="modal">취소</button>
			</div>

		</div>
	</div>
</div>


<%-- === 마우스로 클릭한 날짜의 일정 등록을 위한 폼 === --%>
<form name="dateFrm">
	<input type="hidden" name="chooseDate" />
</form>
