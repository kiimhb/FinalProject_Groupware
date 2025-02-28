<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../../header/header1.jsp" />  

<style type="text/css">

  button.btn {
	background-color: #006769;
	color:white;

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
	  
	  
	  // 수정완료 버튼
	  $("button#btnUpdate").click(function(){
		  
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
	      else {
	    	  if("${requestScope.boardvo.board_pw}" != board_pw) {
	    		  alert("입력하신 글암호가 원래암호와 일치하지 않습니다.");
		    	  return; // 종료
	    	  }
	      }
	    	  
	      // 폼(form)을 전송(submit)
	      const frm = document.editFrm;
	      frm.method = "post";
	      frm.action = "<%= ctxPath%>/board/edit";
	      frm.submit();
	  });
	  
  });// end of $(document).ready(function(){})-----------

</script>	  
	  
<div style="display: flex;">
  <div style="margin: auto; padding-left: 3%;"> 
   
   <h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">글수정</h2>
   
   <form name="editFrm" >
   		<table style="width: 1200px" class="table table-bordered">
			 <tr>
				<th style="width: 15%; background-color: #DDDDDD;">성명</th>
			    <td>
			       <input type="hidden" name="board_no" value="${requestScope.boardvo.board_no}" />
			       <input type="text" name="board_name" value="${sessionScope.loginuser.member_name}" readonly>
			    </td>	
   		     </tr>
   		     
   		     <tr>
   		        <th style="width: 15%; background-color: #DDDDDD;">제목</th>
   		        <td>
   		            <input type="text" name="board_subject" size="100" maxlength="200" value="${requestScope.boardvo.board_subject}" />
   		        </td>
   		     </tr>
   		     
   		     <tr>
				<th style="width: 15%; background-color: #DDDDDD;">내용</th> 
				<td>
				    <textarea style="width: 100%; height: 612px;" name="board_content" id="board_content">${requestScope.boardvo.board_content}</textarea>
				</td>
			 </tr>
   		    
   		     <tr>
				<th style="width: 15%; background-color: #DDDDDD;">글암호</th> 
				<td>
				    <input type="password" name="board_pw" maxlength="20" />
				</td>
			 </tr>
   		</table>
   		
   		<div style="margin: 20px; text-align: center;">
            <button type="button" class="btn btn ml-2" id="btnUpdate">수정완료</button>
            <button type="button" class="btn btn ml-2" onclick="javascript:history.back()">취소</button>  
        </div>
   		
   </form>
   
  </div>
</div>	  
	  
<jsp:include page="../../../footer/footer1.jsp" />




	  
	  
  