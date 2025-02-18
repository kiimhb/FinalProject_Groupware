<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

 <%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/register.css" />

<jsp:include page="../../header/header1.jsp" /> 



<script type="text/javascript">
$(document).ready(function(){  
	
	
});


</script>
	
	<div class="content">
	
		<div class="surgery">
			
	  		<div class="title">
	  			수술대기
	  		</div>
	  		<div class="list">
	  			<table class="table">
	  				<thead class="bg-light">
	  					<tr>
	  						<th>차트번호</th>
	  						<th>진료일자</th>
	  						<th>진료과</th>
	  						<th>이름</th>
	  						<th>성별</th>
	  						<th>주민번호</th>
	  						<th>예약</th>
	  					</tr>
	  				</thead>
	  				<tbody>
	  				<c:forEach var="rvo" items="${requestScope.register_list}">
	  					<tr class="clicktr">
		  					<td>${rvo.fk_order_no}</td>
		  					<td>${rvo.patient_visitdate}</td>
		  					<td>${rvo.child_dept_name}</td>
		  					<td>${rvo.patient_name}</td>
		  					<td>${rvo.patient_gender}</td>
		  					<td>${rvo.patient_jubun}</td>
		  					<td><button type="button" class="btn" onclick="location.href='<%= ctxPath%>/register/surgery/${rvo.fk_order_no}'"><span>예약</span></button></td>
	  					</tr>
	  				</c:forEach>
	  					
	  				</tbody>
	  			</table>
	  		</div>
	  		
			<%-- 페이지바 === --%>
		    <div id="pageBar" align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
		    	${requestScope.pageBar}
		    </div>
		    
	    </div>
	    
	    <div class="hospitalized">
			
	  		<div class="title">
	  			입원대기
	  		</div>
			<div class="list">
	  			<table class="table">
	  				<thead class="bg-light">
	  					<tr>
	  						<th>차트번호</th>
	  						<th>진료일자</th>
	  						<th>진료과</th>
	  						<th>이름</th>
	  						<th>성별</th>
	  						<th>주민번호</th>
	  						<th>예약</th>
	  					</tr>
	  				</thead>
	  				<tbody>
	  					<tr>
		  					<td>1010</td>
		  					<td>2025-01-01</td>
		  					<td>호흡기내과</td>
		  					<td>이혜연</td>
		  					<td>여</td>
		  					<td>020106-*******</td>
		  					<td><button type="button" class="btn" onclick="location.href='<%= ctxPath%>/register/hospitalization'"><span>예약</span></button></td>
	  					</tr>
	  				</tbody>
	  			</table>
	  		</div>
			<div class="pageBar">
	  			페이지바
	  		</div>
	    </div>
	</div>



<jsp:include page="../../footer/footer1.jsp" />   