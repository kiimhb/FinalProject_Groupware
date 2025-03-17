<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String ctxPath = request.getContextPath();
//     /myspring
%>
<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/attendance/commute.css" />
<jsp:include page="../../header/header1.jsp" />


<div id="sub_mycontent">

		<div class="manag_h3">
			<h3>근태관리 <근태조회></h3>
		</div>
		
		
	<div class="sub_work_count">
	
			<table>
				<thead>
					<tr>
						<th rowspan="2">부서</th>
						<th rowspan="2">직급</th>
						<th rowspan="2">이름</th>
						<th rowspan="2">기초계</th>
						<th rowspan="2">사고계</th>
						<th colspan="3">사고내역</th>
						<th colspan="5">기초항목</th>
					</tr>
					<tr>
						<th>휴가</th>
						<th>기타</th>
						<th>계</th>

						<th>정상</th>
						<th>지각</th>
						<th>조퇴</th>
						<th>결근</th>
						<th>계</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>${sessionScope.loginuser.child_dept_name}</td>
						<td>${sessionScope.loginuser.member_position}</td>
						<td>${sessionScope.loginuser.member_name}</td>

						<td>${commute_count[0].total_count}</td>
						<td>${commute_count[0].day_leave_cnt}</td>

						<td>${commute_count[0].day_leave_cnt}</td>
						<td>0</td>
						<td>${commute_count[0].day_leave_cnt}</td>

						<td>${commute_count[0].click}</td>
						<td>${commute_count[0].late}</td>
						<td>${commute_count[0].leave}</td>
						<td>${commute_count[0].absent}</td>
						<td>${commute_count[0].total_count}</td>

					</tr>
				</tbody>
			</table>


		<div class="commuteList">
			<table class="commuteListTable">
				<thead>
					<tr>
						<th>순서</th>
						<th>날짜</th>
						<th>출근시각</th>
						<th>출근상태</th>
						<th>퇴근시각</th>
						<th>퇴근상태</th>
					</tr>
				</thead>

				<tbody>
					<c:if test="${not empty requestScope.work_count}">
						<c:forEach var="work_countVO" items="${requestScope.work_count}"
							varStatus="status">
							<tr>
								<td align="center" id="pageBar">${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (status.index) }</td>
								<td>${work_countVO.work_recorddate}</td>
								<c:if test="${empty work_countVO.work_starttime}">
									<td>출근 기록 없음</td>
								</c:if>
								<c:if test="${not empty work_countVO.work_starttime}">
									<td>${work_countVO.work_starttime}</td>
								</c:if>
								<c:choose>
									<c:when test="${work_countVO.work_startstatus eq 0}">
										<td>출근</td>
									</c:when>
									<c:when test="${work_countVO.work_startstatus eq 1}">
										<td>지각</td>
									</c:when>
									<c:when test="${work_countVO.work_startstatus eq 2}">
										<td>결근</td>
									</c:when>
								</c:choose>

								<c:if test="${empty work_countVO.work_endtime}">
									<td>퇴근 기록 없음</td>
								</c:if>
								<c:if test="${not empty work_countVO.work_endtime}">
									<td>${work_countVO.work_endtime}</td>
								</c:if>
								<c:choose>
									<c:when test="${work_countVO.work_endstatus eq 0}">
										<td>퇴근</td>
									</c:when>
									<c:when test="${work_countVO.work_endstatus eq 1}">
										<td>조퇴</td>
									</c:when>
									<c:when test="${work_countVO.work_endstatus eq 2}">
										<td>결근</td>
									</c:when>
								</c:choose>
							</tr>
						</c:forEach>
					</c:if>

					<c:if test="${empty requestScope.work_count}">
						<tr>
							<td colspan="15">조회할 출퇴근 현황 없습니다.</td>
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