<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
<style type="text/css">
div.login_container{
	border: solid 1px green;
	width: 20%;
	height: 350px;
}
div.container_2{
	border: solid 1px yellow;
	margin: 20px;
}
h2.login_h2{
	border-bottom: solid 1px gray; 
}

button#btnLOGIN{
	cursor: pointer; 
}

</style>    
    
<script type="text/javascript">
 
  $(document).ready(function(){
	  
	  const func_Login = function(){
		  
		  const userid = $("input#member_userid").val();
		  const pwd = $("input#member_pwd").val();
		  
		  if(userid.trim() == "") {
			  alert("아이디를 입력하세요!!");
			  $("input#member_userid").val("");
			  $("input#member_userid").focus();
			  return; // 종료
		  }
		  
		  if(pwd.trim() == "") {
			  alert("비밀번호를 입력하세요!!");
			  $("input#member_pwd").val("");
			  $("input#member_pwd").focus();
			  return; // 종료
		  }
		  
		  const frm = document.loginFrm;
		  
		  frm.action = "<%= ctxPath%>/management/login";
		  frm.method = "post";
	  	  frm.submit();
	  };
	  
	  
	  $("button#btnLOGIN").click(function(){
		  func_Login();
	  });
	  
	  
	  $("input:password[id='member_pwd']").keydown(function(e){
			if(e.keyCode == 13) { // 엔터를 했을 경우
				func_Login();
			}  
	  });
	  
  });// end of $(document).ready(function(){})----------------
</script>



<div class="login_main_container">


<div class="login_container">
	<div class="container_2">
			<h2 class="login_h2">로그인</h2>
			
			<form name="loginFrm" >
			<div>    
			    <div>
					<label class="" for="userid">사번</label>
					<input type="text"  class="form-control"  name="member_userid" id="member_userid" value=""/> <%-- 부트스트랩에서 input 태그에는 항상 class form-control 이 사용되어져야 한다. --%>
	            </div>
	
				<div>
					<label class="" for="pwd">비밀번호</label>
					<input type="password"  class="form-control"  name="member_pwd" id="member_pwd" value="" /> 
				</div>
			</div>
			</form>
			
		<div>
			<div>
				<button type="button" id="btnLOGIN">확인</button>
			</div>
		</div>
		
	</div>
</div>


</div>

