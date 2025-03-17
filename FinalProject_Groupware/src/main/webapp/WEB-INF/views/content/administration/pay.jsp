<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../header/header1.jsp" /> 

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/administration/pay.css" />

<script type="text/javascript">
$(document).ready(function(){  
	
	$("input:text[name='patientname']").bind("keydown", function(e){		
		if(e.keyCode == 13) {
			paySearch();
		}
	});

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

function nameSearch() {
	const frm = document.searchFrm;
			    frm.submit();
}

// 수납처리 버튼 클릭할 경우
function pay_success() {
	
	// 체크박스를 선택하지 않고 수납처리 버튼을 클릭한 경우 
	if($("input:checkbox[name='finishCheck']:checked").length == 0) {
		alert("수납처리할 환자를 선택하세요");
		return;
	}
	
	// 수납 상태를 0 에서 1로 변경한다. (여러명일 경우를 위해 반복문 사용)
	$("input:checkbox[name='finishCheck']:checked").each((index, elmt) => {
		$(document.paySuccessFrm).append("<input type='hidden' name='order_no' value='"+ $(elmt).val() +"'/>")
	});
	
	if(confirm("수납처리를 하시겠습니까?")) {
		const frm = document.paySuccessFrm;
	    frm.action = "success";
	    frm.method = "post";
	    frm.submit();
	} else {
		alert("수납처리가 취소되었습니다.");
	}
	
}

// 출력화면 띄우기
function openAndPrint(url) {
	// `payPrint.jsp`를 새 창으로 열고 인쇄 대화상자를 띄운다
   
	var newWindow = window.open(url, '_blank', 'width=800,height=600'); // 새 팝업 창 크기 설정
	   newWindow.onload = function() {
	       newWindow.print(); // 팝업 창에서 자동으로 인쇄 대화상자 실행
	   };
}

</script>
<div id="sub_mycontent">	
      <div class="header">
		
	  		<div class="title">
	  			수납
	  		</div>
	  		
	  		<form name="searchFrm">
		  		<div class="menu ml-1">
					<div class="menulist">
						<div><a href="<%= ctxPath%>/pay/wait?order_status=0" style="${requestScope.order_status eq '0' ? 'color:black;' : ''}">수납대기</a>&nbsp;&nbsp;&nbsp;&nbsp;|</div>
						<div><a href="<%= ctxPath%>/pay/wait?order_status=1" style="${requestScope.order_status eq '1' ? 'color:black;' : ''}">&nbsp;&nbsp;&nbsp;&nbsp;수납완료</a></div>
					</div>
				</div>
			
			
				<div class="search_and_pay">
					<div class="search">
						<input type="text" name="patientname" class="patientname" placeholder="환자명을 입력하세요" >
						<i class="fa-solid fa-magnifying-glass" id="icon" onclick="nameSearch()"></i></input>	
					</div>
					<c:if test="${requestScope.order_status eq '0'}">
						<div class="paybtn">
							<button type="button" class="btn" onclick="pay_success()">수납처리</button>	
						</div>
					</c:if>
				</div>	
			</form>
		
      </div>
  
	  <div class="patientList mt-1">
		
		<table class="table table-hover">
			<thead>
			<c:if test="${not empty requestScope.pay_list}">
				<tr>
					<th><input type="checkbox" name="allcheckbox" onclick="allCheck(this)" /></th>
					<th>차트번호</th>
					<th>진료일자</th>
					<th>환자명</th>
					<th>성별</th>
					<th>주민등록번호</th>
					<th>수납비용</th>
					<th>처방전</th>
				</tr>
			</c:if>
			<c:if test="${empty requestScope.pay_list}">
				<tr>
					<th>차트번호</th>
					<th>진료일자</th>
					<th>환자명</th>
					<th>성별</th>
					<th>주민등록번호</th>
					<th>수납비용</th>
					<th>처방전</th>
				</tr>
			</c:if>
			</thead>
			<tbody>
			<c:if test="${not empty requestScope.pay_list}">
				<c:forEach var="pvo" items="${requestScope.pay_list}">
					<tr class="patientList">
						<td><input type="checkbox" name="finishCheck" onclick="onecheck()" value="${pvo.order_no}"/></td>
						<td>${pvo.order_no}</td>
						<td>${pvo.order_createTime}</td>
						<td>${pvo.patient_name}</td>
						<td>${pvo.patient_gender}</td>
						<td>${fn:substring(pvo.patient_jubun, 0, 8)}******</td>
						<td><fmt:formatNumber value="${pvo.cost}" pattern="#,###"/>원</td>
						<td><input type="button" value="출력" id="print" class="btn print" onclick="openAndPrint('<%= ctxPath%>/pay/print/${pvo.order_no}')"></td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty requestScope.pay_list}">
				<tr><td>수납 목록이 없습니다...</td></tr>
			</c:if>
				
			</tbody>
		</table>
	  </div>
	  
	  <c:if test="${not empty requestScope.pay_list}">
		  <%-- 페이지바 === --%>
	      <div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    		${requestScope.pageBar}
	   	  </div>
   	  </c:if>

	 <form name="paySuccessFrm">
		
	 </form>
</div>

<jsp:include page="../../footer/footer1.jsp" />   