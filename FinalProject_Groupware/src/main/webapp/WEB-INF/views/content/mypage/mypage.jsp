<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
//     /med-groupware
%>
<jsp:include page="../../header/header1.jsp" />

<style type="text/css">
input[readonly] {
	background-color: #f2f2f2;
	border:none;
  	color: #b3b3b3;
  	cursor: not-allowed;
}


</style>

<script type="text/javascript">
$(document).on("change", "input.img_file1", function(e) {
    const inputFile1 = $(e.target).get(0);
    const file = inputFile1.files[0];

    if (!file) { 
        $("#previewimg1").attr("src", "");  // 파일 선택 취소 시 초기화
        return;
    }
    
    // 파일 타입 및 크기 검사
    const fileType = file.type;
    const fileSize = file.size / 1024 / 1024; // MB 단위
    if (!fileType.match("image/(jpeg|png|jpg)")) {
        alert("jpg 또는 png 형식의 이미지만 업로드 가능합니다.");
        $(this).val(""); // 입력값 초기화
        $("#previewimg1").attr("src", ""); // 초기화
        return;
    }
    if (fileSize > 3) {
        alert("파일 크기는 3MB 이하로 업로드해야 합니다.");
        $(this).val(""); // 입력값 초기화
        $("#previewimg1").attr("src", ""); // 초기화
        return;
    }
    
 // 이미지 미리보기 처리
    const fileReader = new FileReader();
    fileReader.onload = function(event) {
        $("#previewimg1").attr("src", event.target.result);
    };
    fileReader.readAsDataURL(file);
}); 

$(document).on("change", "input.img_file2", function(e) {
    const inputFile2 = $(e.target).get(0);
    const file = inputFile2.files[0];

    if (!file) { 
        $("#previewimg2").attr("src", "");  // 파일 선택 취소 시 초기화
        return;
    }
    
    // 파일 타입 및 크기 검사
    const fileType = file.type;
    const fileSize = file.size / 1024 / 1024; // MB 단위
    if (!fileType.match("image/(jpeg|png|jpg)")) {
        alert("jpg 또는 png 형식의 이미지만 업로드 가능합니다.");
        $(this).val(""); // 입력값 초기화
        $("#previewimg2").attr("src", ""); // 초기화
        return;
    }
    if (fileSize > 3) {
        alert("파일 크기는 3MB 이하로 업로드해야 합니다.");
        $(this).val(""); // 입력값 초기화
        $("#previewimg2").attr("src", ""); // 초기화
        return;
    }
    
 // 이미지 미리보기 처리
    const fileReader = new FileReader();
    fileReader.onload = function(event) {
        $("#previewimg2").attr("src", event.target.result);
    };
    fileReader.readAsDataURL(file);
}); 


$("button#mypage_edit").click(function() {
	const member_pwd = $("input:password[name='member_pwd']").val().trim();
	const member_pwd2 = $("input:password[id='member_pwd2']").val().trim();
	
	if (member_pwd != member_pwd2) {
		alert("암호가 일치하지 않습니다.");
		$("input:password[name='member_ pwd']").val("");
		$("input:password[id='member_ pwd2']").val("");
		return;
	}
	
	const regExpPwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/;
	
	if (!regExpPwd.test(member_pwd)) {
		alert("암호는 8글자 이상 15글자 이하에 영문자, 숫자, 특수기호가 혼합되어야만 합니다.");
		$("input:password[name='member_pwd']").val("");
		$("input:password[id='member_pwd2']").val("");
		return;
	}

    const name = $("#name").val().trim();
    const regExp_Name = /^[가-힣\s]{2,10}$/;
    if (name === "" || !regExp_Name.test(name)) {
        alert("이름을 올바르게 입력하세요.");
        $("#name").focus();
        return;
    }

    if ($("#email").val().trim() == "") {
        alert("이메일을 입력하세요.");
        $("#email").focus();
        return;
    }
    if ($("#hp2").val().trim() == "") {
        alert("전화번호 중간 자리를 입력하세요.");
        $("#hp2").focus();
        return;
    } else {
        $('#hp_error').hide();  
    }
    if ($("#hp3").val().trim() == "") {
        alert("전화번호 마지막 자리를 입력하세요.");
        $("#hp3").focus();
        return;
    } else {
        $('#hp_error').hide();  
    }
    
    const member_mobile = $('#hp1').val() + '-' + $('#hp2').val() + '-' + $('#hp3').val();
    const member_workingTime = "day";

    const frm = document.ManagementFrom;
    $('#member_mobile').val(member_mobile); 

    frm.method = "post";
    frm.action = "<%= ctxPath%>/mypage/mypageEdit";
    //frm.submit();
});

</script>

<form name="Mypageedt" enctype="multipart/form-data">
<div class="form-group">
    <label for="member_userid">사번</label>
    <input type="text" name="member_userid" id="member_userid" value="${sessionScope.loginuser.member_userid}"  readonly />
</div>

<div class="form-group">
    <label for="member_pwd">암호</label>
    <input type="password" id="member_pwd" name="member_pwd" size="25" />
</div>

<div class="form-group">
    <label for="member_pwd2">새암호확인</label>
    <input type="password" id="member_pwd2" name="member_pwd2"  size="25" />
</div>

<div class="form-group">
    <label for="child_dept_name">하위부서</label>
    <input type="text" name="child_dept_name" id="child_dept_name" value="${sessionScope.loginuser.child_dept_name}" readonly />
</div>

<div class="form-group">
    <label for="member_position">직급</label>
    <input type="text" name="member_position" id="member_position" value="${sessionScope.loginuser.member_position}" readonly />
</div>

<div class="form-group">
    <label for="member_name">이름</label>
    <input type="text" name="member_name" id="member_name" value="${sessionScope.loginuser.member_name}" />
</div>

<div class="form-group">
    <label for="hp1">휴대전화</label>
    <input type="text" name="hp1" id="hp1" maxlength="3" value="010" readonly />
    <span>-</span>
    <input type="text" name="hp2" id="hp2" maxlength="4" value="${sessionScope.loginuser.member_mobile.substring(4,8)}" />
    <span>-</span>
    <input type="text" name="hp3" id="hp3" maxlength="4" value="${sessionScope.loginuser.member_mobile.substring(9)}" />
</div>

<div class="form-group">
    <label for="member_email">이메일</label>
    <input type="text" name="member_email" id="member_email" value="${sessionScope.loginuser.member_email}" />
</div>

<div class="form-group">
    <label for="member_birthday">생년월일</label>
    <input type="date" name="member_birthday" id="member_birthday" value="${sessionScope.loginuser.member_birthday}" readonly />
</div>

<div class="form-group">
    <label for="member_gender">성별</label>
    <input type="text" name="member_gender" value="${sessionScope.loginuser.member_grade == '남' ? '남자' : '여자'}" readonly />
</div>

<div class="form-group">
    <label for="member_workingTime">근무시간</label>
    <input type="text" name="member_workingTime" id="member_workingTime" value="${sessionScope.loginuser.member_workingTime}" readonly />
</div>

<div class="form-group image-group">
    <img id="previewimg1" width="137" height="176" src="<%=ctxPath%>/resources/profile/${sessionScope.loginuser.member_pro_filename}" alt="프로필">
    <input type="file" name="attach" class="img_file1" accept="image/*">
</div>

<div  class="form-group image-group" >
   <div style="	width:137; height:176; border: solid 1px;"> <img id="previewimg2" width="137" height="176" src="<%=ctxPath%>/resources/profile/${sessionScope.loginuser.member_sign_filename}" alt="사인"> </div>
    <input type="file" name="sign_attach" class="img_file2" accept="image/*">
</div>
</form>      
<div class="form-group">
    <button type="button" id="mypage_edit">수정하기</button>
</div> 
 
<jsp:include page="../../footer/footer1.jsp" />    