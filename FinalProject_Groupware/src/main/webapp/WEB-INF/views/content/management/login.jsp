<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<%
String ctxPath = request.getContextPath();
//     /myspring
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마포아삭병원</title>
<link rel="icon" href="<%=ctxPath%>/image/Favicon_logo.png"
	type="image/png">
<style type="text/css">
body {
	margin: 0;
	padding: 0;
	width: 100%;
	height: 100vh;
	position: relative;
	background-image: linear-gradient(to bottom, white 17%, rgba(255, 255, 255, 0.1)
		50%, rgba(255, 255, 255, 0.5) 100%),
		url("<%=ctxPath%>/image/서울아산병원.jpg");
	background-position: center center;
	background-size: cover;
	background-attachment: fixed;
	overflow: hidden;
	transition: background-image 15s ease-in-out;
}

/* 불투명 블랙 레이어 */
body::before {
	content: "";
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.3);
	z-index: 0;
}

div.logo-container {
	display: flex;
	align-items: center;
	margin-left: 20px;
	margin-top: 15px;
	padding-bottom: 5px;
}

img.logo-img {
	width: 60px;
	height: 60px;
}

div.logo-text {
	display: flex;
	flex-direction: column;
	line-height: 1.2;
}

span.main_logo, span.main_logo2 {
	font-size: 18px;
	color: #006769;
	font-weight: bold;
}

span.main_logo2 {
	font-size: 11px;
}

div>div.login_container {
	/* border: solid 1px maroon; */
	border-radius:5px;
	padding:5px;
	background-color:white;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	align-items: center;
	width: 500px;
	height: 210px;
	top: 250px;
	right: 240px;
  	position: absolute;
}

div.login_form{
	display: flex;
	margin-top: 20px;
}

div.loginFrm_input{
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 10px;
	margin-left: 45px;
}

div.loginFrm_input label{
	width: 80px;
	font-weight: bold;
}

div.loginFrm_input input{
	padding: 4px;
	width: 230px;
	
}

button#btnLOGIN{
	font-size: 15px;
	margin-left:10px;
	padding: 23px;
	border: none;
	background-color: #006769;
	color: white;
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
		  
		  frm.action = "<%=ctxPath%>/management/login";
			frm.method = "post";
			frm.submit();
		};

		$("button#btnLOGIN").click(function() {
			func_Login();
		});

		$("input:password[id='member_pwd']").keydown(function(e) {
			if (e.keyCode == 13) { // 엔터를 했을 경우
				func_Login();
			}
		});

	});// end of $(document).ready(function(){})----------------
</script>


</head>

<div class="login_main_container">


	<div class="login_container">

		<div class="login_logo-container">
			<div class="logo-container">
				<img class="logo-img" src="<%=ctxPath%>/image/main_logo.png">
				<div class="logo-text">
					<span class="main_logo">마포아삭병원</span> <span class="main_logo2">Asak Medical Center</span>
				</div>	
			</div>	
			<div style="border-bottom: solid 1px #eee; margin: 10px; margin-bottom: 3px; "></div>
		</div>
		
		

		<div class="login_form">
			<form name="loginFrm">
				<div class="loginFrm_input">
					<label class="Frm" for="userid">사번</label> <input type="text" class="form-control"  name="member_userid" id="member_userid" value="" />
				</div>

				<div class="loginFrm_input">
					<label class="Frm" for="pwd">비밀번호</label> <input type="password"  class="form-control" name="member_pwd" id="member_pwd" value="" />
				</div>
			</form>

			<div>
				<button type="button" id="btnLOGIN">LOGIN</button>
			</div>
		</div>


	</div>


</div>