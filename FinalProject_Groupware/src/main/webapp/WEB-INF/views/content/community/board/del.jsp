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
  $(document).ready(function() {
    
    // 삭제완료 버튼 클릭 이벤트
    $("button#btnDelete").click(function() {
      
      // 글암호 입력 확인
      const board_pw = $("input:password[name='board_pw']").val().trim();
      if (board_pw === "") {
        alert("⚠️ 글암호를 입력하세요!!");
        return; // 종료
      }

      // 글암호 일치 여부 확인
      if ("${requestScope.boardvo.board_pw}" !== board_pw) {
        alert("❌ 입력하신 글암호가 원래 암호와 일치하지 않습니다.");
        return; // 종료
      }

      // 최종 삭제 확인
      if (confirm("⚠️ 이 작업은 되돌릴 수 없습니다. 정말 삭제하시겠습니까?")) {
        
        // 폼(form) 전송
        const frm = document.delFrm;
        frm.method = "post";
        frm.action = "<%= ctxPath%>/board/del";
        frm.submit();
      } else {
        alert("✅ 삭제가 취소되었습니다.");
      }
    });

  }); // end of $(document).ready(function(){})
</script>


<div style="display: flex;">
  <div style="margin: auto; padding-left: 3%;">
     
       <h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">글삭제</h2>
     
       <form name="delFrm"> 
        <table style="width: 500px" class="table table-bordered">
			<tr>
				<th style="width: 15%; background-color: #DDDDDD; text-align: center;">글암호</th> 
				<td>
				    <input type="hidden" name="board_no" value="${requestScope.boardvo.board_no}" />
				    <input type="password" name="board_pw" maxlength="20" />
				</td>
			</tr>	
        </table>
        
        <div style="margin: 20px; text-align: center;">
            <button type="button" class="btn btn ml-2" id="btnDelete">삭제완료</button>
            <button type="button" class="btn btn ml-2" onclick="javascript:history.back()">취소</button>  
        </div>
        
     </form>
     
  </div>
</div>

<jsp:include page="../../../footer/footer1.jsp" />
    