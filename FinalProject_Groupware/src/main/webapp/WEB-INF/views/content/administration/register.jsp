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
	  			수술대기 ( ${requestScope.totalCount} )
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
					<c:if test="${not empty requestScope.register_list}">
		  				<c:forEach var="rvo" items="${requestScope.register_list}">
		  					<tr class="clicktr">
			  					<td>${rvo.order_no}</td>
			  					<td>${rvo.patient_visitdate}</td>
			  					<td>${rvo.child_dept_name}</td>
			  					<td>${rvo.patient_name}</td>
			  					<td>${rvo.patient_gender}</td>
			  					<td>${rvo.patient_jubun}</td>
			  					<td><button type="button" class="btn" onclick="location.href='<%= ctxPath%>/register/surgery/${rvo.order_no}'"><span>예약</span></button></td>
		  					</tr>
		  				</c:forEach>
					</c:if>
					
					<c:if test="${empty requestScope.register_list}">
						<tr><td>수술 대기 환자가 없습니다.</td></tr>
					</c:if>	
					
	  				</tbody>
	  			</table>
	  		</div>
	  		
			<%-- 페이지바 === --%>
			<c:if test="${not empty requestScope.hospitalize_list}">
			    <div id="pageBar" align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
			    	${requestScope.pageBar}
			    </div>
		    </c:if>
		    
	    </div>
	    
	    <div class="hospitalized">
			
	  		<div class="title">
	  			입원대기 ( ${requestScope.totalCount2} )
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
	  					<c:if test="${not empty requestScope.hospitalize_list}">
		  				<c:forEach var="hvo" items="${requestScope.hospitalize_list}">
		  					<tr class="clicktr">
			  					<td>${hvo.order_no}</td>
			  					<td>${hvo.patient_visitdate}</td>
			  					<td>${hvo.child_dept_name}</td>
			  					<td>${hvo.patient_name}</td>
			  					<td>${hvo.patient_gender}</td>
			  					<td>${hvo.patient_jubun}</td>
								<td><button type="button" class="btn" onclick="location.href='<%= ctxPath%>/register/hospitalization/${hvo.order_no}'"><span>예약</span></button></td>		  					</tr>
		  				</c:forEach>
					</c:if>
					
					<c:if test="${empty requestScope.register_list}">
						<tr><td>입원 대기 환자가 없습니다.</td></tr>
					</c:if>	
	  				</tbody>
	  			</table>
	  		</div>
	  		<c:if test="${not empty requestScope.hospitalize_list}">
				<div id="pageBar2" align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
			    	${requestScope.pageBar2}
			    </div>
		    </c:if>
		    
	    </div>
	</div>



<jsp:include page="../../footer/footer1.jsp" />   