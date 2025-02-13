<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%
String ctxPath = request.getContextPath();
//     /med-groupware
%>
<jsp:include page="../../header/header1.jsp" />

<style type="text/css">
div.subContent {
	border: solid 1px blue;
	width: 95%;
	margin: auto;
}

div.manag_h3 {
	border-bottom: solid 2px gray;
	margin: 30px;
}

div.mem_profile {
    border: solid 1px blue;
    width: 30%;
    padding: 15px;
    text-align: center;
}

div.mem_profile img {
    border-radius: 10px; /* 이미지 둥글게 */
    border: solid 1px gray;
}

div.mem_profile input[type="file"] {
    margin-top: 10px;
}

table.manag_table {
     border: solid 1px blue;
    width: 65%; /* 테이블이 더 넓게 차지하도록 설정 */
    border-collapse: collapse;
    flex-grow: 1; /* 가능한 공간 차지 */
}

table.manag_table th, table.manag_table td {
    border: solid 1px blue;
    padding: 10px;
    text-align: left;
}

table.manag_table th {
    background-color: #f4f4f4; /* 연한 배경 */
}

</style>

<script type="text/javascript">
    // 이미지 미리보기
    $(document).on("change", "input.img_file", function(e) {
        const inputFile = $(e.target).get(0);
        const file = inputFile.files[0];

        if (!file) { 
            $("#previewimg").attr("src", "");  // 파일 선택 취소 시 초기화
            return;
        }
        
        // 파일 타입 및 크기 검사
        const fileType = file.type;
        const fileSize = file.size / 1024 / 1024; // MB 단위
        if (!fileType.match("image/(jpeg|png|jpg)")) {
            alert("jpg 또는 png 형식의 이미지만 업로드 가능합니다.");
            $(this).val(""); // 입력값 초기화
            $("#previewimg").attr("src", ""); // 초기화
            return;
        }
        if (fileSize > 3) {
            alert("파일 크기는 3MB 이하로 업로드해야 합니다.");
            $(this).val(""); // 입력값 초기화
            $("#previewimg").attr("src", ""); // 초기화
            return;
        }
        
     // 이미지 미리보기 처리
        const fileReader = new FileReader();
        fileReader.onload = function(event) {
            $("#previewimg").attr("src", event.target.result);
        };
        fileReader.readAsDataURL(file);
    }); 
    

    	$(document).ready(function () {
    		
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
        	    
    	});
        	    
         $("button#registerbtn").click(function(){	
        	    
       	    	const name = $("#name").val().trim();
       	        const regExp_Name = /^[가-힣\s]{2,10}$/;
       	    	if (name === "" || !regExp_Name.test(name)) { // 이름이 공백이거나 정규식을 통과하지 못한 경우
       	    		$("#name").focus();
       	    		return;
       	        }	
       	    	if($("#email").val().trim()==""){
       				$("#email").focus();
       				return;	
	       		}
	       		if($("#hp2").val().trim()==""){
       				$("#hp2").focus();
       				return;	
	       		}
	       		if($("#hp3").val().trim()==""){
       				$("#hp3").focus();
       				return;	
	       		}	
        	    	
        	    const radio_checked_length = $("input:radio[name='gender']:checked").length;

        	    if (radio_checked_length == 0) {
        	        alert("성별을 선택하셔야 합니다.");
        	        return;
        	    }
        	    
        	    $("input#datepicker, input#start").blur((e) => {
        	        const dateValue = $(e.target).val().trim();
        	        if (!dateValue) {
        	            alert("올바른 날짜를 입력하세요.");
        	            $(e.target).val("").focus();
        	            return;
        	        }
        	        const parsedDate = new Date(dateValue);
        	        if (isNaN(parsedDate.getTime())) {
        	            alert("유효한 날짜 형식을 입력하세요.");
        	            $(e.target).val("").focus();
        	        }
        	    
	           // 폼(form)을 전송(submit)
		      const frm = document.memberFrm;
		      frm.method = "post";
		      frm.action = "<%= ctxPath%>/ManagementFrom/ManagementFrom";
		      frm.submit();
        	
        	    });
        
     		
       });
         
         
         $(document).ready(function(){
        	 
        	//하위부서 데이터값 불러오기
             $("select[name='parentDept']").change(function(){
                 const dept = $(this).val(); // 선택된 상위 부서 값
                 const childDeptSelect = $("select[name='childDept']");
                 
                 // 기존 옵션 초기화
                 childDeptSelect.empty();
                 childDeptSelect.append('<option value=""> 하위 부서 선택 </option>');

                 if (dept) { // 부서가 선택되었을 때만 AJAX 요청
                     $.ajax({
                         url: "${pageContext.request.contextPath}/management/childDeptJSON",
                         data: {"dept": dept},
                         dataType: "json",
                         success: function(json) {

                        	 json.forEach(function(item, index) {
                                 childDeptSelect.append('<option value="' + item.child_dept_no + '">' + item.child_dept_name + '</option>');
                             });
                         },
                         error: function(request, status, error) {
                             alert("code: " + request.status + "\nmessage: " + request.responseText + "\nerror: " + error);
                         }
                     });
                 }
             });
             
        	//직급 데이터값 불러오기
             $("select[name='parentDept']").change(function() {
                 const parentDept = $(this).val(); // 선택된 상위 부서 값
                 const positionSelect = $("select[name='position']"); // 직급 select

                 // 기존 옵션 초기화
                 positionSelect.empty();
                 positionSelect.append('<option value=""> 직급 선택 </option>');

                 // 특정 부서에 따라 직급 추가
                 if (parentDept == "1") {
                     positionSelect.append('<option value="1">전문의</option>');
                 } 
                 if (parentDept == "2") {
                     positionSelect.append('<option value="1">수간호사</option>');
                     positionSelect.append('<option value="2">평간호사</option>');
                 } 
                 if (parentDept == "3") {
                     positionSelect.append('<option value="1">병원장</option>');
                     positionSelect.append('<option value="2">부장</option>');
                     positionSelect.append('<option value="3">차장</option>');
                     positionSelect.append('<option value="4">과장</option>');
                     positionSelect.append('<option value="5">주임</option>');
                 } 
             });
         });

</script>

<div class="subContent">

	<div class="manag_h3">
		<h3>사원등록</h3>
	</div>
	

	<form name="memberFrm" enctype="multipart/form-data">
	
		<div class="mem_profile">
			<div><img id="previewimg" width="137" height="176" style="object-fit: cover;" /></div>
			<input type="file" name="attach" class="img_file"  accept="image/*"  />
		</div>
	
		<table class="manag_table">
		
		
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">성명</th>
				<td><input type="text" id="name" name="member_name" />
				<span class="error">성명은 필수입력 사항입니다.</span></td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">부문</th>
			<td>
		    <select name="parentDept">
		        <option value=""> 상위 부서 선택 </option>
		        <c:forEach var="pvo" items="${requestScope.parentDeptList}">
		            <option value="${pvo.parent_dept_no}">${pvo.parent_dept_name}</option>
		        </c:forEach>
		    </select>
		</td>
		
		<tr>
		    <th style="width: 15%; background-color: #DDDDDD;">부서</th>
		    <td>
		        <select name="childDept">
		            <option value=""> 하위 부서 선택 </option>
		        </select>
		    </td>
		</tr>

			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">직급</th>
			<td>
				<select name="position">
					<option value=""> 직급 선택 </option>
	            </select>
            </td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">이메일</th>
				<td><input type="text" name="member_email" id="email" size="25"/>
				 <span class="error">이메일 형식에 맞지 않습니다.</span></td>
			</tr>
			
			<tr>
			  <th style="width: 15%; background-color: #DDDDDD;">휴대전화</th>
			  <td><input type="text" name="hp1" id="hp1" size="6" maxlength="3" value="010" readonly/>&nbsp;-&nbsp; 
		      <input type="text" name="hp2" id="hp2" size="6" maxlength="4" class="requiredInfo" autocomplete="off" placeholder="1234"/>&nbsp;-&nbsp;
		      <input type="text" name="hp3" id="hp3" size="6" maxlength="4" class="requiredInfo" autocomplete="off" placeholder="5678"/> 
		         <span class="error" id="hp_error">전화번호를 정확하게 입력해 주세요.</span></td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;"><label class="labelName">성별</label></th>
				<td><input type="radio" name="gender" value="1" id="male" class="requiredInfo_radio" />
				<label for="male" style="margin-left: 1.5%;">남자</label> 
				<input type="radio" name="gender" value="2" id="female" class="requiredInfo_radio" style="margin-left: 10%;" />
				<label for="female" style="margin-left: 1.5%;">여자</label></td>
			</tr>

			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">생년월일</th>
				<td><input type="date" name="birthday" id="datepicker" maxlength="10" /></td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">입사일자</th>
				<td><input type="date" name="start_date" id="start"></td>
			</tr>

			<tr>
				<td colspan="2" class="text-center">
				<button type="button" id="registerbtn">사원 등록</button>
				</td>
			</tr>

		</table>
	</form>
</div>
<jsp:include page="../../footer/footer1.jsp" />    