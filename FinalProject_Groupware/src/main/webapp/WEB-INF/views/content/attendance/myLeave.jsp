<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String ctxPath = request.getContextPath();
//     /myspring
%>

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css"
	href="<%=ctxPath%>/css/attendance/leave.css" />
<jsp:include page="../../header/header1.jsp" />


<div id="sub_mycontent">

	<div class="manag_h3">
		<h3>
			근태관리
			<휴가관리>
		</h3>
	</div>

	<div class="sub_leave_count">

		<table  class="myLeavetotalTable">
			<thead>
				<tr>
					<th>연차개수</th>
					<th>연차소진개수</th>
			</thead>
			<tbody>
				<tr>
					<td>${myLeave_count[0].member_yeoncha}</td>
					<td>${myLeave_count[0].day_leave_cnt}</td>
				</tr>
			</tbody>
		</table>


		<div class="myLeavelist">
			<table class="myLeavelistTable">
				<thead>
					<tr>
						<th>순서</th>
						<th>연차시작날짜</th>
						<th>연차마지막날짜</th>
						<th>연차소진개수</th>
						<th>승인상태</th>
					</tr>
				</thead>

				<tbody>
					<c:if test="${not empty requestScope.myLeave_list}">
						<c:forEach var="myLeave_listVO"
							items="${requestScope.myLeave_list}" varStatus="status">
							<tr>
								<td align="center" id="pageBar">${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (status.index) }</td>
								<td>${myLeave_listVO.day_leave_start}</td>
								<td>${myLeave_listVO.day_leave_end}</td>
								<td>${myLeave_listVO.day_leave_cnt}</td>
								<td>${myLeave_listVO.draft_status}</td>
						</c:forEach>
					</c:if>

					<c:if test="${empty requestScope.myLeave_list}">
						<tr>
							<td colspan="5">조회할 연차관리가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
		<div>
			<div align="center"
				style="border: solid 0px gray; width: 80%; margin: 20px auto;">${requestScope.pageBar}</div>
		</div>
		
		
	</div>
</div>
<jsp:include page="../../footer/footer1.jsp" />
