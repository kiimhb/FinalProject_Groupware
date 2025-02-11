<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../../header/header1.jsp" />

<style type="text/css">
div.subContent {
	border: solid 1px blue;
	width: 95%;
	margin: auto;
	margin-top: 2%;
}

div.manag_h3 {
	border-bottom: solid 2px gray;
	margin: 30px;
}


</style>

<script type="text/javascript">
    // 이미지 미리보기
    $(document).on("change", "input.img_file", function(e) {
        const inputFile = $(e.target).get(0);
        const file = inputFile.files[0];
     // 이미지 미리보기 처리
        const fileReader = new FileReader();
        fileReader.onload = function(event) {
            $("#previewimg").attr("src", event.target.result);
        };
        fileReader.readAsDataURL(file);
    });
</script>

<div class="subContent">

	<div class="manag_h3">
		<h3>사원등록</h3>
	</div>

	<form name="memberFrm" enctype="multipart/form-data">
		<table class="table table-bordered manag_table">
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">성명</th>
				<td><input type="text" name="member_name"></td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">부문</th>
			<td>
				<select>
	               <c:forEach var="cvo" items="${requestScope.categoryList}">
                        <option value="${cvo.cnum}">${cvo.cname}</option>
                  </c:forEach>  
	            </select>
            </td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">부서</th>
			<td>
				<select>
	                <c:forEach var="cvo" items="${requestScope.categoryList}">
                        <option value="${cvo.cnum}">${cvo.cname}</option>
                  </c:forEach>  
	            </select>
            </td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">이메일</th>
				<td><input type="text" name="member_email" id="email"size="25"/></td>
			</tr>
			
			<tr>
			  <th style="width: 15%; background-color: #DDDDDD;">휴대전화</th>
			  <td><input type="text" name="hp1" id="hp1" size="6" maxlength="3" value="010" readonly/>&nbsp;-&nbsp; 
		      <input type="text" name="hp2" id="hp2" size="6" maxlength="4" class="requiredInfo" autocomplete="off" placeholder="1234"/>&nbsp;-&nbsp;
		      <input type="text" name="hp3" id="hp3" size="6" maxlength="4" class="requiredInfo" autocomplete="off" placeholder="5678"/> </td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;"><label
					class="labelName">성별</label></th>
				<td><input type="radio" name="gender" value="1" id="male"
					class="requiredInfo_radio" /><label for="male"
					style="margin-left: 1.5%;">남자</label> <input type="radio"
					name="gender" value="2" id="female" class="requiredInfo_radio"
					style="margin-left: 10%;" /><label for="female"
					style="margin-left: 1.5%;">여자</label></td>
			</tr>

			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">생년월일</th>
				<td><input type="date" name="birth_date" required></td>
			</tr>
			
			<tr>
				<th style="width: 15%; background-color: #DDDDDD;">입사일자</th>
				<td><input type="date" name="birth_date" required></td>
			</tr>

		</table>
	</form>
</div>
<jsp:include page="../../footer/footer1.jsp" />    