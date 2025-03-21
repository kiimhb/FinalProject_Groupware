<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
 	String ctxPath = request.getContextPath();
	//     /myspring
%>

<jsp:include page="../../header/header1.jsp" />

<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />

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

.header .title {
     border-left: 5px solid #006769;  /* 바 두께 증가 */
    padding-left: 1.5%;  /* 왼쪽 여백 조정 */
    font-size: 33px;  /* h2 크기와 유사하게 증가 */
    margin-top: 4%;
    margin-bottom: 2%;
    color: #4c4d4f;
    font-weight: bold;
}


button.btn_edit{
	border: none;
	background-color: #fff;
}




/* 기본 버튼 스타일 */
button.btn {
    background-color: #006769; /* 버튼 배경색 */
    color: white !important; /* 글자색 */
    border: none; /* 기본 테두리 제거 */
    padding: 5px 12px;
    font-size: 14px;
    cursor: pointer;
    border-radius: 5px; /* 둥근 모서리 */
    transition: all 0.3s ease-in-out;
}

/* 버튼 포커스 및 클릭 효과 */
button.btn:focus,
button.btn:active {
    outline: none !important; /* 포커스 시 기본 테두리 제거 */
    box-shadow: none !important; /* 추가적인 그림자 제거 */
}

/* 버튼 호버 효과 */
button.btn:hover {
    background-color: #509d9c; /* 약간 어두운 색으로 변경 */
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

.fc .fc-button-primary {
    color: var(--fc-button-text-color, #fff);
    background-color: #509d9c;

}

.fc .fc-button-primary:not(:disabled).fc-button-active, .fc .fc-button-primary:not(:disabled):active {
    color: var(--fc-button-text-color, #fff);
    background-color: #006769;
}	

.fc .fc-button-primary:disabled {  /* 오늘 버튼 */
	background-color: var(--fc-button-bg-color,#509d9c);
}

.fc-button-group {
	display:flex;
	gap:6px;
}

<%-- 검색어 입력 창 --%>
	input {
		/* background: #f0f0f0;  */
	  	width: 20%;
	  	color: #006769;
	  	border: none;
	  	border-bottom: 1px solid #999999; 
	  	padding: 9px;
	  	margin: 7px;
	}
	
	input:placeholder {
	  	color: rgba(255, 255, 255, 1);
	  	font-weight: 100;
	}
	
	input:focus {
	  	color: #006769;
	  	outline: none;
	  	border-bottom: 1.3px solid #006769; 
	  	transition: .8s all ease;
	}
	
	input:focus::placeholder {
	  	opacity: 0;
	}

<%-- select 태그 --%>
.top_select {
	padding: 5px;
	font-size: 14px;
	border-radius: 10px;
	color: #006769;
	border: solid 1px #8ac2bd;
}

<%-- 상단 검색 버튼 등 --%>
div#topSearch {
	text-align: right;
	margin-left: -5px; /* 버튼을 왼쪽으로 약간 이동 */
}
	
	
	
</style>


<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<script type="text/javascript">

$(document).ready(function(){
	
	// === 사내 캘린더에 사내캘린더 소분류 보여주기 ===
	showCompanyCal();

	// === 내 캘린더에 내캘린더 소분류 보여주기 ===
	showmyCal();
	
	// === 사내캘린더 체크박스 전체 선택/전체 해제 === //
	$("input:checkbox[id=allComCal]").click(function(){
		var bool = $(this).prop("checked");
		$("input:checkbox[name=com_small_category_no]").prop("checked", bool);
	});// end of $("input:checkbox[id=allComCal]").click(function(){})-------
	
	
	// === 내캘린더 체크박스 전체 선택/전체 해제 === //
	$("input:checkbox[id=allMyCal]").click(function(){		
		var bool = $(this).prop("checked");
		$("input:checkbox[name=my_small_category_no]").prop("checked", bool);
	});// end of $("input:checkbox[id=allMyCal]").click(function(){})-------
			
	
	// === 사내캘린더에 속한 특정 체크박스를 클릭할 경우 === 
	$(document).on("click","input:checkbox[name=com_small_category_no]",function(){	
		var bool = $(this).prop("checked");
		
		if(bool){ // 체크박스에 클릭한 것이 체크된 것이라면 
			
			var flag = false;
			
			$("input:checkbox[name=com_small_category_no]").each(function(index, item){
				var bChecked = $(item).prop("checked");
				
				if(!bChecked){     // 체크되지 않았다면 
					flag = true;     // flag를 true로 변경
					return false;  // 반복을 빠져 나옴.
				}
			}); // end of $("input:checkbox[name=com_small_category_no]").each(function(index, item){})---------

			if(!flag){ // 사내캘린더에 속한 서브캘린더의 체크박스가 모두 체크된 경우라면 			
                $("input#allComCal").prop("checked", true); // 사내캘린더 체크박스에 체크를 한다.
			}
			
			var com_SmallCategoryArr = document.querySelectorAll("input.com_small_category_no");
		    
			com_SmallCategoryArr.forEach(function(item) {
		         item.addEventListener("change", function() {  // "change" 대신에 "click"을 해도 무방함.
		         //	 console.log(item);
		        	 calendar.refetchEvents();  // 모든 소스의 이벤트를 다시 가져와 화면에 다시 표시합니다.
		         });
		    });// end of comSmallCategoryArr.forEach(function(item) {})---------------------

		}
		
		else {
			   $("input#allComCal").prop("checked", false);
		}
		
});// end of $(document).on("click","input:checkbox[name=com_small_category_no]",function(){})--------


	//=== 내캘린더에 속한 특정 체크박스를 클릭할 경우 === 
	$(document).on("click", "input:checkbox[name=my_small_category_no]", function () {
	    var bool = $(this).prop("checked");
	
	    if (bool) { // 체크박스에 클릭한 것이 체크된 것이라면
	        var flag = false;
	
	        $("input:checkbox[name=my_small_category_no]").each(function (index, item) {
	            var bChecked = $(item).prop("checked");
	
	            if (!bChecked) { // 체크되지 않았다면
	                flag = true; // flag를 true로 변경
	                return false; // 반복을 빠져 나옴.
	            }
	        }); // end of $("input:checkbox[name=my_small_category_no]").each(function (index, item) {})---------
	
	        if (!flag) { // 내캘린더에 속한 서브캘린더의 체크박스가 모두 체크된 경우라면
	            $("input#allMyCal").prop("checked", true); // 내캘린더 체크박스에 체크를 한다.
	        }
	
	        var my_SmallCategoryArr = document.querySelectorAll("input.my_small_category_no");
	
	        my_SmallCategoryArr.forEach(function (item) {
	            item.addEventListener("change", function () { // "change" 대신에 "click"을 해도 무방함.
	                // console.log(item);
	                calendar.refetchEvents(); // 모든 소스의 이벤트를 다시 가져와 화면에 다시 표시합니다.
	            });
	        }); // end of my_SmallCategoryArr.forEach(function (item) {})---------------------
	    } else {
	        $("input#allMyCal").prop("checked", false);
	    }
	}); // end of $(document).on("click", "input:checkbox[name=my_small_category_no]", function () {})--------

	

	// 검색할 때 필요한 datepicker
	// 모든 datepicker에 대한 공통 옵션 설정
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
//  $('input#toDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	
	
    // To의 초기값을 한달후 날짜로 설정
    $('input#toDate').datepicker('setDate', '+1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	
	
	// ==== 풀캘린더와 관련된 소스코드 시작(화면이 로드되면 캘린더 전체 화면 보이게 해줌) ==== //
	var calendarEl = document.getElementById('calendar');
        
    var calendar = new FullCalendar.Calendar(calendarEl, {
	 // === 구글캘린더를 이용하여 대한민국 공휴일 표시하기 시작 === //
     //	googleCalendarApiKey : "자신의 Google API KEY 입력",
        /*
            >> 자신의 Google API KEY 을 만드는 방법 <<
            1. 먼저 크롬 웹브라우저를 띄우고, 자신의 구글 계정으로 로그인 한다.
            2. https://console.developers.google.com 에 접속한다. 
            3. "API  API 및 서비스" 에서 "사용자 인증 정보" 를 클릭한다.
            4. ! 이 페이지를 보려면 프로젝트를 선택하세요 에서 "프로젝트 만들기" 를 클릭한다.
            5. 프로젝트 이름은 자동으로 나오는 값을 그대로 두고 그냥 "만들기" 버튼을 클릭한다. 
            6. 상단에 보여지는 사용자 인증 정보 옆의  "+ 사용자 인증 정보 만들기" 를 클릭하여 보여지는 API 키를 클릭한다.
                            그러면 API 키 생성되어진다.
            7. 생성된 API 키가  자신의 Google API KEY 이다.
            8. 애플리케이션에 대한 정보를 포함하여 OAuth 동의 화면을 구성해야 합니다. 에서 "동의 화면 구성" 버튼을 클릭한다.
            9. OAuth 동의 화면 --> User Type --> 외부를 선택하고 "만들기" 버튼을 클릭한다.
           10. 앱 정보 --> 앱 이름에는 "웹개발테스트"
                     --> 사용자 지원 이메일에는 자신의 구글계정 이메일 입력
                             하단부에 보이는 개발자 연락처 정보 --> 이메일 주소에는 자신의 구글계정 이메일 입력 
           11. "저장 후 계속" 버튼을 클릭한다. 
           12. 범위 --> "저장 후 계속" 버튼을 클릭한다.
           13. 테스트 사용자 --> "저장 후 계속" 버튼을 클릭한다.
           14. "API  API 및 서비스" 에서 "라이브러리" 를 클릭한다.
               Google Workspace --> Google Calendar API 를 클릭한다.
               "사용" 버튼을 클릭한다. 
        */
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
	    	  left: 'prev,today,next',
	          center: 'title',
	          right: 'dayGridMonth dayGridWeek dayGridDay'
	    },
	    dayMaxEventRows: true, // for all non-TimeGrid views
	    views: {
	      timeGrid: {
	        dayMaxEventRows: 3 // adjust to 6 only for timeGridWeek/timeGridDay
	      }
	    },
		
	 // ===================== DB와 연동하는 법 시작 ===================== //
	    events: function (info, successCallback, failureCallback) {
	        $.ajax({
	            url: '<%= ctxPath%>/schedule/selectSchedule',
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
	                                        url: "<%= ctxPath%>/schedule/detailSchedule?schedule_no="+item.schedule_no,
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
	                                        url: "<%= ctxPath%>/schedule/detailSchedule?schedule_no="+item.schedule_no,
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
	                                url: "<%= ctxPath%>/schedule/detailSchedule?schedule_no=" + item.schedule_no,
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
		    frm.action = "<%= ctxPath%>/schedule/insertSchedule";
		    frm.submit();
		},
		
		// === 사내캘린더, 내캘린더, 공유받은캘린더의 체크박스에 체크유무에 따라 일정을 보여주거나 숨기는 로직 === 
		eventDidMount: function(arg) {
		    var arr_calendar_checkbox = document.querySelectorAll("input.calendar_checkbox");
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
    
  calendar.render();  // 풀캘린더 보여주기
  
  var arr_calendar_checkbox = document.querySelectorAll("input.calendar_checkbox"); 
  // 사내캘린더, 내캘린더, 공유받은캘린더 에서의 체크박스임
  
  arr_calendar_checkbox.forEach(function(item) {
	  item.addEventListener("change", function () {
      // console.log(item);
		 calendar.refetchEvents(); // 모든 소스의 이벤트를 다시 가져와 화면에 다시 표시합니다.
    });
  });
  //==== 풀캘린더와 관련된 소스코드 끝(화면이 로드되면 캘린더 전체 화면 보이게 해줌) ==== //

  
  // 검색 할 때 엔터를 친 경우
  $("input#searchWord").keyup(function(event){
	 if(event.keyCode == 13){ 
		 goSearch();
	 }
  });
 
    
  // 모달 창에서 입력된 값 초기화 시키기 //
  $("button.modal_close").on("click", function(){
	  var modal_frmArr = document.querySelectorAll("form[name=modal_frm]");
	  for(var i=0; i<modal_frmArr.length; i++) {
		  modal_frmArr[i].reset();
	  }
  });
  
      
}); // end of $(document).ready(function(){})==============================


// ~~~~~~~ Function Declartion ~~~~~~~

// === 사내 캘린더 소분류 추가를 위해 +아이콘 클릭시 ===
function addComCalendar() {
    $('#modal_addComCal').modal('show'); // 모달창 보여주기
} // end of function addComCalendar(){}--------------------


// === 사내 캘린더 추가 모달창에서 추가 버튼 클릭시 ===
function goAddComCal() {
	
    if ($("input.add_com_small_category_name").val().trim() == "") {
        alert("추가할 사내캘린더 소분류명을 입력하세요!!");
        return;
        
    } else {
        $.ajax({
            url: "<%= ctxPath%>/schedule/addComCalendar",
            type: "post",
            data: {
                "com_small_category_name": $("input.add_com_small_category_name").val(),
                "fk_member_userid": "${sessionScope.loginuser.member_userid}"},
            dataType: "json",
            success: function (json) {
                if (json.n != 1) {
                    alert("이미 존재하는 '사내캘린더 소분류명' 입니다.");
                    return;
                    
                } 
                else if (json.n == 1) {
                    $('#modal_addComCal').modal('hide'); // 모달창 감추기
                    
                    alert("사내 캘린더에 " + $("input.add_com_small_category_name").val() + " 소분류명이 추가되었습니다.");

                    $("input.add_com_small_category_name").val("");
                    showCompanyCal(); // 사내 캘린더 소분류 보여주기
                }
            },
            error: function (request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
    }
} // end of function goAddComCal(){}------------------------------------



//=== 사내 캘린더에서 사내캘린더 소분류 보여주기 === //
function showCompanyCal() {
    $.ajax({
        url: "<%= ctxPath%>/schedule/showCompanyCalendar",
        type: "get",
        dataType: "json",
        success: function (json) {
            var html = "";

            if (json.length > 0) {
                html += "<table style='width:80%;'>";

                $.each(json, function (index, item) {
                    html += "<tr style='font-size: 11pt;'>";
                    html += "<td style='width:60%; padding: 3px 0px;'><input type='checkbox' name='com_small_category_no' class='calendar_checkbox com_small_category_no' style='margin-right: 3px;' value='" + item.small_category_no + "' checked id='com_small_category_no_" + index + "'/><label for='com_small_category_no_" + index + "'>" + item.small_category_name + "</label></td>";

                    // 사내 캘린더 추가를 할 수 있는 조건: member_grade이 1인 경우
                    if ("${sessionScope.loginuser.member_grade}" == '1') {
                        html += "<td style='width:20%; padding: 3px 0px;'><button class='btn_edit' data-target='editCal' onclick='editComCalendar(" + item.small_category_no + ",\"" + item.small_category_name + "\")'><i class='fas fa-edit'></i></button></td>";
                        html += "<td style='width:20%; padding: 3px 0px;'><button class='btn_edit delCal' onclick='delCalendar(" + item.small_category_no + ",\"" + item.small_category_name + "\")'><i class='fas fa-trash'></i></button></td>";
                    }

                    html += "</tr>";
                });

                html += "</table>";
            }

            $("div#companyCal").html(html);
        },
        error: function (request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    });
} // end of function showCompanyCal()------------------



//=== 사내 캘린더내의 서브캘린더 수정 모달창 나타나기 === 
function editComCalendar(small_category_no, small_category_name) {
    $('#modal_editComCal').modal('show'); // 모달 보이기
    $("input.edit_com_small_category_no").val(small_category_no);
    $("input.edit_com_small_category_name").val(small_category_name);
} // end of function editComCalendar(small_category_no, small_category_name){}----------------------


// === 사내 캘린더내의 서브캘린더 수정 모달창에서 수정하기 클릭 === 
function goEditComCal() {

    if ($("input.edit_com_small_category_name").val().trim() == "") {
        alert("수정할 사내캘린더 소분류명을 입력하세요!!");
        return;
    } else {
        $.ajax({
            url: "<%= ctxPath%>/schedule/editCalendar",
            type: "post",
            data: {
                "small_category_no": $("input.edit_com_small_category_no").val(),
                "small_category_name": $("input.edit_com_small_category_name").val(),
                "member_userid": "${sessionScope.loginuser.member_userid}",
                "caltype": "2" // 사내캘린더
            },
            dataType: "json",
            success: function (json) {
                if (json.n == 0) {
                    alert($("input.edit_com_small_category_name").val() + "은(는) 이미 존재하는 캘린더 명입니다.");
                    return;
                }
                if (json.n == 1) {
                    $('#modal_editComCal').modal('hide'); // 모달 숨기기
                    alert("사내 캘린더명을 수정하였습니다.");
                    showCompanyCal();
                }
            },
            error: function (request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
    }

} // end of function goEditComCal(){}--------------------------------



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //	

// === 내 캘린더 소분류 추가를 위해 +아이콘 클릭시 ===
function addMyCalendar() {
    $('#modal_addMyCal').modal('show');
} // end of function addMyCalendar(){}-----------------


// === 내 캘린더 추가 모달창에서 추가 버튼 클릭시 === 
function goAddMyCal() {

    if ($("input.add_my_small_category_name").val().trim() == "") {
        alert("추가할 내캘린더 소분류명을 입력하세요!!");
        return;
    } else {
        $.ajax({
            url: "<%= ctxPath%>/schedule/addMyCalendar",
            type: "post",
            data: {
                "my_small_category_name": $("input.add_my_small_category_name").val(),
                "fk_member_userid": "${sessionScope.loginuser.member_userid}"
                // "${sessionScope.loginuser.member_userid}"
            },
            dataType: "json",
            success: function (json) {

                if (json.n != 1) {
                    alert("이미 존재하는 '내캘린더 소분류명' 입니다.");
                    return;
                    
                }
                else if (json.n == 1) {
                    $('#modal_addMyCal').modal('hide'); // 모달창 감추기
                    alert("내 캘린더에 " + $("input.add_my_small_category_name").val() + " 소분류명이 추가되었습니다.");

                    $("input.add_my_small_category_name").val("");
                    showmyCal(); // 내 캘린더 소분류 보여주기
                }
            },
            error: function (request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
    }

} // end of function goAddMyCal(){}-----------------------


//=== 내 캘린더에서 내캘린더 소분류 보여주기  === //
function showmyCal() {
    $.ajax({
        url: "<%= ctxPath%>/schedule/showMyCalendar",
        type: "get",
        data: { "fk_member_userid": "${sessionScope.loginuser.member_userid}" },
        // "${sessionScope.loginuser.member_userid}"
        dataType: "json",
        success: function (json) {
            var html = "";
            if (json.length > 0) {
                html += "<table style='width:80%;'>";

                $.each(json, function (index, item) {
                    html += "<tr style='font-size: 11pt;'>";
                    html += "<td style='width:60%; padding: 3px 0px;'><input type='checkbox' name='my_small_category_no' class='calendar_checkbox my_small_category_no' style='margin-right: 3px;' value='" + item.small_category_no + "' checked id='my_small_category_no_" + index + "'/><label for='my_small_category_no_" + index + "'>" + item.small_category_name + "</label></td>";
                    html += "<td style='width:20%; padding: 3px 0px;'><button class='btn_edit editCal' data-target='editCal' onclick='editMyCalendar(" + item.small_category_no + ",\"" + item.small_category_name + "\")'><i class='fas fa-edit'></i></button></td>";
                    html += "<td style='width:20%; padding: 3px 0px;'><button class='btn_edit delCal' onclick='delCalendar(" + item.small_category_no + ",\"" + item.small_category_name + "\")'><i class='fas fa-trash'></i></button></td>";
                    html += "</tr>";
                });

                html += "</table>";
            }

            $("div#myCal").html(html);
        },
        error: function (request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    });
} // end of function showmyCal()---------------------



//=== 내 캘린더내의 서브캘린더 수정 모달창 나타나기 === 
function editMyCalendar(small_category_no, small_category_name) {
    $('#modal_editMyCal').modal('show');  // 모달 보이기
    $("input.edit_my_small_category_no").val(small_category_no);
    $("input.edit_my_small_category_name").val(small_category_name);
} // end of function editMyCalendar(small_category_no, small_category_name){}-----------------------


// === 내 캘린더내의 서브캘린더 수정 모달창에서 수정 클릭 === 
function goEditMyCal() {

    if ($("input.edit_my_small_category_name").val().trim() == "") {
        alert("수정할 내캘린더 소분류명을 입력하세요!!");
        return;
    } else {
        $.ajax({
            url: "<%= ctxPath%>/schedule/editCalendar",
            type: "post",
            data: {
                "small_category_no": $("input.edit_my_small_category_no").val(),
                "small_category_name": $("input.edit_my_small_category_name").val(),
                "member_userid": "${sessionScope.loginuser.member_userid}",
                // "${sessionScope.loginuser.member_userid}"
                "caltype": "1"  // 내캘린더
            },
            dataType: "json",
            success: function (json) {
                if (json.n == 0) {
                    alert($("input.edit_com_small_category_name").val() + "은(는) 이미 존재하는 캘린더 명입니다.");
                    return;
                }
                if (json.n == 1) {
                    $('#modal_editMyCal').modal('hide'); // 모달 숨기기
                    alert("내캘린더명을 수정하였습니다.");
                    showmyCal();
                }
            },
            error: function (request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
    }
} // end of function goEditMyCal(){}-------------------------------------

	

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//		

// === (사내캘린더 또는 내캘린더)속의 소분류 카테고리 삭제하기 === 
function delCalendar(small_category_no, small_category_name) { // small_category_no => 캘린더 소분류 번호, small_category_name => 캘린더 소분류 명

    var bool = confirm(small_category_name + " 캘린더를 삭제 하시겠습니까?");

    if (bool) {
        $.ajax({
            url: "<%= ctxPath%>/schedule/deleteSubCalendar",
            type: "post",
            data: {"small_category_no": small_category_no },
            dataType: "json",
            success: function (json) {
                if (json.n == 1) {
                    alert(small_category_name + " 캘린더를 삭제하였습니다.");
                    location.href = "javascript:history.go(0);"; // 페이지 새로고침
                }
            },
            error: function (request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
    }

}// end of function delCalendar(small_category_no, small_category_name){}------------------------


// === 검색 기능 === 
function goSearch() {

    if ($("#fromDate").val() > $("#toDate").val()) {
        alert("검색 시작날짜가 검색 종료날짜 보다 크므로 검색할 수 없습니다.");
        return;
    }

    if ($("select#searchType").val() == "" && $("input#searchWord").val() != "") {
        alert("검색대상 선택을 해주세요!!");
        return;
    }

    if ($("select#searchType").val() != "" && $("input#searchWord").val() == "") {
        alert("검색어를 입력하세요!!");
        return;
    }

    var frm = document.searchScheduleFrm;
    frm.method = "get";
    frm.action = "<%= ctxPath%>/schedule/searchSchedule";
    frm.submit();

}// end of function goSearch(){}--------------------------


</script>

<div id="sub_mycontent">

<div style="margin-left: 80px; width: 88%;">
	
	<div class="header">
			<div class="title">일정 관리</div>
	</div>
	
	<div id="wrapper1">
		<input type="hidden" value="${sessionScope.loginuser.member_userid}" id="fk_member_userid"/>
		<%-- value="${sessionScope.loginuser.member_userid}" --%>
		
		<input type="checkbox" id="allComCal" class="calendar_checkbox" checked/>&nbsp;&nbsp;<label for="allComCal">사내 캘린더</label>
	
	<%-- 사내 캘린더 추가를 할 수 있는 직원은 직위코드가 3 이면서 부서코드가 4 에 근무하는 사원이 로그인 한 경우에만 가능하도록 조건을 걸어둔다.  	
	     <c:if test="${sessionScope.loginuser.fk_pcode =='3' && sessionScope.loginuser.fk_dcode == '4' }"> --%>
	     <c:if test="${sessionScope.loginuser.member_grade =='1'}"> 
		 	<button class="btn_edit" style="float: right;" onclick="addComCalendar()"><i class='fas'>&#xf055;</i></button>
		 </c:if> 
	<%-- </c:if> --%> 
	    
	    <%-- 사내 캘린더를 보여주는 곳 --%>
		<div id="companyCal" style="margin-left: 50px; margin-bottom: 10px;"></div>
		
		
		<input type="checkbox" id="allMyCal" class="calendar_checkbox" checked/>&nbsp;&nbsp;<label for="allMyCal">내 캘린더</label>
		<button class="btn_edit" style="float: right;" onclick="addMyCalendar()"><i class='fas'>&#xf055;</i></button>
		
		<%-- 내 캘린더를 보여주는 곳 --%>
		<div id="myCal" style="margin-left: 50px; margin-bottom: 10px;"></div>

		<input type="checkbox" id="sharedCal" class="calendar_checkbox" value="0" checked/>&nbsp;&nbsp;<label for="sharedCal">공유받은 캘린더</label> 
	</div>
	
	<div id="wrapper2">
		<div id="searchPart" style="float: right;">
			<div id="topSearch">
					<form name="searchScheduleFrm">
						<div>
							<input type="text" id="fromDate" name="schedule_startdate" class="topClass top_select" style="width: 110px;" readonly="readonly">&nbsp;&nbsp; 
			            -&nbsp;&nbsp; <input type="text" id="toDate" name="schedule_enddate" class="topClass top_select" style="width: 110px;" readonly="readonly">&nbsp;&nbsp;
							<select id="searchType" name="searchType" class="topClass top_select" style="height: 30px;">
								<option value="">검색대상선택</option>
								<option value="schedule_subject">제목</option>
								<option value="schedule_content">내용</option>
								<option value="schedule_joinuser">공유자</option>
							</select>&nbsp;&nbsp; 	
							<input type="text" id="searchWord" class="topClass" value="" style="height: 30px; width:150px;" name="searchWord" placeholder="검색어 입력"/>
							&nbsp;&nbsp;
							<select id="sizePerPage" name="sizePerPage" class="topClass top_select" style="height: 30px;">
								<option value="">보여줄개수</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
							</select>&nbsp;&nbsp;
							<input type="hidden" name="fk_member_userid" value="${sessionScope.loginuser.member_userid}" />
							<button type="button" class="btn ml-2" style="display: inline-block;" onclick="goSearch()">검색</button>
						</div>
					</form>
			</div>
		</div>
				
	    <%-- 풀캘린더가 보여지는 엘리먼트  --%>
		<div id="calendar" style="margin: 100px 0 50px 0;" ></div>
	</div>
		
</div>


<%-- === 사내 캘린더 추가 Modal === --%>
<div class="modal fade" id="modal_addComCal" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">사내 캘린더 추가</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
        <form name="modal_frm">
        <table style="width: 100%;" class="table table-bordered">
      			<tr>
      				<td style="text-align: left;">소분류명</td>
      				<td><input type="text" class="add_com_small_category_name" name="small_category_name"/></td>
      			</tr>
      			<tr>
      				<td style="text-align: left;">만든이</td>
      				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.member_name}</td>
      				<%-- ${sesscionScope.loginuser.member_name} --%>
      			</tr>
      		</table>
        </form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goAddComCal()">추가</button>
        <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>


<%-- === 사내 캘린더 수정 Modal === --%>
<div class="modal fade" id="modal_editComCal" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">사내 캘린더 수정</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
        <form name="modal_frm">
        <table style="width: 100%;" class="table table-bordered">
      			<tr>
      				<td style="text-align: left;">소분류명</td>
      				<td><input type="text" class="edit_com_small_category_name" name="small_category_name"/><input type="hidden" value="" class="edit_com_small_category_no" name="small_category_no"></td>
      			</tr>
      			<tr>
      				<td style="text-align: left;">만든이</td>
      				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.member_name}</td>
      				<%-- ${sesscionScope.loginuser.member_name} --%>
      			</tr>
      		</table>
        </form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goEditComCal()">수정</button>
        <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>


<%-- === 내 캘린더 추가 Modal === --%>
<div class="modal fade" id="modal_addMyCal" role="dialog" data-backdrop="static">
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
      	<button type="button" id="addMy" class="btn btn-success btn-sm" onclick="goAddMyCal()">추가</button>
        <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>


<%-- === 내 캘린더 수정 Modal === --%>
<div class="modal fade" id="modal_editMyCal" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">내 캘린더 수정</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
      	<form name="modal_frm">
        	<table style="width: 100%;" class="table table-bordered">
      			<tr>
      				<td style="text-align: left;">소분류명</td>
      				<td><input type="text" class="edit_my_small_category_name"/><input type="hidden" value="" class="edit_my_small_category_no"></td>
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
      	<button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goEditMyCal()">수정</button>
        <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>


<%-- === 마우스로 클릭한 날짜의 일정 등록을 위한 폼 === --%>     
<form name="dateFrm">
	<input type="hidden" name="chooseDate" />	
</form>	

</div>

<jsp:include page="../../footer/footer1.jsp" />
