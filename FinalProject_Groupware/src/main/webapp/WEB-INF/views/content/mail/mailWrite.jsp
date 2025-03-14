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
	
	
	<%-- 조직도에서 넘어온 경우 받는 사람 member_userid 자동기입 --%>
	const from_orgUserId = "${requestScope.member_userid}";

	if(from_orgUserId != "" && from_orgUserId != undefined) {
		$("input[name='mail_received_userid']").val(from_orgUserId);
	}
	
	/////////////////////////////////////////////////////////////////

	   	// ==== 스마트 에디터 구현 시작 ====
		//전역변수
	    var obj = [];
	    
	    //스마트에디터 프레임생성
	    nhn.husky.EZCreator.createInIFrame({
	        oAppRef: obj,
	        elPlaceHolder: "mail_sent_content",
	        sSkinURI: "<%= ctxPath%>/smarteditor/SmartEditor2Skin.html",
	        htParams : {
	            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseToolbar : true,            
	            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseVerticalResizer : true,    
	            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseModeChanger : true,
	        }
	    });

	  
	   
	  
	  $("button#btnWrite").click(function(){
		  
		  obj.getById["mail_sent_content"].exec("UPDATE_CONTENTS_FIELD", []);
		  // const fk_member_userid = $("input:hidden[name='fk_member_userid']").val()
		  
		  <%-- 메일 폼 전송하기--%>
		  const frm = document.addFrm;
	      frm.method = "post";
	      frm.action = "<%= ctxPath%>/mail/mailWrite";
	      frm.submit();

	      alert("메일 전송이 완료되었습니다 !")
	      
	      
		  
		  
	  });
	  
	  
	  
});// end of $(document).ready(function(){})-----------

</script>




<jsp:include page="../../header/header1.jsp" /> 

<div style=" border-radius:10px; font-size:15pt; text-align:center; margin: 1% 10%; background-color:#b3d6d2;">

	<span>메일 쓰기</span>

</div>

<div id="container" style="margin:1% 10%;">

<form name="addFrm" enctype="multipart/form-data">

   		<table style="width: 1332px" class="table table-bordered">
   		   		
			 <tr>
				<th style="width: 15%; background-color: #b3d6d2;">받는사람 <%-- 수신자 --%>
					<span style="float:right;"><input type="checkbox" name="mail_sent_important" value="1"/>&nbsp;중요</span>
				</th>
			    <td>
			       <input type="text" name="mail_received_userid">
			       <input type="hidden" name="fk_member_userid" value="${sessionScope.loginuser.member_userid }"/>
			       <button style ="background-color : #b3d6d2">주소록</button>
			    </td>
   		     </tr>
   		     
   		     <tr>
   		        <th style="width: 15%; background-color: #b3d6d2;">제목</th>
   		        <td>
   		        	<input type="text" name="mail_title" size="100" maxlength="200" />
   		        </td>
   		     </tr>
   		     
   		     <tr>
				<th style="width: 15%; background-color: #b3d6d2;">내용</th> 
				<td>
				    <textarea style="width: 100%; height: 440px;" name="mail_sent_content" id="mail_sent_content"></textarea>
				</td>
			 </tr>
			 
			 <%-- === #145. 파일첨부 타입 추가하기 === --%>
			 <tr>
			    <th style="width: 15%; background-color: #b3d6d2;">파일첨부</th>
			    <td>
			        <input type="file" name="attach" />
			    </td>
			 </tr>

   		</table>
   		
		<div style="float:right; margin: 5px;">
            <button type="button" class="btn btn-secondary btn-sm mr-3" id="btnWrite">보내기</button>
            <button type="button" class="btn btn-secondary btn-sm" onclick="javascript:history.back()">취소</button>  
        </div>

	</form>
	

</div>












<jsp:include page="../../footer/footer1.jsp" />