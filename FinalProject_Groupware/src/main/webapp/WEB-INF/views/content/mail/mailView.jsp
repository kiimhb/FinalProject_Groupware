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




});






function goBackReceive(member_userid){

	window.location.href = `<%= ctxPath%>/mail/mailReceive/\${member_userid}`;

}

function goBackSent(member_userid){

	window.location.href = `<%= ctxPath%>/mail/mailSend/\${member_userid}`;

}


</script>





<jsp:include page="../../header/header1.jsp" /> 



<div id="sub_mycontent"> 
<div style="display: flex;">
  <div style="margin: 1% 5%;border:solid 0px black;">
	 <c:if test="${not empty requestScope.sentMap}">
	 	<table class="table table-bordered" style="width: 1024px; word-wrap: break-word; table-layout: fixed;">	 	   
	 	   <tr>
	 	      <th style="width: 13%">제목</th>
	 	      <td>${requestScope.sentMap.mail_title}</td>
	 	   </tr>	 	   	 	   
	 	   <tr>
	 	      <th>발신자</th>
	 	      <td>${requestScope.sentMap.SENT_MEMBER_NAME} <span style="font-weight:bold;">사번 : ${requestScope.sentMap.sk_member_userid }</span></td>
	 	   </tr>
	 	   
	 	   <tr>
	 	      <th>수신자</th>
	 	      <td>${requestScope.sentMap.RECEIVED_MEMBER_NAME} <span style="font-weight:bold;">사번 : ${requestScope.sentMap.rk_member_userid }</span></td>
	 	   </tr>	 	   	 	   	 	   
	 	   <tr>
	 	      <th>내용</th>
	 	      <td>
	 	         <p style="word-break: break-all;">
	 	            ${requestScope.sentMap.mail_sent_content}
	 	         <%-- 
				    style="word-break: break-all; 은 공백없는 긴영문일 경우 width 크기를 뚫고 나오는 것을 막는 것임. 
				        그런데 style="word-break: break-all; 나 style="word-wrap: break-word; 은
				        테이블태그의 <td>태그에는 안되고 <p> 나 <div> 태그안에서 적용되어지므로 <td>태그에서 적용하려면
				    <table>태그속에 style="word-wrap: break-word; table-layout: fixed;" 을 주면 된다.
				 --%>
	 	         </p>   
	 	      </td>
	 	   </tr>	 	   	 	   
	 	   <tr>
	 	      <th>날짜</th>
	 	      <td>${requestScope.sentMap.mail_sent_senddate}</td>
	 	   </tr>
	 	   
	 	   <%-- === #160. 첨부파일 이름 및 파일크기를 보여주고 첨부파일을 다운로드 되도록 만들기 === --%>
	 	   <tr>
	 	      <th>첨부파일</th>
	 	      <td>
	 	         <c:if test="${requestScope.sentMap.mail_sent_file != null}">
	 	            <a href="<%= ctxPath%>/mail/download?mail_sent_no=${requestScope.sentMap.mail_sent_no}">${requestScope.sentMap.mail_sent_file_origin}</a>
	 	         </c:if>
	 	         <c:if test="${requestScope.sentMap.mail_sent_file == null}">
	 	            첨부된 파일이 없습니다.
	 	         </c:if>
	 	      </td>
	 	   </tr>	 	   
	 	</table>
	 </c:if> 	 
	 
	 <c:if test="${not empty requestScope.receivedMap}">
	 
	 	<table class="table table-bordered" style="width: 1024px; word-wrap: break-word; table-layout: fixed;">

	 	   <tr>
	 	      <th style="width:13%">제목</th>
	 	      <td>${requestScope.receivedMap.mail_title}</td>
	 	   </tr>
	 	   
	 	   
	 	   <tr>
	 	      <th>발신자</th>
	 	      <td>${requestScope.receivedMap.SENT_MEMBER_NAME} <span style="font-weight:bold;">사번 : ${requestScope.receivedMap.sk_member_userid}</span></td>
	 	   </tr>
	 	   
	 	   <tr>
	 	      <th>수신자</th>
	 	      <td>${requestScope.receivedMap.RECEIVED_MEMBER_NAME} <span style="font-weight:bold;">사번 : ${requestScope.receivedMap.rk_member_userid}</span></td>
	 	   </tr>	 	   	 	   
	 	   
	 	   <tr>
	 	      <th>내용</th>
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
	 	   
	 	   <tr>
	 	      <th>날짜</th>
	 	      <td>${requestScope.receivedMap.mail_sent_senddate}</td>
	 	   </tr>
	 	   
	 	   <%-- === #160. 첨부파일 이름 및 파일크기를 보여주고 첨부파일을 다운로드 되도록 만들기 === --%>
	 	   <tr>
	 	      <th>첨부파일</th>
	 	      <td>
	 	         <c:if test="${requestScope.receivedMap.mail_sent_file != null}">
	 	            <a href="<%= ctxPath%>/mail/download?mail_sent_no=${requestScope.receivedMap.mail_sent_no}">${requestScope.receivedMap.mail_sent_file_origin}</a>
	 	         </c:if>
	 	         <c:if test="${requestScope.receivedMap.mail_sent_file == null}">
	 	            첨부된 파일이 없습니다.
	 	         </c:if>
	 	      </td>
	 	   </tr>
	 	   
	 	</table>
	 </c:if>
	 
	 
	 
	 
	 
	 
	 <c:if test="${not empty requestScope.receivedMap}">
	 	<button onclick="goBackReceive(${sessionScope.loginuser.member_userid})" style="float:right;" type="button">수신메일로가기목록</button>
	 </c:if>
	 <c:if test="${not empty requestScope.sentMap}">
	 	<button onclick="goBackSent(${sessionScope.loginuser.member_userid})" style="float:right;" type="button">발신메일로가기목록</button>
	 </c:if>
	 
  </div>
  
</div>  
</div>











<jsp:include page="../../footer/footer1.jsp" />