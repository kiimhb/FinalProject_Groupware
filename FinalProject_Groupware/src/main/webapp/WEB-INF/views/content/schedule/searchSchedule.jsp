<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% 
	String ctxPath = request.getContextPath(); 
    //    /myspring
%>

<jsp:include page="../../header/header1.jsp" />

<style type="text/css">
	
	th, td{
	 	padding: 10px 5px;
	 	vertical-align: middle;
	}
	
	tr.infoSchedule{
		background-color: white;
		cursor: pointer;
	}
	
	a{
	    color: #395673;
	    text-decoration: none;
	    cursor: pointer;
	}
	
	a:hover {
	    color: #395673;
	    cursor: pointer;
	    text-decoration: none;
		font-weight: bold;
	}
	
	button.btn_normal{
		background-color: #0071bd;
		border: none;
		color: white;
		width: 50px;
		height: 30px;
		font-size: 12pt;
		padding: 3px 0px;
	}
	
	.header .title {
    border-left: 5px solid #006769;  /* 바 두께 증가 */
    padding-left: 1.5%;  /* 왼쪽 여백 조정 */
    font-size: 28px;  /* h2 크기와 유사하게 증가 */
    margin-top: 2%;
    margin-bottom: 2%;
    color: #4c4d4f;
    font-weight: bold;
}

/* 테이블 본문 스타일 */
#schedule tbody td {
    text-align: center; /* 내용 가운데 정렬 */
    vertical-align: middle;
    padding: 12px;
    border-bottom: 1px solid #dee2e6;
    word-break: break-word; /* 길이가 길면 자동 줄바꿈 */
    white-space: normal;
}

  button.btn {
	background-color: #006769;
	color:white;
	.no-outline:focus 
    outline: none; /* 포커스 시 파란 테두리 제거 */
    box-shadow: none; /* 추가적인 파란색 그림자 제거 */
  }
  
  /* 페이지바 */
div#pageBar_bottom a {
	color: #509d9c !important;
	cursor: pointer;
}
#pageBar_bottom > ul > li {
	color: #006769 !important;
	font-weight: bold;
	cursor: pointer;
}

</style>

<%-- 검색할 때 필요한 datepicker 의 색상을 기본값으로 사용하기 위한 것임 --%>
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css"> 

<script type="text/javascript">
	$(document).ready(function(){
		
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
		    
		// From의 초기값을 한달 전 날짜로 설정
	    $('input#fromDate').datepicker('setDate', '-1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
	    
	    // To의 초기값을 한달 후 날짜로 설정
	    $('input#toDate').datepicker('setDate', '+1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	
		    
		// 일정 목록의 행 클릭 시 상세 보기 이동
		$("tr.infoSchedule").click(function(){
			// console.log($(this).html());
			var schedule_no = $(this).children(".schedule_no").text();
			goDetail(schedule_no);
		});
		
		// 검색 할 때 엔터를 친 경우
	    $("input#searchWord").keyup(function(event){
		   if(event.keyCode == 13){ 
			  goSearch();
		   }
	    });
	      
	    // 검색 필드 초기화
	    if (${not empty requestScope.paraMap}) {
	    	  $("input[name=schedule_startdate]").val("${requestScope.paraMap.schedule_startdate}");
	    	  $("input[name=schedule_enddate]").val("${requestScope.paraMap.schedule_enddate}");
			  $("select#searchType").val("${requestScope.paraMap.searchType}");
			  $("input#searchWord").val("${requestScope.paraMap.searchWord}");
			  $("select#sizePerPage").val("${requestScope.paraMap.str_sizePerPage}");
			  $("select#fk_large_category_no").val("${requestScope.paraMap.fk_large_category_no}");
		}
		 
	}); // end of $(document).ready(function(){}-------------
	
	
	// ~~~~~~~ Function Declartion ~~~~~~~
	
	function goDetail(schedule_no) { 
		var frm = document.goDetailFrm;
		frm.schedule_no.value = schedule_no; 
		
		frm.method = "get";
		frm.action = "<%= ctxPath%>/schedule/detailSchedule";
		frm.submit();
	} // end of function goDetail(schedule_no){}-------------------------- 
				
	// 검색 기능
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
	}

</script>

<div style="margin-left: 80px; width: 88%;">
	<div>
		<div class="header">
		
	  		<div class="title">일정 검색결과</div>
		 </div>
	 &nbsp;&nbsp;<a href="<%= ctxPath%>/schedule/scheduleManagement"><span>◀캘린더로 돌아가기</span></a>

		<div id="searchPart" style="float: right; margin-top: 50px;">
			<form name="searchScheduleFrm">
				<div>
					<input type="text" id="fromDate" name="schedule_startdate" style="width: 90px;" readonly="readonly">&nbsp;&nbsp; 
	            -&nbsp;&nbsp; <input type="text" id="toDate" name="schedule_enddate" style="width: 90px;" readonly="readonly">&nbsp;&nbsp;
	            	<select id="fk_large_category_no" name="fk_large_category_no" style="height: 30px;">
						<option value="">모든캘린더</option>
						<option value="1">내 캘린더</option>
						<option value="2">사내 캘린더</option>
					</select>&nbsp;&nbsp;	
					<select id="searchType" name="searchType" style="height: 30px;">
						<option value="">검색대상선택</option>
						<option value="schedule_subject">제목</option>
						<option value="schedule_content">내용</option>
						<option value="schedule_joinuser">공유자</option>
					</select>&nbsp;&nbsp;	
					<input type="text" id="searchWord" value="${requestScope.searchWord}" style="height: 30px; width:120px;" name="searchWord"/> 
					&nbsp;&nbsp;
					<select id="sizePerPage" name="sizePerPage" style="height: 30px;">
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
	
	<table id="schedule" class="table table-hover" style="margin: 100px 0 30px 0;">
		<thead>
			<tr>
				<th style="text-align: center; width: 21%;">일자</th>
				<th style="text-align: center; width: 15%;">캘린더종류</th>
				<th style="text-align: center; width: 7%;">등록자</th>
				<th style="text-align: center; width: 22%">제목</th>
				<th style="text-align: center;">내용</th>
			</tr>
		</thead>
		
		<tbody>
			<c:if test="${empty requestScope.scheduleList}">
				<tr>
					<td colspan="5" style="text-align: center;">검색 결과가 없습니다.</td>
				</tr>
			</c:if>
			<c:if test="${not empty requestScope.scheduleList}">
				<c:forEach var="map" items="${requestScope.scheduleList}">
					<tr class="infoSchedule">
						<td style="display: none;" class="schedule_no">${map.SCHEDULE_NO}</td>
						<td>
	                        <div>${map.SCHEDULE_STARTDATE}</div>
	                        <div>- ${map.SCHEDULE_ENDDATE}</div>
                   		</td>
						<td>${map.LARGE_CATEGORY_NAME} - ${map.SMALL_CATEGORY_NAME}</td>
						<td>${map.MEMBER_NAME}</td>  <%-- 캘린더 작성자명 --%>
						<td>${map.SCHEDULE_SUBJECT}</td>
						<td>${map.SCHEDULE_CONTENT}</td>
					</tr>
				</c:forEach>
			</c:if>
		</tbody>
	</table>

	<%-- === 페이지바 === --%>
	<div align="center" id="pageBar_bottom" style="width: 70%; border: solid 0px gray; margin: 20px auto;">${requestScope.pageBar}</div> 
    <div style="margin-bottom: 20px;">&nbsp;</div>
</div>

<form name="goDetailFrm"> 
   <input type="hidden" name="schedule_no"/>
   <input type="hidden" name="listgobackURL_schedule" value="${requestScope.listgobackURL_schedule}"/>
</form> 

<jsp:include page="../../footer/footer1.jsp" />
