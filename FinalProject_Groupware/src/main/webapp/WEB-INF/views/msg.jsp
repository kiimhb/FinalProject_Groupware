<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">

	alert("${requestScope.message}");	// 메시지 출력
	
	// 위 메세지 띄운 후 페이지 이동
	location.href = "${requestScope.loc}"
	 
	 if( ${not empty requestScope.popup_close && requestScope.popup_close == true}) {
		 opener.history.go(0);    // 부모창 새로고침 
		 self.close();			  // 팝업창 닫기
	 }
	 
</script>