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
	


	  
});// end of $(document).ready(function(){})-----------

</script>

<jsp:include page="../../header/header1.jsp" /> 


<div style=" border-radius:10px; font-size:15pt; text-align:center; margin: 1% 10%; background-color:#b3d6d2;">

	<span>받은 메일함</span>
	<span>${sessionScope.loginuser.member_userid}</span>
</div>


<div id=Container;>
	<div id="tableContainer" style="border:solid 1px red; margin: 1% 10%; width:80%;">

		<table style="width: 100%; text-align:center;">
			<thead  style="border: solid 1px black;">
				<tr>
					<th style="width:20%">중요</th>
					<th style="width:30%">제목</th>
					<th style="width:20%">보낸사람</th>
					<th style="width:30%">발신일시</th>			
				</tr>	
			</thead>
			
			<tbody  style="border: solid 1px black;">
				<c:forEach items="${requestScope.mailReceiveList}" var="mrl">
					<tr>
						<td style="border-bottom:solid 1px black">중요</td>
						<td style="border-bottom:solid 1px black">${mrl.mail_title}</td>
						<td style="border-bottom:solid 1px black">${mrl.member_name}</td>
						<td style="border-bottom:solid 1px black">${mrl.mail_sent_senddate}&nbsp;&nbsp;${mrl.timediff }</td>
					</tr>
					<input type="hidden" value="${mrl.mail_sent_no}" />
				</c:forEach>
			</tbody>
		</table>
		
		<div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
	    </div>
	</div>
</div>





<jsp:include page="../../footer/footer1.jsp" />