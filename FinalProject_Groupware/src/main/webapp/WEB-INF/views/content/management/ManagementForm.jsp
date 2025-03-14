<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%
String ctxPath = request.getContextPath();
//     /med-groupware
%>
<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/management/managementForm.css" />
<jsp:include page="../../header/header1.jsp" />

<script type="text/javascript">
    // 이미지 미리보기
    $(document).on("change", "input.img_file", function(e) {
        const inputFile = $(e.target).get(0);
        const file = inputFile.files[0];

        if (!file) { 
            $("#previewimg").attr("src", "<%=ctxPath%>/resources/profile/default_profile.png");  // 파일 선택 취소 시 초기화
            return;
        }
        
        // 파일 타입 및 크기 검사
        const fileType = file.type;
        const fileSize = file.size / 1024 / 1024; // MB 단위
        if (!fileType.match("image/(jpeg|png|jpg)")) {
            alert("jpg 또는 png 형식의 이미지만 업로드 가능합니다.");
            $(this).val(""); // 입력값 초기화
            $("#previewimg").attr("src", "<%=ctxPath%>/resources/profile/default_profile.png"); // 초기화
            return;
        }
        if (fileSize > 3) {
            alert("파일 크기는 3MB 이하로 업로드해야 합니다.");
            $(this).val(""); // 입력값 초기화
            $("#previewimg").attr("src", "<%=ctxPath%>/resources/profile/default_profile.png"); // 초기화
            return;
        }
        
     // 이미지 미리보기 처리
        const fileReader = new FileReader();
        fileReader.onload = function(event) {
            $("#previewimg").attr("src", event.target.result);
        };
        fileReader.readAsDataURL(file);
    }); 
    
    $(document).ready(function(){
    	
    	//상위부서 데이터값 불러오기
    	const parentDeptSelect = $("select[name='parentDept']");

        // 기존 옵션 초기화
        parentDeptSelect.empty();
        parentDeptSelect.append('<option value=""> 상위 부서 선택 </option>');

    	 $.ajax({
               url: "${pageContext.request.contextPath}/management/parentDeptJSON",
               dataType: "json",
               success: function(json) {

              	 json.forEach(function(item, index) {
              			parentDeptSelect.append('<option value="' + item.parent_dept_no + '">' + item.parent_dept_name + '</option>');
                   });
               },
               error: function(request, status, error) {
                   alert("code: " + request.status + "\nmessage: " + request.responseText + "\nerror: " + error);
               }
           });
    	
    	
    	 //하위부서 데이터값 불러오기
         $("select[name='parentDept']").change(function(){
             const dept = $(this).val(); // 선택된 상위 부서 값
             const childDeptSelect = $("select[name='fk_child_dept_no']");
             
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
                             childDeptSelect.append('<option value="' + item.fk_child_dept_no + '">' + item.child_dept_name + '</option>');
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
             const positionSelect = $("select[name='member_position']"); // 직급 select

             // 기존 옵션 초기화
             positionSelect.empty();
             positionSelect.append('<option value=""> 직급 선택 </option>');

             // 특정 부서에 따라 직급 추가
             if (parentDept == "1") {
                 positionSelect.append('<option value="전문의">전문의</option>');
             } 
             if (parentDept == "2") {
                 positionSelect.append('<option value="수간호사">수간호사</option>');
                 positionSelect.append('<option value="평간호사">평간호사</option>');
             } 
             if (parentDept == "3") {
                 positionSelect.append('<option value="병원장">병원장</option>');
                 positionSelect.append('<option value="부장">부장</option>');
                 positionSelect.append('<option value="차장">차장</option>');
                 positionSelect.append('<option value="과장">과장</option>');
                 positionSelect.append('<option value="주임">주임</option>');
             } 
         });
    	
         let member_yeoncha;
 	     let member_grade;
    	
         $("select[name='member_position']").change(function() {
        	    const selectedPosition = $(this).val(); // 선택된 직급 값
        	    const parentDept = $("select[name='parentDept']").val(); // 선택된 부서 값

        	    // 연차, 등급 설정
        	    if ((parentDept == "3" && (selectedPosition == "병원장"))) {
        	        member_yeoncha = 20;
        	        member_grade = 1;
        	    } else  if 
        	    ((parentDept == "3" && (selectedPosition == "부장")) || (parentDept == "1" && (selectedPosition == "전문의"))) {
        	        member_yeoncha = 18;
        	        member_grade = 2;
        	    } else  if 
        	    ((parentDept == "3" && (selectedPosition == "차장")) || (parentDept == "2" && (selectedPosition == "수간호사"))) {
        	        member_yeoncha = 17;
        	        member_grade = 3;
        	    }  else  if 
        	    ((parentDept == "3" && (selectedPosition == "과장")) ) {
        	        member_yeoncha = 15;
        	        member_grade = 4;
        	    } else{
        	    	member_yeoncha = 15;
        	        member_grade = 5;
        	    }

        	   // console.log("연차:", member_yeoncha, "등급:", member_grade);
        	    
        	  
        	});
    		
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
        	    
  
        	    
    	    $("button#registerbtn").click(function () {
    	        
    	        const name = $("#member_name").val().trim();
    	        const regExp_Name = /^[가-힣\s]{2,10}$/;
    	        if (name === "" || !regExp_Name.test(name)) {
    	            alert("이름을 올바르게 입력하세요.");
    	            $("#name").focus();
    	            return;
    	        }

    	        const parentDept = $("select[name='parentDept']").val();
    	        if (parentDept == "") {
    	            alert("상위 부서를 선택하세요.");
    	            return;
    	        }

    	        const childDept = $("select[name='fk_child_dept_no']").val();
    	        if (childDept == "") {
    	            alert("하위 부서를 선택하세요.");
    	            return;
    	        }

    	        const position = $("select[name='member_position']").val();
    	        if (position == "") {
    	            alert("직급을 선택하세요.");
    	            return;
    	        }

    	        if ($("#member_email").val().trim() == "") {
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

    	        if ($("input:radio[name='member_gender']:checked").length == 0) {
    	            alert("성별을 선택하셔야 합니다.");
    	            return;
    	        }

    	        const birthday = $("input#member_birthday").val().trim();

    	        if (birthday == "") {
    	            alert("생년월일을 입력하셔야 합니다.");
    	            return;
    	        }
    	       
    	        if (isNaN(new Date(birthday).getTime())) {
    	            alert("올바른 생년월일을 입력하세요.");
    	            $("#member_birthday").focus();
    	            return;
    	        }
    	        
    	        const startDate = $("#member_start").val().trim();
    	        if (!startDate) {
    	            alert("입사일을 입력하세요.");
    	            $("#member_start").focus();
    	            return;
    	        }
    	        if (isNaN(new Date(startDate).getTime())) {
    	            alert("올바른 입사일을 입력하세요.");
    	            $("#member_start").focus();
    	            return;
    	        }
    	        
    	        const member_mobile = $('#hp1').val() + '-' + $('#hp2').val() + '-' + $('#hp3').val();
    	        const member_workingTime = "day";

    	        const frm = document.ManagementFrom;
    	        $('#member_mobile').val(member_mobile); 
    	        $('#member_yeoncha').val(member_yeoncha); 
    	        $('#member_grade').val(member_grade); 
    	        $('#member_workingTime').val(member_workingTime); 

    	        frm.method = "post";
    	        frm.action = "<%= ctxPath%>/management/ManagementForm";
    	        frm.submit();

    	    });
    	});

</script>

<div id="sub_mycontent">

	<div class="manag_h3">
		<h3>인사관리 <사원등록> </h3>
	</div>
	

	<form name="ManagementFrom" enctype="multipart/form-data">
	 <div class="form-container">
		<div class="mem_profile">
			<div><img id="previewimg" src="<%=ctxPath%>/resources/profile/default_profile.png" style="object-fit: cover;" /></div>
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
			    </select>
			</td>
		
			<tr>
			    <th style="width: 15%; background-color: #DDDDDD;">부서</th>
			    <td>
			        <select name="fk_child_dept_no">
			            <option value=""> 하위 부서 선택 </option>
			        </select>
			    </td>
			</tr>

			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">직급</th>
			<td>
				<select name="member_position">
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
				<td><input type="radio" name="member_gender" value="남" id="male" class="requiredInfo_radio" />
				<label for="male" style="margin-left: 1.5%;">남자</label> 
				<input type="radio" name="member_gender" value="여" id="female" class="requiredInfo_radio" style="margin-left: 10%;" />
				<label for="female" style="margin-left: 1.5%;">여자</label></td>
			</tr>

			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">생년월일</th>
				<td> <input type="date" name="member_birthday" id="member_birthday" maxlength="10" />
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">입사일자</th>
				<td><input type="date" name="member_start" id="member_start"></td>
			</tr>

			<tr>
				<td colspan="2" class="text-center">
				<button type="button" class="member_button" id="registerbtn">사원 등록</button>
				</td>
			</tr>
	
		</table>
					<input type="hidden" id="member_mobile" name="member_mobile" />
					
					<input type="hidden" id="member_yeoncha" name="member_yeoncha" />
					
					<input type="hidden" id="member_grade" name="member_grade" />
					
					<input type="hidden" id="member_workingTime" name="member_workingTime" />
		</div>
	</form>
</div>

<jsp:include page="../../footer/footer1.jsp" />    