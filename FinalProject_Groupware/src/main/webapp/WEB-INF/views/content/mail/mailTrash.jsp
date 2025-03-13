<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>



<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">


document.addEventListener("DOMContentLoaded", function () {

    const headCheckbox = document.getElementById("headCheck");
    const bodyCheckboxes = document.querySelectorAll(".mailCheckbox");

    headCheckbox.addEventListener("change", function () {
        bodyCheckboxes.forEach(cb => cb.checked = this.checked);
    });

    bodyCheckboxes.forEach(cb => {
        cb.addEventListener("change", function () {
            const allChecked = Array.from(bodyCheckboxes).every(cb => cb.checked);
            headCheckbox.checked = allChecked;
        });
    });
});


document.addEventListener("DOMContentLoaded", function () {

    const headCheckbox = document.getElementById("headCheck1");
    const bodyCheckboxes = document.querySelectorAll(".mailCheckbox1");

    headCheckbox.addEventListener("change", function () {
        bodyCheckboxes.forEach(cb => cb.checked = this.checked);
    });

    bodyCheckboxes.forEach(cb => {
        cb.addEventListener("change", function () {
            const allChecked = Array.from(bodyCheckboxes).every(cb => cb.checked);
            headCheckbox.checked = allChecked;
        });
    });
});


$(document).ready(function(){  
	  


	
	  
});// end of $(document).ready(function(){})-----------


function sendMailDeleteAll (){
	alert("비우기 누름")
}





function sentMailRestore() {
	
    let checkedMails = []; // 선택된 메일 번호를 저장할 배열

    $(".mailCheckbox:checked").each(function () {
        let mailNo = $(this).attr("data-mail-no"); // 체크된 체크박스에서 mail_sent_no 가져오기
        checkedMails.push(mailNo);
    });

    if (checkedMails.length === 0) {
        alert("선택된 메일이 없습니다.");
        return;
    }
   	
    if(confirm("정말 복구하시겠습니까?")){
    	
    
    console.log("선택된 메일 번호:", checkedMails); // 디버깅용
	
    $.ajax({
        url: "<%= ctxPath%>/mail/sentMailRestore",
        type: "POST",
        contentType: "application/json", // JSON 형식으로 데이터 전송
        data: JSON.stringify(checkedMails),
        success: function (json) {
				
        		console.log(json);
                alert("선택한 메일이 복구 되었습니다.");
                location.reload(); // 페이지 새로고침
        },
        error: function () {
            console.error("요청 실패");
        }
    });
    }
    else{
    	return;
    }
}

function receivedMailRestore() {
	
    let checkedMails = []; // 선택된 메일 번호를 저장할 배열

    $(".mailCheckbox1:checked").each(function () {
        let mailNo = $(this).attr("data-mail-no"); // 체크된 체크박스에서 mail_sent_no 가져오기
        checkedMails.push(mailNo);
    });

    if (checkedMails.length === 0) {
        alert("선택된 메일이 없습니다.");
        return;
    }
   	
    if(confirm("정말 복구하시겠습니까?")){
    	
    
    console.log("선택된 메일 번호:", checkedMails); // 디버깅용
	
    $.ajax({
        url: "<%= ctxPath%>/mail/receivedMailRestore",
        type: "POST",
        contentType: "application/json", // JSON 형식으로 데이터 전송
        data: JSON.stringify(checkedMails),
        success: function (json) {
				
        		console.log(json);
                alert("선택한 메일이 복구 되었습니다.");
                location.reload(); // 페이지 새로고침
        },
        error: function () {
            console.error("요청 실패");
        }
    });
    }
    else{
    	
    	return;
    }
}


function sentMailDelete() {
	
    let checkedMails = []; // 선택된 메일 번호를 저장할 배열

    $(".mailCheckbox:checked").each(function () {
        let mailNo = $(this).attr("data-mail-no"); // 체크된 체크박스에서 mail_sent_no 가져오기
        checkedMails.push(mailNo);
    });

    if (checkedMails.length === 0) {
        alert("선택된 메일이 없습니다.");
        return;
    }
   	
    if(confirm("정말 삭제 하시겠습니까? 휴지통에서 삭제된 메일은 복구할수 없습니다.")){
    	
    
    console.log("선택된 메일 번호:", checkedMails); // 디버깅용
	
    $.ajax({
        url: "<%= ctxPath%>/mail/sentMailDelete",
        type: "POST",
        contentType: "application/json", // JSON 형식으로 데이터 전송
        data: JSON.stringify(checkedMails),
        success: function (json) {
				
        		console.log(json);
                alert("선택한 메일이 영구삭제 되었습니다.");
                location.reload(); // 페이지 새로고침
        },
        error: function () {
            console.error("요청 실패");
        }
    });
    }
    else{
    	
    	return;
    }
}


function receivedMailDelete() {
	
    let checkedMails = []; // 선택된 메일 번호를 저장할 배열

    $(".mailCheckbox1:checked").each(function () {
        let mailNo = $(this).attr("data-mail-no"); // 체크된 체크박스에서 mail_sent_no 가져오기
        checkedMails.push(mailNo);
    });

    if (checkedMails.length === 0) {
        alert("선택된 메일이 없습니다.");
        return;
    }
   	
    if(confirm("정말 삭제 하시겠습니까? 휴지통에서 삭제된 메일은 복구할수 없습니다.")){
    	
    
    console.log("선택된 메일 번호:", checkedMails); // 디버깅용
	
    $.ajax({
        url: "<%= ctxPath%>/mail/receivedMailDelete",
        type: "POST",
        contentType: "application/json", // JSON 형식으로 데이터 전송
        data: JSON.stringify(checkedMails),
        success: function (json) {
				
        		console.log(json);
                alert("선택한 메일이 영구삭제 되었습니다.");
                location.reload(); // 페이지 새로고침
        },
        error: function () {
            console.error("요청 실패");
        }
    });
    }
    else{
    	
    	return;
    }
}



</script>

<style type="text/css">

.tab-content {
    padding: 0 !important;
}

.tab-pane {
    padding: 0 !important;
}
</style>



<jsp:include page="../../header/header1.jsp" /> 

<div style=" border-radius:10px; font-size:15pt; text-align:center; margin: 1% 10%; background-color:#b3d6d2;">

	<span>휴지통</span>
	<span>${sessionScope.loginuser.member_userid}</span>
</div>



<div id=Container;>


	<ul class="nav nav-tabs" style="margin:0.1% 10%;">
			  <li class="nav-item">
			    <a class="nav-link active" data-toggle="tab" href="#sent">보낸메일함</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#received">받은메일함</a>
			  </li>
	</ul>

<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@보낸메일함@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -->
<div class="tab-content" style="margin:0% 10%; border:solid 1px blue;">

<div class="tab-pane container active" style="border:solid 1px red;" id="sent">
	<div style="">
		<div style="float:right;"><button onclick="sentMailRestore()">복구</button></div>
		<div style="float:right; margin-right:0.5%;"><button onclick="sentMailDelete()">삭제</button></div>	
	</div>
	<table style="width:100%; text-align:center;">
		<thead style="border: solid 1px black; height:50px;">
			<tr>					
				<th style="width:50%">제목</th>
				<th style="width:25%">수신자</th>
				<th style="width:20%">발신일시</th>
				<th style="width:5%"><input type="checkbox" class="mailCheckbox" id="headCheck"/></th>			
			</tr>	
		</thead>
		
		<tbody>
			<c:if test="${not empty requestScope.mailSentTrashList}">
				<c:forEach items="${requestScope.mailSentTrashList}" var="mtl" varStatus="status">
					<tr onclick="">							
						<td style="border-bottom:solid 1px black">${mtl.mail_title}</td>
						<td style="border-bottom:solid 1px black">${mtl.member_name}</td>
						<td style="border-bottom:solid 1px black">${mtl.mail_sent_senddate}</td>
						<td style="border-bottom:solid 1px black; height:50px;"><input style="width:100px;"type="checkbox" class="mailCheckbox" data-mail-no="${mtl.mail_sent_no}"/></td>							
					</tr>						
				</c:forEach>
			</c:if>
			<c:if test="${empty requestScope.mailSentTrashList}">
					<tr style="text-align:center; height:550px;" >
						<td colspan='4' style="border-bottom:solid 1px black; height:50px;">아직 휴지통에 메일이 없습니다.</td>
					</tr>
					
			</c:if>
		</tbody>
	</table>
			<div style=""><span>휴지통에 있는 메일은 일주일 뒤에 삭제됩니다.</span></div>		
		<div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
	</div>


<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@받은메일함@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -->
<div class="tab-pane container" style="border:solid 1px red; margin: 1% 10%; width:80%;" id="received">
	<div style="margin:0.05% 0">
		<div style="float:right;"><button onclick="receivedMailRestore()">복구</button></div>
		<div style="float:right; margin-right:0.5%;"><button onclick="receivedMailDelete()">삭제</button></div>	
	</div>
		<table style="width: 100%; text-align:center;">
			<thead style="border: solid 1px black; height:50px;">
				<tr>					
					<th style="width:50%">제목</th>
					<th style="width:25%">발신자</th>
					<th style="width:20%">발신일시</th>
					<th style="width:5%"><input type="checkbox" id="headCheck1"/></th>			
				</tr>	
			</thead>
			
			<tbody>
				<c:if test="${not empty requestScope.mailReceivedTrashList}">
					<c:forEach items="${requestScope.mailReceivedTrashList}" var="mrtl" varStatus="status">
						<tr onclick="">							
							<td style="border-bottom:solid 1px black">${mrtl.mail_title}</td>
							<td style="border-bottom:solid 1px black">${mrtl.member_name}</td>
							<td style="border-bottom:solid 1px black">${mrtl.mail_sent_senddate}</td>
							<td style="border-bottom:solid 1px black; height:50px;"><input style="width:100px;"type="checkbox" class="mailCheckbox1" data-mail-no="${mrtl.mail_sent_no}"/></td>							
						</tr>						
					</c:forEach>
				</c:if>
				<c:if test="${empty requestScope.mailReceivedTrashList}">
						<tr style="text-align:center; height:550px;" >
							<td colspan='4' style="border-bottom:solid 1px black; height:50px;">아직 휴지통에 메일이 없습니다.</td>
						</tr>
						
				</c:if>
			</tbody>
		</table>
			<div style=""><span>휴지통에 있는 메일은 일주일 뒤에 삭제됩니다.</span></div>		
		<div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar1}
	    </div>
	</div>

</div>


</div>







<jsp:include page="../../footer/footer1.jsp" />