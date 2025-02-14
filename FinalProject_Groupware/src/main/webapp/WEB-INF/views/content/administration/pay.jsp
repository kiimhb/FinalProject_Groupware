<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/pay.css" />

<jsp:include page="../../header/header1.jsp" /> 

<script type="text/javascript">
$(document).ready(function(){  
	

});

// 전체선택하기 / 전체해제하기
function onecheck() { // this.checked 는 해당요소가 체크 되었는지를 의미 (boolean 타입)
					  // true 면 check 상태, false 면 해제된 상태
	const boxlist = document.querySelectorAll("input[name='finishCheck']"); // 전체 체크박스 
	const checkedboxlist = document.querySelectorAll("input[name='finishCheck']:checked"); // 선택 체크박스 
	const selectAll = document.querySelector("input[name='allcheckbox']"); // 전체체크박스

	if(boxlist.length === checkedboxlist.length) {
		selectAll.checked = true;
	}
	else {
		selectAll.checked = false;
	}
}

function allCheck(selectAll) {

	const checkboxes = document.getElementsByName('finishCheck');

	checkboxes.forEach((checkbox) => {
		checkbox.checked = selectAll.checked
	});
}

</script>
	
      <div class="header">
		
	  		<div class="title">
	  			수납
	  		</div>
		
			<div class="menu">
				<div class="menulist">
					<div><a href="<%= ctxPath%>/pay/wait" >수납대기</a>&nbsp;&nbsp;&nbsp;&nbsp;|</div>
					<div><a href="<%= ctxPath%>/pay/finish">&nbsp;&nbsp;&nbsp;&nbsp;수납완료</a></div>
				</div>
				<div class="paybtn">
					<button type="button" class="btn">수납처리</button>	
				</div>
			</div>
			
			
      </div>
  
	  <div class="patientList mt-3">
		
		<table class="table table-hover">
			<thead>
				<tr>
					<th><input type="checkbox" name="allcheckbox" onclick="allCheck(this)" /></th>
					<th>차트번호</th>
					<th>진료일자</th>
					<th>진료과</th>
					<th>환자명</th>
					<th>성별</th>
					<th>주민등록번호</th>
					<th>처방전</th>
					<th>수납</th>
				</tr>
			</thead>
			<tbody>
				<tr class="patientList">
					<td><input type="checkbox" name="finishCheck" onclick="onecheck()" /></td>
					<td>10001</td>
					<td>2025-12-12</td>
					<td>호흡기내과</td>
					<td>이혜연</td>
					<td>여</td>
					<td>020106-*******</td>
					<td><input type="button" value="출력" id="print" class="btn print" onclick="window.print()"></td>
					<td><input type="button" value="출력" id="print" class="btn print" onclick="window.print()"></td>
				</tr>
			</tbody>
		</table>
	  </div>


<jsp:include page="../../footer/footer1.jsp" />   