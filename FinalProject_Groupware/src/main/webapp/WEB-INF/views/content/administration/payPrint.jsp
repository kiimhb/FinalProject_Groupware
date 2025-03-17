<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" >

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/printpay.css" />

<script type="text/javascript">
$(document).ready(function(){  
	
	setTimeout(function() {
	    window.close();  // 인쇄 후 창을 닫기
	    setTimeout(function() {
	        window.location.href = `<%= ctxPath%>/pay/wait`; // 페이지 이동
	    }, 1000); // 페이지 이동을 조금 더 기다린 후에 처리
	}, 2000); // 2초 후 창을 닫고 페이지 이동 준비
});

</script>
<body>
<div id="sub_mycontent">
	<div id="all">
	    <table class="table" border="1" cellspacing="0" cellpadding="10">
	        <!-- 헤더 행 -->
	        <tr class="printheader" >
	            <td colspan="4" style="text-align: center; font-size: 20px; font-weight: bold;">처방전</td>
	        </tr>
	        <!-- 이름, 병명 정보 -->
			<tr>
				<td style="font-weight: bold; text-align: center;">환자번호</td>
	            <td colspan="3">${requestScope.pay_patientInfo.patient_no}</td>
			</tr>
	        <tr>
	            <td style="font-weight: bold; text-align: center;">이름</td>
	            <td>${requestScope.pay_patientInfo.patient_name}</td>
	            <td style="font-weight: bold; text-align: center;">의료기관명</td>
	            <td>마포아삭병원</td>
	        </tr>
	        <tr>
	            <td style="font-weight: bold; text-align: center;">주민등록번호</td>
	            <td>${requestScope.pay_patientInfo.patient_jubun}</td>
				<c:set var="today" value="<%= new java.text.SimpleDateFormat(\"yyyy-MM-dd\").format(new java.util.Date()) %>" />
	            <td style="font-weight: bold; text-align: center;">처방일</td>
	            <td>${today}</td>
	        </tr>
	        <!-- 약품명과 복용 방법이 세로로 나열되는 부분 -->
	        <tr>
	            <td style="font-weight: bold; vertical-align: top; text-align: center;">처방약</td>

				<td style="vertical-align: top;" colspan="3">  
				<c:forEach var="pvo" items="${requestScope.prescribe_list}">
	               <div style="display: block;">
					${pvo.prescribe_name}
						<c:if test="${not empty pvo.prescribe_morning and pvo.prescribe_morning == 1}">
							아침
						</c:if>
						<c:if test="${not empty pvo.prescribe_afternoon and pvo.prescribe_afternoon == 1}">
							점심
						</c:if>
						<c:if test="${not empty pvo.prescribe_night and pvo.prescribe_night == 1}">
							저녁
						</c:if>  
						<!-- 식전복용, 식후복용 -->				
					    <c:choose>
							<c:when test="${pvo.prescribe_beforeafter == 0}">
								식후
							</c:when>
							<c:when test="${pvo.prescribe_beforeafter == 1}">
								식전
							</c:when>
						</c:choose> 
					</div>
				</c:forEach>
				</td>
				
	        </tr>
	
			<tr>
				<td style="font-weight: bold; vertical-align: top; text-align: center;">진단명</td>
				<td>${requestScope.pay_patientInfo.order_desease_name}</td>
				<td style="font-weight: bold; vertical-align: top; text-align: center;">처방금액</td>
				<td>
					<c:forEach var="cvo" items="${requestScope.cost_list}">
						<div style="display: block;">
						${cvo.cost_item}
						<fmt:formatNumber value="${cvo.cost}" pattern="#,###"/>원
						</div>
					</c:forEach>
				</td>
			</tr>
			<tr>
				<td style="font-weight: bold; vertical-align: top; text-align: center;">총 금액</td>
				<td colspan="3">
				<c:forEach var="cvo" items="${requestScope.cost_list}" varStatus="status">
					<c:if test="${status.index == 0}">
						<fmt:formatNumber value="${cvo.total_cost}" pattern="#,###"/>원
					</c:if>
				</c:forEach>
				</td>
			</tr>
			<tr>
				<td colspan="4" style="text-align: center; font-size: 20px; font-weight: bold;">상세내용</td>
			</tr>
			<tr>
				<td colspan="4" rowspan="10" style="text-align: center; font-size: 20px; font-weight: bold; background-color: #f0f0f0; vertical-align: top;">
	                <!-- 빈 내용: 공간을 차지하기 위해 사용 -->
					<div style="height: 900px; width: 100%;"></div>
	            </td>
			</tr>
			
	    </table>
	</div>
</div>
</body>
