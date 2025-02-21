<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%
String ctxPath = request.getContextPath();
//     /med-groupware
%>
<jsp:include page="../../header/header1.jsp" />

<div class="subContent">

	<div class="manag_h3">
		<h3>사원등록 완료</h3>
	</div>

	<c:if test="${not empty requestScope.managFormDetail}">
	 ${managFormDetail.member_userid}
	 ${managFormDetail.child_dept_name}
	 ${managFormDetail.member_name}
	 ${managFormDetail.member_mobile}
	 ${managFormDetail.member_email}
	 ${managFormDetail.member_birthday}
	 ${managFormDetail.member_gender}
	 ${managFormDetail.member_start}
	 ${managFormDetail.member_pro_filename}
	 ${managFormDetail.member_position}
	  </c:if>
	  
	  <c:if test="${empty requestScope.managFormDetail}">
	  조회안됨.
	  </c:if>
</div>
<jsp:include page="../../footer/footer1.jsp" />  