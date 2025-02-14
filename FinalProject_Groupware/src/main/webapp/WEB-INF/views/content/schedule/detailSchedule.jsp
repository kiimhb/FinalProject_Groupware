<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
 	String ctxPath = request.getContextPath();
	//     /myspring
%>

<jsp:include page="../../header/header1.jsp" /> 

<style type="text/css">

	table#schedule{
		margin-top: 70px;
	}
	
	table#schedule th, td{
	 	padding: 10px 5px;
	 	vertical-align: middle;
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
		width: 70px;
		height: 30px;
		font-size: 12pt;
		padding: 3px 0px;
		margin-right: 10px;
		border-radius: 10%;
	}

</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		// ==== 종일체크박스에 체크를 할 것인지 안할 것인지를 결정하는 것 시작 ==== //
		// 시작 시 분
		var str_schedule_startdate = $("span#schedule_startdate").text();
	 // console.log(str_schedule_startdate); 
		// 2021-12-01 09:00
		var target = str_schedule_startdate.indexOf(":");
		var start_min = str_schedule_startdate.substring(target+1);
	 // console.log(start_min);
		// 00
		var start_hour = str_schedule_startdate.substring(target-2,target);
	 //	console.log(start_hour);
		// 09
		
		// 종료 시 분
		var str_schedule_enddate = $("span#schedule_enddate").text();
	//	console.log(str_enddate);
		// 2021-12-01 18:00
		target = str_schedule_enddate.indexOf(":");
		var end_min = str_schedule_enddate.substring(target+1);
	 // console.log(end_min);
	    // 00 
		var end_hour = str_schedule_enddate.substring(target-2,target);
	 //	console.log(end_hour);
		// 18
		
		if(start_hour=='00' && start_min=='00' && end_hour=='23' && end_min=='59' ){
			$("input#allDay").prop("checked",true);
		}
		else{
			$("input#allDay").prop("checked",false);
		}
		// ==== 종일체크박스에 체크를 할 것인지 안할 것인지를 결정하는 것 끝 ==== //
		
	}); // end of $(document).ready(function(){})==============================


	// ~~~~~~~ Function Declartion ~~~~~~~
	
	// 일정 삭제하기
	function delSchedule(schedule_no){
	
		var bool = confirm("일정을 삭제하시겠습니까?");
		
		if(bool){
			$.ajax({
				url: "<%= ctxPath%>/schedule/deleteSchedule",
				type: "post",
				data: {"schedule_no":schedule_no},
				dataType: "json",
				success:function(json){
					if(json.n==1){
						alert("일정을 삭제하였습니다.");
					}
					else {
						alert("일정을 삭제하지 못했습니다.");
					}
					
					location.href="<%= ctxPath%>/schedule/scheduleManagement";
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
			});
		}
		
	}// end of function delSchedule(scheduleno){}-------------------------


	// 일정 수정하기
	function editSchedule(schedule_no){
		var frm = document.goEditFrm;
		frm.schedule_no.value = schedule_no;
		
		frm.action = "<%= ctxPath%>/schedule/editSchedule";
		frm.method = "post";
		frm.submit();
	}

</script>

<div style="margin-left: 80px; width: 88%;">
<h3 style="display: inline-block;">일정 상세보기</h3>&nbsp;&nbsp;<a href="<%= ctxPath%>/schedule/scheduleManagement"><span>◀캘린더로 돌아가기</span></a> 

		<table id="schedule" class="table table-bordered">
			<tr>
				<th style="width: 160px; vertical-align: middle;">일자</th>
				<td>
					<span id="schedule_startdate">${requestScope.map.SCHEDULE_STARTDATE}</span>&nbsp;~&nbsp;<span id="schedule_enddate">${requestScope.map.SCHEDULE_ENDDATE}</span>&nbsp;&nbsp;  
					<input type="checkbox" id="allDay" disabled/>&nbsp;종일
				</td>
			</tr>
			<tr>
				<th style="vertical-align: middle;">제목</th>
				<td>${requestScope.map.SCHEDULE_SUBJECT}</td>
			</tr>
			
			<tr>
				<th style="vertical-align: middle;">캘린더종류</th>
				<td>
				<c:if test="${requestScope.map.FK_LARGE_CATEGORY_NO eq '2'}">
					사내 캘린더 - ${requestScope.map.FK_SMALL_CATEGORY_NO}
				</c:if>
				<c:if test="${requestScope.map.FK_LARGE_CATEGORY_NO eq '1'}">
					내 캘린더 - ${requestScope.map.FK_SMALL_CATEGORY_NO}
				</c:if></td>
			</tr>
			<tr>
				<th style="vertical-align: middle;">장소</th>
				<td>${requestScope.map.SCHEDULE_PLACE}</td>
			</tr>
			
			<tr>
				<th style="vertical-align: middle;">공유자</th>
				<td>${requestScope.map.SCHEDULE_JOINUSER}</td>
			</tr>
			<tr>
				<th style="vertical-align: middle;">내용</th>
				<td><textarea id="schedule_content" rows="10" cols="100" style="height: 200px; border: none;" readonly>${requestScope.map.SCHEDULE_CONTENT}</textarea></td>
			</tr>
			<tr>
				<th style="vertical-align: middle;">작성자</th>
				<td>${requestScope.map.MEMBER_NAME}</td>
			</tr>
		</table>
	
	<input type="hidden" value="${sessionScope.loginuser.member_name}" />
	<input type="hidden" value="${requestScope.map.fk_large_category_no}" />
	
	<c:set var="v_fk_member_userid" value="${requestScope.map.FK_MEMBER_USERID}" />
	<c:set var="v_fk_large_category_no" value="${requestScope.map.FK_LARGE_CATEGORY_NO}"/>
	<c:set var="v_loginuser_member_userid" value="${sessionScope.loginuser.member_userid}"/>

	<div style="float: right;">
		<c:if test="${not empty requestScope.listgobackURL_schedule}">
	    <%-- 
	               일정이 사내캘린더 인데, 로그인한 사용자가 4번 부서에 근무하는 3직급을 가진 사용자 이라면 
	        <c:if test="${v_fk_lgcatgono eq '2' && sessionScope.loginuser.fk_pcode =='3' && sessionScope.loginuser.fk_dcode == '4' }">  
	    --%>
			<c:if test="${v_fk_large_category_no eq '2' && sessionScope.loginuser.gradelevel == 10 }">
				<button type="button" id="edit" class="btn_normal" onclick="editSchedule('${requestScope.map.SCHEDULENO}')">수정</button>
				<button type="button" class="btn_normal" onclick="delSchedule('${requestScope.map.SCHEDULENO}')">삭제</button>
			</c:if>
			<c:if test="${v_fk_large_category_no eq '1' && v_fk_member_userid eq v_loginuser_member_userid}">
				<button type="button" id="edit" class="btn_normal" onclick="editSchedule('${requestScope.map.SCHEDULENO}')">수정</button>
				<button type="button" class="btn_normal" onclick="delSchedule('${requestScope.map.SCHEDULENO}')">삭제</button>
			</c:if>
				<button type="button" id="cancel" class="btn_normal" style="margin-right: 0px;" onclick="javascript:location.href='<%= ctxPath%>${requestScope.listgobackURL_schedule}'">취소</button> 
		</c:if>
		
		<c:if test="${empty requestScope.listgobackURL_schedule}">
		<%-- 
	               일정이 사내캘린더 인데, 로그인한 사용자가 4번 부서에 근무하는 3직급을 가진 사용자 이라면 
	        <c:if test="${v_fk_lgcatgono eq '2' && sessionScope.loginuser.fk_pcode =='3' && sessionScope.loginuser.fk_dcode == '4' }">  
	    --%>
	        <c:if test="${v_fk_large_category_no eq '2' && sessionScope.loginuser.gradelevel == 10 }">
				<button type="button" id="edit" class="btn_normal" onclick="editSchedule('${requestScope.map.SCHEDULENO}')">수정</button>
				<button type="button" class="btn_normal" onclick="delSchedule('${requestScope.map.SCHEDULENO}')">삭제</button>
			</c:if>
			<c:if test="${v_fk_large_category_no eq '1' && v_fk_member_userid eq v_loginuser_member_userid}">
				<button type="button" id="edit" class="btn_normal" onclick="editSchedule('${requestScope.map.SCHEDULENO}')">수정</button>
				<button type="button" class="btn_normal" onclick="delSchedule('${requestScope.map.SCHEDULENO}')">삭제</button>
			</c:if>
				<button type="button" id="cancel" class="btn_normal" style="margin-right: 0px; background-color: #990000;" onclick="javascript:location.href='<%= ctxPath%>/schedule/detailSchedule'">취소</button> 
		</c:if>
	
	</div>
</div>

<form name="goEditFrm">
	<input type="hidden" name="schedule_no"/>
	<input type="hidden" name="gobackURL_detailSchedule" value="${requestScope.gobackURL_detailSchedule}"/>
</form>

<jsp:include page="../../footer/footer1.jsp" />
