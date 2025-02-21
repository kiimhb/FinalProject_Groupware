<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/patient.css" />

<jsp:include page="../../header/header1.jsp" /> 

<script type="text/javascript">
$(document).ready(function(){  
	

});

function nameSearch() {
   const frm = document.searchFrm;
	     frm.submit();
}

</script>
	
      <div class="header">
		
	  		<div class="title">
	  			진료기록조회
	  		</div>
	  		
			<form name="searchFrm">
				<div class="search">
					<input type="text" name="patientname" placeholder="환자명을 입력하세요" />
					<button type="button" class="btn ml-2" onclick="nameSearch()">검색</button>
				</div>
			</form>
			
		
      </div>
  
	  <div class="patientList mt-3">
		
		<table class="table table-hover">
			<thead>
				<tr>
					<th>진료번호</th>
					<th>진료일자</th>
					<th>진료과</th>
					<th>환자명</th>
					<th>성별</th>
					<th>주민등록번호</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="pvo" items="${requestScope.patientList}">
				<tr class="patientList" onclick="javascript:location.href='<%= ctxPath%>/patient/detail/${pvo.patient_no}'" >
					<td>${pvo.patient_no}</td>
					<td>${pvo.patient_visitdate}</td>
					<td>${pvo.child_dept_name}</td>
					<td>${pvo.patient_name}</td>
					<td>${pvo.patient_gender}</td>
					<td>${pvo.patient_jubun}</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		
		<%-- 페이지바 === --%>
	    <div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
	    
	  </div>


<jsp:include page="../../footer/footer1.jsp" />   