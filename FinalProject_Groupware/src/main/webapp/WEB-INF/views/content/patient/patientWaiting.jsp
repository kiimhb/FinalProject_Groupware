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


<style type="text/css">

/* 페이지바 */
div#pageBar a {
   color: #509d9c;
   cursor: pointer;
}
#pageBar > ul > li {
   color: #006769;
   font-weight: bold;
   cursor: pointer;
}



/* 상단 타이틀 */
.header > div.title {
   border-left: 5px solid #006769;   
   padding-left: 1%;
   font-size: 20px;
   margin-bottom: 1%;
   color: #4c4d4f;
   font-weight: bold;
}

/* 페이지바 */
div#pageBar a {
   color: #509d9c;
   cursor: pointer;
}
#pageBar > ul > li {
   color: #006769;
   font-weight: bold;
   cursor: pointer;
}


#patientWaiting {
	box-shadow: 0 2px 5px rgba(0,0,0,.25); 
	border-radius: 5px;
}

</style>

<div id="sub_mycontent">
<div class="header"; style="font-size:15pt; margin: 1% 10%; "><div class="title">진료대기환자</div></div>
<div>${requestScope.firstPatient_no}</div>
<div style="border:solid 0px blue;">	
	<div style="border:solid 0px green; margin:0 10% 2% 10%;"class="">
		
		<table class="table table-hover text-center" id="patientWaiting">
			<thead class="bg-light">
				<tr>
					<th >순번</th>
					<th >이름</th>
					<th >성별</th>
					<th >나이</th>
					<th >진료구분</th>
					<th >증상</th>				
				</tr>
			</thead>
			<form name="patientGoToOrder">
				<c:if test="${not empty requestScope.patientList}">
				<c:forEach var="pvo" items="${requestScope.patientList}">
					<tr onclick="trclick(${pvo.patient_no})" style="border:solid 0px black;">
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
	    <div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
			
		
	</div>
</div>
</div>











<jsp:include page="../../footer/footer1.jsp" /> 