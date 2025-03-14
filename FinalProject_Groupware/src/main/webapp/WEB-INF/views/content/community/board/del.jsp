<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../../header/header1.jsp" />

<style type="text/css">

/* 전체 컨테이너 - 화면 중앙 정렬 */
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 80vh;  /* 화면 높이의 80% 차지 */
}

/* 삭제 폼을 감싸는 카드 스타일 */
.delete-form-container {
    width: 450px;
    padding: 30px;
    background: #fff;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    border-radius: 8px;
    text-align: center;
    border: 1px solid #ddd;
}

/* 제목 스타일 */
.header {
    display: flex;
    justify-content: center;  /* 가로 중앙 정렬 */
    align-items: center;  /* 세로 중앙 정렬 */
}

.header .title {
    text-align: center;  /* 텍스트 중앙 정렬 */
    font-size: 24px;
    margin-bottom: 20px;
    color: #4c4d4f;
    font-weight: bold;
    padding-left: 0;  /* 왼쪽 여백 제거 */
}


/* 글암호 입력 필드 */
input[type="password"] {
    width: 90%;
    padding: 8px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 4px;
    text-align: center;
}

/* 버튼 스타일 */
.btn {
    width: 45%;
    padding: 10px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 10px 5px;
    transition: 0.3s;
}

/* 삭제 버튼 */
.btn-delete {
    background-color: #006769;
    color: white;
}

.btn-delete:hover {
    background-color: #509d9c;
}

/* 취소 버튼 */
.btn-cancel {
    background-color: #f68b1f;
    color: white;
}

.btn-cancel:hover {
    background-color:#fca56f;
}

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

        // 폼(form) 전송
        const frm = document.delFrm;
        frm.method = "post";
        frm.action = "<%= ctxPath%>/board/del";
        frm.submit();
        
        
      
    });

  }); // end of $(document).ready(function(){})
</script>


<div class="container">
  <div class="delete-form-container">

    <!-- 제목 -->
    <div class="header">
      <div class="title">⚠️ 글 삭제</div>
    </div>

    <!-- 안내 문구 -->
    <p style="color: #d9534f; font-size: 16px;">
      ❗ 이 작업은 되돌릴 수 없습니다. <br> 정말 삭제하시겠습니까?
    </p>

    <!-- 삭제 폼 -->
    <form name="delFrm"> 
      <table class="table table-bordered" style="width: 100%;">
        <tr>
          <th style="width: 30%; background-color: #ecf2f1; text-align: center;">글암호</th> 
          <td>
            <input type="hidden" name="board_no" value="${requestScope.boardvo.board_no}" />
            <input type="password" name="board_pw" maxlength="20" placeholder="암호 입력">
          </td>
        </tr>	
      </table>
      
      <!-- 버튼 -->
      <div style="margin-top: 20px;">
        <button type="button" class="btn btn-delete" id="btnDelete">삭제완료</button>
        <button type="button" class="btn btn-cancel" onclick="alert('✅ 글 삭제를 취소하셨습니다.'); history.back();">취소</button>  
      </div>
    </form>

  </div>
</div>

<jsp:include page="../../../footer/footer1.jsp" />
    