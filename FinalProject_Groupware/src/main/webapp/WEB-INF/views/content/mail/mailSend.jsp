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


$(document).ready(function(){  
	

	// 중요메일 체크
	$.ajax({
	    url: "<%= ctxPath%>/mail/isImportantMailSent",
	    type: "GET",
	    success: function (response) {
	        console.log("AJAX 응답 데이터:", response); // 응답 데이터 확인

	        $("button.btnstar").each(function() {
	            var btnstar = $(this);
	            
	            //console.log(btnstar);
	            var mailNo = btnstar.attr("data-important"); // 버튼의 data-important 값

	            console.log("버튼의 data-important 값:", mailNo); // 버튼의 값 확인

	            var isImportant = false;
	            
	            $.each(response, function(index, mailNoList) {
	                if (mailNoList.mail_sent_no == mailNo) {
	                    isImportant = (mailNoList.mail_sent_important == 1);
	                    return false; // 찾았으면 반복 중지
	                }
	            });

	            var icon = btnstar.find("i");
	            //console.log("아이콘 선택 확인:", icon); // 아이콘이 선택되는지 확인

	            if (isImportant) {
	                icon.removeClass("fa-star-o").addClass("fa-star").css("color", "#4c4d4f");
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



function importantMail(mail_sent_no, button) {
    let icon = $(button).find("i"); // 클릭한 버튼 내 아이콘 요소 찾기
    //let isImportant = icon.hasClass("fa-star"); // 현재 즐겨찾기 여부 확인
    let currentStatus = $(button).attr("data-important-status");  // 현재 중요 여부

    
    console.log("번호",mail_sent_no)
    console.log("중요여부(클릭시) : ",currentStatus)
      

    $.ajax({
        url: "<%= ctxPath%>/mail/IDImportantSent",
        type: "POST",
        data: { "mail_sent_no": mail_sent_no 
        	  , "mail_sent_important":currentStatus},
        success: function (response) {
            if (response.success) { // 0->1 그러므로 currentStatus 는 0
				      			            	
            	if (currentStatus === "0") {
            		
            		// 일반메일 => 중요메일로 변경 (색상 회색 -> 검정)
                    icon.removeClass("fa-star-o").addClass("fa-star").css("color", "#4c4d4f");

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
                    icon.removeClass("fa-star-o").addClass("fa-star").css("color", "#4c4d4f");
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
        url: "<%= ctxPath%>/mail/sendMailTrashSent",
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


function trclick(mail_sent_no){
	
	const frm = document.goSendMailView;
	
	frm.mail_sent_no.value = mail_sent_no;
	
	console.log(mail_sent_no);
	
	frm.action = "<%= ctxPath%>/mail/sentMailView";
	frm.method = "get";
	frm.submit();
		
		
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

.btnWrite{

background-color:#006769;
border-radius: 10px;
border: none;
width: 80px;
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

.fa-file{

color:#4c4d4f;
}

#tblSent{
	box-shadow: 0 2px 5px rgba(0,0,0,.25); 
	border-radius: 5px;

}

</style>

<jsp:include page="../../header/header1.jsp" /> 

<div id="sub_mycontent">
<div class="header" style="font-size:15pt;  margin: 1% 5%; ">

	<div class="title">보낸 메일함</div>
	
</div>

<div style="margin:0% 5%">
	<div style="margin:0.2% 0%; float:left;"><button class="btnWrite" onclick="location.href='<%= ctxPath%>/mail/mailWrite'">메일쓰기</button></div>
	<div style="float:right; margin-left:0.5%;"><button class="btnDel" onclick="sendMailTrash()">삭제</button></div>
</div>


<div id=Container;>
	<div id="tableContainer" style="border:solid 0px red; margin: 1% 5%; width:90%;">

		<table class="table table-hover text-center" style="width: 100%; text-align:center;" id="tblSent">
			<thead class="btn-light" style="border: solid 0px black; height:50px;">
				<tr>
					<th style="width:10%">중요</th>
					<th style="width:40%">제목</th>
					<th style="width:20%">수신자</th>
					<th style="width:30%">발신일시</th>
					<th></th>			
				</tr>	
			</thead>
			
			<tbody>
				
				<c:if test="${not empty requestScope.mailSentList}">
					<c:forEach items="${requestScope.mailSentList}" var="msl" varStatus="status">
						<tr>
							<td style="border-bottom:solid 0px black; height:50px;"> <!-- <div id="starToggle"></div> -->
								<button type="button" class="btnstar btn-link p-0 no-outline" data-important="${msl.mail_sent_no}" data-important-status ="${msl.mail_sent_important}"							        
							        style="font-size: 1rem; color: black; background-color: transparent; border: none; outline: none;"
							        onclick="importantMail('${msl.mail_sent_no}', this)">
							        <i class="fa fa-star-o" aria-hidden="true"></i>
							    </button>			
							</td>
							<td onclick="trclick(${msl.mail_sent_no})" style="">${msl.mail_title}
							<c:if test="${not empty msl.mail_sent_file }">
								<i class="fa-solid fa-file"></i>
							</c:if>
							
							</td>
							<td style="">${msl.member_name}</td>
							<td style="">${msl.mail_sent_senddate}&nbsp;&nbsp;${msl.timediff}</td>
							<td style=""><input style="width:100px;"type="checkbox" class="mailCheckbox" data-mail-no="${msl.mail_sent_no}"/></td>
						</tr>
						<input type="hidden" value="${msl.mail_sent_important}" />
					</c:forEach>
				</c:if>
				<form name="goSendMailView">
					<input type="hidden" name="mail_sent_no"/>
				</form>
				<c:if test="${empty requestScope.mailSentList}">
						<tr style="text-align:center; height:550px;">
							<td colspan='4' style="border-bottom:solid 1px black; height:50px;">아직 보낸 메일이 없습니다.</td>
						</tr>
						
				</c:if>
			</tbody>
		</table>
		
		<div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
	</div>
</div>
 </div>




<jsp:include page="../../footer/footer1.jsp" />