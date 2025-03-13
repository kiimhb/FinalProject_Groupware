<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
//     /med-groupware
%>
<jsp:include page="../../header/header1.jsp" />

<style type="text/css">
div.mypage_container {
	/* border: solid 1px gray; */
    margin: auto;
}

div.mypage_container > form {
	/* border: solid 1px gray; */
	margin: auto;
	border-collapse: collapse;
}

img#previewimg1, img#previewimg2{
     border: solid 1px gray;
     width:137px;
     height:176px;
     float: left;
}

div.mypage_container > form > table > tbody > tr > th {
	width: 15%;
	background-color: #DDDDDD;
	padding: 10px;
}

div.mypage_container > form > table th, table td {
    padding: 10px;
    text-align: left;
    border: solid 1px gray;
}

div.mypage_container > form > table > tbody > tr > td{
	border-bottom: solid 1px gray;
}

button#mypage_edit {
    padding: 12px;
    border: none;
    border-radius: 5px;
    font-size: 18px;
    cursor: pointer;
    background-color: #b3d6d2;
}

input[readonly] {
	background-color: #f2f2f2;
	border:none;
  	color: #b3b3b3;
  	cursor: not-allowed;
}

#mycontent > div > form > table > tbody > tr.form-group > td{
 border: none;
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
$(document).ready(function(){
$("span.error").hide();

$("input#hp2").on("input", function (e) {
	
    const regExp_hp2 = /^[1-9][0-9]{3}$/; 

    const hp2Value = $(e.target).val(); // hp2 입력값 가져오기
    const bool = regExp_hp2.test(hp2Value); // 정규표현식 검사

    if (!bool) { // hp2 값이 정규표현식에 맞지 않는 경우
        $("#hp_error").text("전화번호 중간 자리를 정확하게 입력해 주세요.").show();
        return;
    }

    // hp3 값이 비어 있는지 확인
    const hp3Value = $("input#hp3").val(); // hp3 입력값 가져오기
    if (hp3Value === "") {
        $("#hp_error").text("전화번호 마지막 자리를 입력해주세요.").show();
		$("input#hp3").focus();
        return;
    }

    // hp3 값의 길이가 4자리인지 확인
    if (hp3Value.length !== 4) {
        $("#hp_error").text("전화번호 마지막 자리는 정확히 4자리여야 합니다.").show();
		$("input#hp3").focus();
        return;
    }

    // hp3 값이 숫자 4자리인지 확인
    const regExp_hp3 = /^[1-9][0-9]{3}$/; // 첫 번째 숫자는 1-9, 나머지는 0-9로 이루어진 4자리 숫자
    if (!regExp_hp3.test(hp3Value)) {
        $("#hp_error").text("전화번호 마지막 자리는 4자리 숫자여야 합니다.").show();
        return;
    }

    // 모든 조건을 만족한 경우
    $("#hp_error").hide();
});

$("input#hp2").on("input", (e) => {
   const input = $(e.target);
   const sanitizedValue = input.val().replace(/[^0-9]/g, ""); // 숫자가 아닌 문자를 제거
   input.val(sanitizedValue); // 필드에 정제된 값 설정
});
$("input#hp3").on("input", (e) => {
const input = $(e.target);
const sanitizedValue = input.val().replace(/[^0-9]/g, ""); // 숫자가 아닌 문자를 제거
input.val(sanitizedValue); // 필드에 정제된 값 설정
});
$("button#mypage_edit").click(function() {
	const member_pwd = $("input:password[id='member_pwd']").val().trim();
	const member_pwd2 = $("input:password[id='member_pwd2']").val().trim();
	
	if (member_pwd != member_pwd2) {
		alert("암호가 일치하지 않습니다.");
		$("input:password[id='member_pwd']").val("");  
		$("input:password[id='member_pwd2']").val("");
		return;
	}
	
	const regExpPwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/;
	
	if (!regExpPwd.test(member_pwd)) {
		alert("암호는 8글자 이상 15글자 이하에 영문자, 숫자, 특수기호가 혼합되어야만 합니다.");
		$("input:password[id='member_pwd']").val("").focus();
		$("input:password[id='member_pwd2']").val("").focus();
		return;
	}

    const name = $("input#member_name").val().trim();
    const regExp_Name = /^[가-힣\s]{2,10}$/;
    if (name === "" || !regExp_Name.test(name)) {
        alert("이름을 올바르게 입력하세요.");
        $("#member_name").focus();
        return;
    }

    if ($("input#member_email").val().trim() == "") {
        alert("이메일을 입력하세요.");
        $("#email").focus();
        return;
    }
    if ($("input#hp2").val().trim() == "") {
        alert("전화번호 중간 자리를 입력하세요.");
        $("input#hp2").focus();
        return;
    } else {
        $('#hp_error').hide();  
    }
    if ($("input#hp3").val().trim() == "") {
        alert("전화번호 마지막 자리를 입력하세요.");
        $("input#hp3").focus();
        return;
    } else {
        $('input#hp_error').hide();  
    }
    
    const member_mobile = $('#hp1').val() + '-' + $('#hp2').val() + '-' + $('#hp3').val();

    const frm = document.mypageEdit;
    $('#member_mobile').val(member_mobile); 
    
   /*  console.log(frm); */
    
    frm.method = "post";
    frm.action = "<%= ctxPath%>/mypage/mypageEdit";
    frm.submit();
});
});
</script>

<div class="mypage_container">
	<form name="mypageEdit" enctype="multipart/form-data">
    <table>
        <tr>
            <th>프로필</th>
            <td colspan="2" class="text-center">
            <div style="display: flex; align-items: center; gap: 20px;">
                <img id="previewimg1" width="137" height="176" src="<%=ctxPath%>/resources/profile/${sessionScope.loginuser.member_pro_filename}" alt="프로필">
                <input type="file" name="attach" class="img_file1" accept="image/*">
                </div>
            </td>
        </tr>
        <tr>
            <th>사번</th>
            <td><input type="text" name="member_userid" id="member_userid" value="${sessionScope.loginuser.member_userid}" readonly /></td>
        </tr>
        <tr>
            <th>암호</th>
            <td><input type="password" id="member_pwd" name="member_pwd" size="25" /></td>
        </tr>
        <tr>
            <th>새암호확인</th>
            <td><input type="password" id="member_pwd2" name="member_pwd2" size="25" /></td>
        </tr>
        <tr>
            <th>하위부서</th>
            <td><input type="text" name="child_dept_name" id="child_dept_name" value="${sessionScope.loginuser.child_dept_name}" readonly /></td>
        </tr>
        <tr>
            <th>직급</th>
            <td><input type="text" name="member_position" id="member_position" value="${sessionScope.loginuser.member_position}" readonly /></td>
        </tr>
        <tr>
            <th>이름</th>
            <td><input type="text" name="member_name" id="member_name" value="${sessionScope.loginuser.member_name}" /></td>
        </tr>
        <tr>
            <th>휴대전화</th>
            <td>
                <input type="text" name="hp1" id="hp1" maxlength="3" size="6" value="010" readonly /> -
                <input type="text" name="hp2" id="hp2" maxlength="4" size="6" value="${sessionScope.loginuser.member_mobile.substring(4,8)}" /> -
                <input type="text" name="hp3" id="hp3" maxlength="4" size="6" value="${sessionScope.loginuser.member_mobile.substring(9)}" />
           		<span class="error" id="hp_error">전화번호를 정확하게 입력해 주세요.</span>
            </td>
        </tr>
        <tr>
            <th>이메일</th>
            <td><input type="text" name="member_email" id="member_email" value="${sessionScope.loginuser.member_email}" /></td>
        </tr>
        <tr>
            <th>생년월일</th>
            <td><input type="date" name="member_birthday" id="member_birthday" value="${sessionScope.loginuser.member_birthday}" readonly /></td>
        </tr>
        <tr>
            <th>성별</th>
            <td><input type="text" name="member_gender" value="${sessionScope.loginuser.member_grade == '남' ? '남자' : '여자'}" readonly /></td>
        </tr>
        <tr>
            <th>근무시간</th>
            <td><input type="text" name="member_workingTime" id="member_workingTime" value="${sessionScope.loginuser.member_workingTime}" readonly /></td>
        </tr>
        <tr>
            <th>사인이미지</th>
            <td colspan="2" class="text-center">
                <div style="display: flex; align-items: center; gap: 20px;">
                    <img id="previewimg2" width="137" height="176" src="<%=ctxPath%>/resources/sign/${sessionScope.loginuser.member_sign_filename}" alt="사인">
                    <input type="file" name="sign_attach" class="img_file2" accept="image/*">
                </div>
             </td>
        </tr>
			<tr class="form-group">
				<td colspan="2" class="text-center">
					<button type="button" id="mypage_edit">수정하기</button>
				</td>
			</tr>
		</table>
		
		<input type="hidden" id="member_mobile" name="member_mobile" />
		
		<input type="hidden" id="member_pro_orgfilename" name="member_pro_orgfilename" value="${sessionScope.loginuser.member_pro_orgfilename}" />
      	<input type="hidden" id="member_pro_filename" name="member_pro_filename" value="${sessionScope.loginuser.member_pro_filename}" />
      	<input type="hidden" id="member_pro_filesize" name="member_pro_filesize" value="${sessionScope.loginuser.member_pro_filesize}" />
      	
      	<input type="hidden" id="member_sign_orgfilename" name="member_sign_orgfilename" value="${sessionScope.loginuser.member_sign_orgfilename}" />
      	<input type="hidden" id="member_sign_filename" name="member_sign_filename" value="${sessionScope.loginuser.member_sign_filename}" />
      	<input type="hidden" id="member_sign_filesize" name="member_sign_filesize" value="${sessionScope.loginuser.member_sign_filesize}" />
      	
      	
</form>


	
</div>
<jsp:include page="../../footer/footer1.jsp" />    