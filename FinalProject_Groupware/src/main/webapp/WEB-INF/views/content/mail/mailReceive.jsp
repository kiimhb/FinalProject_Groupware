<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>




<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">


$(document).ready(function(){  
	
	// 중요메일 체크
	$.ajax({
	    url: "<%= ctxPath%>/mail/isImportantMail",
	    type: "GET",
	    success: function (response) {
	        //console.log("AJAX 응답 데이터:", response); // 응답 데이터 확인

	        $("button.btnstar").each(function() {
	            var btnstar = $(this);
	            
	            //console.log(btnstar);
	            var mailNo = btnstar.attr("data-important"); // 버튼의 data-important 값

	            console.log("버튼의 data-important 값:", mailNo); // 버튼의 값 확인

	            var isImportant = false;
	            
	            $.each(response, function(index, mailNoList) {
	                if (mailNoList.fk_mail_sent_no == mailNo) {
	                    isImportant = (mailNoList.mail_received_important == 1);
	                    return false; // 찾았으면 반복 중지
	                }
	            });

	            var icon = btnstar.find("i");
	            //console.log("아이콘 선택 확인:", icon); // 아이콘이 선택되는지 확인

	            if (isImportant) {
	                icon.removeClass("fa-star-o").addClass("fa-star").css("color", "black");
	                //console.log("⭐ 중요 메일로 변경됨!");
	            } else {
	                icon.removeClass("fa-star").addClass("fa-star-o").css("color", "gray");
	               // console.log("☆ 중요하지 않은 메일로 변경됨.");
	            }
	        });
	    },
	    error: function () {
	        console.error("즐겨찾기 상태 업데이트 실패");
	    }
	});
	

	
	
	
	  
});// end of $(document).ready(function(){})-----------




// 받은 메일함 중요 클릭
function importantMail(fk_mail_sent_no, button) {
    let icon = $(button).find("i"); // 클릭한 버튼 내 아이콘 요소 찾기
    //let isImportant = icon.hasClass("fa-star"); // 현재 즐겨찾기 여부 확인
    let currentStatus = $(button).attr("data-important-status");  // 현재 중요 여부

    
    console.log("번호",fk_mail_sent_no)
    console.log("중요여부(클릭시) : ",currentStatus)
      

    $.ajax({
        url: "<%= ctxPath%>/mail/IDImportant",
        type: "POST",
        data: { "fk_mail_sent_no": fk_mail_sent_no 
        	  , "mail_received_important":currentStatus},
        success: function (response) {
            if (response.success) { // 0->1 그러므로 currentStatus 는 0
				      			            	
            	if (currentStatus === "0") {
            		
            		// 일반메일 => 중요메일로 변경 (색상 회색 -> 검정)
                    icon.removeClass("fa-star-o").addClass("fa-star").css("color", "black");

                } else {
                    // 중요메일 => 일반메일로 변경 (색상 검정 -> 회색)                    
                    icon.removeClass("fa-star").addClass("fa-star-o").css("color", "gray");
                }
				
            	currentStatus = (currentStatus === "1") ? "0" : "1"; 
            	
            	console.log("중요여부(클릭후) : ",currentStatus);
            	
                $(button).attr("data-important-status", currentStatus);

                
            }
            else{ // 1->0 그러므로 currentStatus = 1
            	
            	console.log(currentStatus);
            	
            	if (currentStatus === "1") {
                    // 중요메일 => 일반메일로 변경 (색상 검정 -> 회색)
                    icon.removeClass("fa-star").addClass("fa-star-o").css("color", "gray");
                } else {
                    // 일반메일 => 중요메일로 변경 (색상 회색 -> 검정)
                    icon.removeClass("fa-star-o").addClass("fa-star").css("color", "black");
                }
            		
            		currentStatus = (currentStatus === "1") ? "0" : "1"; 
                	
                	console.log("중요여부(클릭후) : ",currentStatus);
                	
                    $(button).attr("data-important-status", currentStatus);

            }
        },
        error: function () {
            console.error("즐겨찾기 상태 업데이트 실패");
        }
    });
}


function sendMailStorage() {
    let checkedMails = []; // 선택된 메일 번호를 저장할 배열

    $(".mailCheckbox:checked").each(function () {
        let mailNo = $(this).attr("data-mail-no"); // 체크된 체크박스에서 mail_sent_no 가져오기
        checkedMails.push(mailNo);
    });

    if (checkedMails.length === 0) {
        alert("선택된 메일이 없습니다.");
        return;
    }

    console.log("선택된 메일 번호:", checkedMails); // 디버깅용
	
    $.ajax({
        url: "<%= ctxPath%>/mail/sendMailStorage",
        type: "POST",
        contentType: "application/json", // JSON 형식으로 데이터 전송
        data: JSON.stringify(checkedMails),
        success: function (json) {
				
        		console.log(json);
                alert("선택한 메일이 보관함으로 이동 되었습니다.");
                location.reload(); // 페이지 새로고침
        },
        error: function () {
            console.error("요청 실패");
        }
    });

}

function sendMailTrash() {
    let checkedMails = []; // 선택된 메일 번호를 저장할 배열

    $(".mailCheckbox:checked").each(function () {
        let mailNo = $(this).attr("data-mail-no"); // 체크된 체크박스에서 mail_sent_no 가져오기
        checkedMails.push(mailNo);
    });

    if (checkedMails.length === 0) {
        alert("선택된 메일이 없습니다.");
        return;
    }

    console.log("선택된 메일 번호:", checkedMails); // 디버깅용
	
    $.ajax({
        url: "<%= ctxPath%>/mail/sendMailTrash",
        type: "POST",
        contentType: "application/json", // JSON 형식으로 데이터 전송
        data: JSON.stringify(checkedMails),
        success: function (json) {
				
        		console.log(json);
                alert("선택한 메일이 휴지통으로 이동 되었습니다.");
                location.reload(); // 페이지 새로고침
        },
        error: function () {
            console.error("요청 실패");
        }
    });

}

	

function trclick(fk_mail_sent_no){
	
	const frm = document.goReceivedMailView;
	
	frm.fk_mail_sent_no.value = fk_mail_sent_no;
	
	console.log(fk_mail_sent_no);
	
	frm.action = "<%= ctxPath%>/mail/receivedMailView";
	frm.method = "get";
	frm.submit();
		
		
}




</script>

<jsp:include page="../../header/header1.jsp" /> 

<div id="sub_mycontent">
<div style=" border-radius:10px; font-size:15pt; text-align:center; margin: 1% 10%; background-color:#b3d6d2;">

	<span>받은 메일함</span>
	<span>${sessionScope.loginuser.member_userid}</span>
</div>

<div style="margin:0.1% 10%">
	
	<div style="float:left;"><button onclick="location.href='<%= ctxPath%>/mail/mailWrite'">메일쓰기</button></div>
	<div style="float:right; margin-left:0.5%;"><button onclick="sendMailTrash()">삭제</button></div>
	<div style="float:right;"><button onclick="sendMailStorage()">보관</button></div>
</div>


<div id=Container;>
	<div id="tableContainer" style="border:solid 1px red; margin: 1% 10%; width:80%;">

		<table style="width: 100%; text-align:center;">
			<thead style="border: solid 1px black; height:50px;">
				<tr>
					<th style="width:10%">중요</th>
					<th style="width:40%">제목</th>
					<th style="width:20%">보낸사람</th>
					<th style="width:30%">발신일시</th>			
				</tr>	
			</thead>
			
			<tbody>
				<c:if test="${not empty requestScope.mailReceiveList}">
					<c:forEach items="${requestScope.mailReceiveList}" var="mrl" varStatus="status">
						<tr onclick="">
							<td style="border-bottom:solid 1px black; height:50px;"> <!-- <div id="starToggle"></div> -->
								<button type="button" class="btnstar btn-link p-0 no-outline" data-important="${mrl.mail_sent_no}" data-important-status ="${mrl.mail_received_important}"							        
							        style="font-size: 1rem; color: black; background-color: transparent; border: none; outline: none;"
							        onclick="importantMail('${mrl.fk_mail_sent_no}', this)">
							        <i class="fa fa-star-o" aria-hidden="true"></i>
							    </button>			
							</td>
							<td onclick="trclick(${mrl.mail_sent_no})" style="border-bottom:solid 1px black">${mrl.mail_title}
							<c:if test="${not empty mrl.MAIL_SENT_FILE }">
								<i class="fa-solid fa-file"></i>
							</c:if>
							</td>
							<td style="border-bottom:solid 1px black">${mrl.member_name}</td>
							<td style="border-bottom:solid 1px black">${mrl.mail_sent_senddate}&nbsp;&nbsp;${mrl.timediff }</td>
							<td style="border-bottom:solid 1px black"><input style="width:100px;"type="checkbox" class="mailCheckbox" data-mail-no="${mrl.mail_sent_no}"/></td>							
						</tr>
						<input type="hidden" value="${mrl.mail_received_important}" />						
					</c:forEach>
					<form name="goReceivedMailView">
						<input type="hidden" name="fk_mail_sent_no"/>
					</form>
				</c:if>
				<c:if test="${empty requestScope.mailReceiveList}">
						<tr style="text-align:center; height:550px;" >
							<td colspan='4' style="border-bottom:solid 1px black; height:50px;">아직 받은 메일이 없습니다.</td>
						</tr>
						
				</c:if>
			</tbody>
		</table>

		
		<div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
	</div>
</div>
</div>




<jsp:include page="../../footer/footer1.jsp" />