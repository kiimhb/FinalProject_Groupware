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




});






function goBackReceive(member_userid){

	window.location.href = `<%= ctxPath%>/mail/mailReceive/\${member_userid}`;

}

function goBackSent(member_userid){

	window.location.href = `<%= ctxPath%>/mail/mailSend/\${member_userid}`;

}


</script>


<style type="text/css">


.btnBack{

background-color:#006769;
border-radius: 10px;
border: none;
width: 80px;
height:35px;
color:white;

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

.atag{

color:#006769;

}

table {
    width: 100%;
    border-collapse: separate; /* 셀 간 경계를 분리하여 테두리와 border-radius가 적용되도록 */
    border: none; /* 테이블 외부 테두리 제거 */
}

th, td {
    border: 1px solid black; /* th와 td에만 테두리 적용 */
    border-radius: 3px; /* 각 셀에 둥근 테두리 적용 */
    padding: 10px; /* 셀 안의 여백 */
}

span.tableSpan {
	display: inline-block;
	margin-left: 30%;
}

span.tableSpanHriedate {
	display: inline-block;
	margin-left: 26%;
}

</style>



<jsp:include page="../../header/header1.jsp" /> 



<div id="sub_mycontent"> 
<div style="display: flex;">
  <div style="margin: 1% 5%;border:solid 0px black;">
  		
	 <c:if test="${not empty requestScope.sentMap}">
	 	<div class="header" style="font-size:15pt;">
			<div class="title">보낸메일
			<c:if test="${not empty requestScope.sentMap}">
			 	<button class="btnBack" onclick="goBackSent(${sessionScope.loginuser.member_userid})" style="font-size:12pt; float:right;" type="button">목록</button>			 
			 </c:if>			 						
			</div>

		</div>
		
	 	<table class="table table-bordered" style="word-wrap: break-word; table-layout: fixed;">	 	   
	 	   <tr style="font-size:15pt; font-weight:bold;">
	 	      <th style="width: 13%; background-color: #b3d6d2;">제목</th>
	 	      <td>${requestScope.sentMap.mail_title}</td>
	 	   </tr>	 	   	 	   
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">발신자</th>
	 	      <td>${requestScope.sentMap.SENT_MEMBER_NAME} <span style="font-weight:bold;">[${requestScope.sentMap.sk_member_userid }]</span></td>
	 	   </tr>
	 	   
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">수신자</th>
	 	      <td>${requestScope.sentMap.RECEIVED_MEMBER_NAME} <span style="font-weight:bold;">[${requestScope.sentMap.rk_member_userid }]</span></td>
	 	   </tr>
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">날짜</th>
	 	      <td>${requestScope.sentMap.mail_sent_senddate}</td>
	 	   </tr>
	 	   
	 	   <%-- === #160. 첨부파일 이름 및 파일크기를 보여주고 첨부파일을 다운로드 되도록 만들기 === --%>
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">첨부파일</th>
	 	      <td>
	 	         <c:if test="${requestScope.sentMap.mail_sent_file != null}">
	 	            <a class="atag" href="<%= ctxPath%>/mail/download?mail_sent_no=${requestScope.sentMap.mail_sent_no}">${requestScope.sentMap.mail_sent_file_origin}</a>
	 	         </c:if>
	 	         <c:if test="${requestScope.sentMap.mail_sent_file == null}">
	 	            첨부된 파일이 없습니다.
	 	         </c:if>
	 	      </td>
	 	   </tr>	 	   	 	   	 	   
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">내용</th>
	 	      <td>
	 	         <p style="word-break: break-all;">
	 	            ${requestScope.sentMap.mail_sent_content}
	 	         </p>   
	 	      </td>
	 	   </tr>	 	   	 	   
	 	   	 	   
	 	</table>
	 </c:if> 	 
	 
	 <c:if test="${not empty requestScope.receivedMap}">

		<div class="header" style="font-size:15pt;">
			<div class="title">받은메일
			<c:if test="${not empty requestScope.receivedMap}">
			 	<button class="btnBack" onclick="goBackReceive(${sessionScope.loginuser.member_userid})" style="font-size:12pt; float:right;" type="button">목록</button>
			 </c:if>			
			</div>			
		</div>
		
	 	<table class="table table-bordered" style="word-wrap: break-word; table-layout: fixed;">

	 	   <tr style="font-size:15pt; font-weight:bold;">
	 	      <th style="width:13%; background-color: #b3d6d2;">제목</th>
	 	      <td>${requestScope.receivedMap.mail_title}</td>
	 	   </tr>
	 	   
	 	   
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">발신자</th>
	 	      <td>${requestScope.receivedMap.SENT_MEMBER_NAME} <span style="font-weight:bold;">[${requestScope.receivedMap.sk_member_userid}]</span></td>
	 	   </tr>
	 	   
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">수신자</th>
	 	      <td>${requestScope.receivedMap.RECEIVED_MEMBER_NAME} <span style="font-weight:bold;">[${requestScope.receivedMap.rk_member_userid}]</span></td>
	 	   </tr>
	 	   
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">날짜</th>
	 	      <td>${requestScope.receivedMap.mail_sent_senddate}</td>
	 	   </tr>
	 	   
	 	   <%-- === #160. 첨부파일 이름 및 파일크기를 보여주고 첨부파일을 다운로드 되도록 만들기 === --%>
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">첨부파일</th>
	 	      <td>
	 	         <c:if test="${requestScope.receivedMap.mail_sent_file != null}">
	 	            <a class="atag" href="<%= ctxPath%>/mail/download?mail_sent_no=${requestScope.receivedMap.mail_sent_no}">${requestScope.receivedMap.mail_sent_file_origin}</a>
	 	         </c:if>
	 	         <c:if test="${requestScope.receivedMap.mail_sent_file == null}">
	 	            첨부된 파일이 없습니다.
	 	         </c:if>
	 	      </td>
	 	   </tr>	 	   	 	   
	 	   
	 	   <tr>
	 	      <th style="background-color: #b3d6d2;">내용</th>
	 	      <td>
	 	         <p style="word-break: break-all;">
	 	            ${requestScope.receivedMap.mail_sent_content}
	 	         <%-- 
				    style="word-break: break-all; 은 공백없는 긴영문일 경우 width 크기를 뚫고 나오는 것을 막는 것임. 
				        그런데 style="word-break: break-all; 나 style="word-wrap: break-word; 은
				        테이블태그의 <td>태그에는 안되고 <p> 나 <div> 태그안에서 적용되어지므로 <td>태그에서 적용하려면
				    <table>태그속에 style="word-wrap: break-word; table-layout: fixed;" 을 주면 된다.
				 --%>
	 	         </p>   
	 	      </td>
	 	   </tr>	 	   
	 	   
	 	   
	 	   
	 	</table>
	 </c:if>
	 
	 
	 
	 
	 
	 
	 
	 
	 
  </div>
  
</div>  
</div>











<jsp:include page="../../footer/footer1.jsp" />