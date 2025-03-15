<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />

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


li.nav{

color:black;

}

a.nav-link{

color:black;

}

#sent {
    padding-left: 0 !important;
    padding-right: 0 !important;
}

#received {
    padding-left: 0 !important;
    padding-right: 0 !important;
}

.btnRes{

background-color:#006769;
border-radius: 10px;
border: none;
width: 70px;
height:35px;
color:white;
}

.btnDel{

background-color:#f68b1f;
border-radius: 10px;
border: none;
width: 70px;
height:35px;
color:white;

}


</style>



<jsp:include page="../../header/header1.jsp" /> 


<div id="sub_mycontent">
<div class="header" style="font-size:15pt; margin: 1% 5%; ">

	<div class="title">휴지통</div>
	
</div>






	<ul class="nav nav-tabs" style="margin:0.1% 5%;">
			  <li class="nav-item">
			    <a class="nav-link active" data-toggle="tab" href="#sent">보낸메일함</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link" data-toggle="tab" href="#received">받은메일함</a>
			  </li>
	</ul>

<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@보낸메일함@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -->
<div class="tab-content" style="margin:0% 5%; border:solid 0px blue;">

<div class="tab-pane container-fluid active" style="border:solid 0px red;" id="sent">

		<div style="float:right;"><button class="btnRes"onclick="sentMailRestore()">복구</button></div>
		<div style="float:right; margin-right:0.5%;"><button class="btnDel" onclick="sentMailDelete()">삭제</button></div>	

	<table class="table table-hover" style="width:100%; text-align:center;">
		<thead class="bg-light" style="border: solid 0px black; height:50px;">
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
						<td style="">${mtl.mail_title}</td>
						<td style="">${mtl.member_name}</td>
						<td style="">${mtl.mail_sent_senddate}</td>
						<td style="height:50px;"><input style="width:100px;"type="checkbox" class="mailCheckbox" data-mail-no="${mtl.mail_sent_no}"/></td>							
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
				
		<div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
	</div>


<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@받은메일함@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -->
<div class="tab-pane container-fluid" style="border:solid 0px red;" id="received">

		<div style="float:right;"><button class="btnRes" onclick="receivedMailRestore()">복구</button></div>
		<div style="float:right; margin-right:0.5%;"><button class="btnDel" onclick="receivedMailDelete()">삭제</button></div>	

		<table class="table table-hover" style="width: 100%; text-align:center;">
			<thead class="bg-light" style="border: solid 0px black; height:50px;">
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
							<td style="">${mrtl.mail_title}</td>
							<td style="">${mrtl.member_name}</td>
							<td style="">${mrtl.mail_sent_senddate}</td>
							<td style="height:50px;"><input style="width:100px;"type="checkbox" class="mailCheckbox1" data-mail-no="${mrtl.mail_sent_no}"/></td>							
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
		<div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar1}
	    </div>
	</div>

</div>


</div>







<jsp:include page="../../footer/footer1.jsp" />