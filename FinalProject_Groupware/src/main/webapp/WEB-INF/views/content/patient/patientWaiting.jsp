<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>



<jsp:include page="../../header/header1.jsp" />

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>


<script type="text/javascript">

$(document).ready(function(){
	
	
	<%-- 
	$("a#firstPatient").click(function(){

		const patient_no = $("input#idfirstPatient_no").val()
		
		
		const frm = document.firstPatientFrm;
		
		frm.nameFirstPatient_no.value = $("input#idFirstPatient_no").val();
		console.log("왜안나오냐고시벌"+frm.nameFirstPatient_no.value);
		
		frm.action = "<%= ctxPath%>/order/orderEnter";
		frm.method = "get";
	  	frm.submit();
		
	});
	--%>
	

	
	
	
	

});


function trclick(patient_no){
	
	const Cfrm = document.patientGoToOrder;
	
	Cfrm.nameClickPatient_no.value = patient_no;
	
	console.log(patient_no);
	
	Cfrm.action = "<%= ctxPath%>/order/orderEnter";
	Cfrm.method = "get";
	Cfrm.submit();
	
}



	function noClick(patient_no){
	
	const Nfrm = document.firstPatientFrm;
	
	Nfrm.nameFirstPatient_no.value = patient_no;
	
	console.log(patient_no);
	
	Nfrm.action = "<%= ctxPath%>/order/orderEnter";
	Nfrm.method = "get";
	Nfrm.submit();
	
	} 

</script>


<div style="border-radius:10px; font-size:15pt; text-align:center; margin: 1% 10%; background-color:#b3d6d2;"><span>진료대기환자</span></div>
<div>${requestScope.firstPatient_no}</div>
<div style="border:solid 0px blue;">	
	<div style="border:solid 1px green; margin:0 10% 2% 10%;"class="">
		
		<table class="table text-center" id="patientWaiting">
				<tr>
					<th style="border:solid 1px black">순번</th>
					<th style="border:solid 1px black">이름</th>
					<th style="border:solid 1px black">성별</th>
					<th style="border:solid 1px black">나이</th>
					<th style="border:solid 1px black">진료구분</th>
					<th style="border:solid 1px black">증상</th>				
				</tr>
			<form name="patientGoToOrder">
				<c:if test="${not empty requestScope.patientList}">
				<c:forEach var="pvo" items="${requestScope.patientList}">
					<tr onclick="trclick(${pvo.patient_no})">
						<td>${pvo.rno}</td>
						<td>${pvo.patient_name}</td>
						<td>${pvo.patient_gender}</td>
						<td>${pvo.age}</td>
						<td>${pvo.child_dept_name}</td>
						<td>${pvo.patient_symptom}</td>				
					</tr>					
				</c:forEach>
				</c:if>
				<c:if test="${empty requestScope.patientList}">
					<tr style="">
						<td style="border:solid 1px black;"colspan="6">해당된 환자가 없습니다.</td>
					</tr>
				</c:if>
				<input type="hidden" name="nameClickPatient_no" id="idClickPatient_no"/>				
			</form>				
		</table>
	
		<%-- 페이지바 === --%>
	    <div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
			
		
	</div>
</div>












<jsp:include page="../../footer/footer1.jsp" /> 