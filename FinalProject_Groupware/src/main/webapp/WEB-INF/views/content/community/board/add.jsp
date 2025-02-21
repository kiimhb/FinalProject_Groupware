<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../../header/header1.jsp" /> 

<style type="text/css">
table {
    margin: auto; /* 테이블을 화면 가운데로 정렬 */
}

th {
    text-align: center; /* th 내부 텍스트 가운데 정렬 */
    vertical-align: middle; /* 텍스트 수직 정렬 */
}

.find-btn{
	text-align: center;
}
.find-btn1{
	display :inline-block;
}


</style> 

<script type="text/javascript">

  $(document).ready(function(){  
	  
	  <%--  ==== 스마트 에디터 구현 시작 ==== --%>
		//전역변수
	    var obj = [];
	    
	    //스마트에디터 프레임생성
	    nhn.husky.EZCreator.createInIFrame({
	        oAppRef: obj,
	        elPlaceHolder: "board_content",
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
	  <%--  ==== 스마트 에디터 구현 끝 ==== --%>
	  
	  
	  // 글쓰기 버튼
	  $("button#btnWrite").click(function(){
		  
		  <%-- === 스마트 에디터 구현 시작 === --%>
		   // id가 content인 textarea에 에디터에서 대입
	       obj.getById["board_content"].exec("UPDATE_CONTENTS_FIELD", []);
		  <%-- === 스마트 에디터 구현 끝 === --%>
		  
		  // === 글제목 유효성 검사 === 
	      const board_subject = $("input:text[name='board_subject']").val().trim();	  
	      if(board_subject == "") {
	    	  alert("글제목을 입력하세요!!");
	    	  $("input:text[name='board_subject']").val("");
	    	  return; // 종료
	      }	
		  
		  // === 글내용 유효성 검사(스마트 에디터를 사용할 경우) ===
		  let board_content_val = $("textarea[name='board_content']").val().trim();
		  
	  //  alert(content_val);  // content 에 공백만 여러개를 입력하여 쓰기할 경우 알아보는 것.
	  //  <p>&nbsp; &nbsp; &nbsp; &nbsp;</p> 이라고 나온다.
	  
	      board_content_val = board_content_val.replace(/&nbsp;/gi, "");  // 공백(&nbsp;)을 "" 으로 변환
	      /*    
		         대상문자열.replace(/찾을 문자열/gi, "변경할 문자열");
			   ==> 여기서 꼭 알아야 될 점은 나누기(/)표시안에 넣는 찾을 문자열의 따옴표는 없어야 한다는 점입니다. 
			               그리고 뒤의 gi는 다음을 의미합니다.
			
			   g : 전체 모든 문자열을 변경 global
			   i : 영문 대소문자를 무시, 모두 일치하는 패턴 검색 ignore
	      */
	   // alert(board_content_val);
	   // <p>                                      </p>
	   
	      board_content_val = board_content_val.substring(board_content_val.indexOf("<p>")+3);
	   // alert(content_val);
		  //                                       </p>
		  
	      board_content_val = board_content_val.substring(0, board_content_val.indexOf("</p>"));
	   // alert(content_val);
	     
	      if(board_content_val.trim().length == 0) {
	    	  alert("글내용을 입력하세요!!");
	    	  return; // 종료
	      }
	      
	      
	   	  // === 글암호 유효성 검사 === 
	      const board_pw = $("input:password[name='board_pw']").val();	  
	      if(board_pw == "") {
	    	  alert("글암호를 입력하세요!!");
	    	  return; // 종료
	      }	  
	    	  
	      // 폼(form)을 전송(submit)
	      const frm = document.addFrm;
	      frm.method = "post";
	      frm.action = "<%= ctxPath%>/board/add";
	      frm.submit();
	  });
	  
  });// end of $(document).ready(function(){})-----------

</script>	  
	  
<div style="display: flex;">
  <div style="margin: auto; padding-left: 3%;"> 
   
    <%-- === 원글쓰기인 경우 --%>
	<h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">글쓰기</h2>

	<%-- === 답변글쓰기인 경우 --%>
   <c:if test='${requestScope.fk_board_no ne ""}'>
  	 <h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">답변글쓰기</h2>
   </c:if>
   
	<form name="addFrm" enctype="multipart/form-data">
	   		<table style="width: 1200px" class="table table-bordered">
				 <tr>
					<th style="width: 15%; background-color: #00000; ">성명</th>
				    <td>
				       <input type="hidden" name="fk_member_userid" value="${sessionScope.loginuser.member_userid}" />
				       <input type="text" name="board_name" value="${sessionScope.loginuser.member_name}" readonly>
				    </td>	
	   		     </tr>
	   		     
	   		     <tr>
	   		        <th style="width: 15%; background-color: #00000;">제목</th>
	   		        <td>
	   		        
	   		         <%-- === 원글쓰기인 경우 (requestScope 무언가를 보내주어야 한다 여기서는 subject를 보내줌) --%>
	   				 <c:if test='${requestScope.fk_board_no eq ""}'>
   		            	 <input type="text" name="board_subject" size="100" maxlength="200" />
   		             </c:if>
   		            
   		            <%-- === 답변글쓰기인 경우 --%>
   					<c:if test='${requestScope.fk_board_no ne ""}'>
   		            	<input type="text" name="board_subject" size="100" value="${requestScope.board_subject}" readonly />
   		            </c:if>
   		            
	   		        </td>
	   		     </tr>
	   		     
	   		     <tr>
					<th style="width: 15%; background-color: #00000;">내용</th> 
					<td>
					    <textarea style="width: 100%; height: 612px;" name="board_content" id="board_content"></textarea>
					</td>
				 </tr>

				<tr>
					<th style="width: 15%; background-color: #00000;">파일첨부</th>
					<td>
						<input type="file" name="attach" /> <%-- attach는 컬럼이 아님 --%>
					</td>
				</tr>

				<tr>
					<th style="width: 15%; background-color: #00000;">글암호</th> 
					<td>
					    <input type="password" name="board_pw" maxlength="20"  />
					</td>
				 </tr>
	   		</table>
	   		
	   		<%-- === 답변글쓰기가 추가된 경우 시작 === --%>
   			<input type="hidden" name="fk_board_no" value="${requestScope.fk_board_no}" />
   			<input type="hidden" name="board_groupno" value="${requestScope.board_groupno}" />
   			<input type="hidden" name="board_depthno" value="${requestScope.board_depthno}" />
   			
   			<%-- === 답변글쓰기가 추가된 경우 끝 === --%>
	   		<div style="margin: 20px;">
	            <button type="button" class="btn btn-secondary btn-sm mr-3" id="btnWrite">글쓰기</button>
	            <button type="button" class="btn btn-secondary btn-sm" onclick="javascript:history.back()">취소</button>  
	        </div>
	   		
	 </form>
	   
  </div>
</div>	  
	  
<jsp:include page="../../../footer/footer1.jsp" />




	  
	  
  