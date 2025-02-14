<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>



<jsp:include page="../../header/header1.jsp" />


<div style="font-size:15pt; text-align:center; border:solid 1px red; margin: 1% 10%; background-color:#b3d6d2;"><span>환자 등록</span></div>


<div style="border:solid 1px blue; ">
	<form name="registerFrm">	
		<div style="margin:1% 10%; border: solid 1px green">
			<table id="tblMemberRegister" class="w-100">
				
					<tbody>
						<tr>
							<td>
								<span>접수 일자</span>
							</td>
							<td>
								<span>sysdate 뷰딴갈아엎을예정</span>
							</td>
						</tr>
						<tr>
							<td>
								<span>성명</span>
							</td>
							<td style="height: 50px;"> <!-- vertical-align:top; -->
								<input type="text" name="name" id="name" maxlength="30" class="requiredInfo info" placeholder="성명" /><br>
								<span id="nameError" class="error"></span>					
							</td>
						</tr>

						<tr>
							<td>
								<span>주민번호</span>
							</td>
							<td style="height: 50px; "> <!-- vertical-align:top; -->
								<input type="text" name="jubun" id="jubun" maxlength="20" class="requiredInfo info" placeholder="주민번호" /><br>
								<span id="jubunError" class="error"></span>
							</td>
						</tr>


						<tr>
							<td>
								<span>성별</span>
							</td>
							<td style="height: 60px;">
								<label for="male" style="margin-right: 10px; margin-left: 10px; font-size: 20px;">남자</label>
								<input type="radio" name="gender" value="남" id="male" />
								<label for="female" style="margin-right: 10px; margin-left: 40px; font-size: 20px;">여자</label>
								<input type="radio" name="gender" value="여" id="female" /><br>
								<span class="error"></span>
							</td>
						</tr>
						
						<tr>
							<td>
								<span>증상</span>
							</td>
							<td>
								<textarea style="width:300px; height:150px; resize:none;"></textarea>
							</td>
						
						
						</tr>

						<tr>
							<td>
								<span class="star text-danger"></span>
							</td>
							<td class="text-center" style="height: 70px;">
								<input type="button" class="btn btn-outline-success btn-lg mr-5" value="환자 등록" onclick="patientReg()" />
								<input type="button" class="btn btn-outline-success btn-lg mr-5" value="등록 및 접수" onclick="patientRegNcheck()" />
								<input type="button" class="btn btn-outline-danger btn-lg" value="등록 취소" onclick="patientRegCancel()" />
							</td>
						</tr> 

					</tbody>
				</table>

		</div>
	

	
	</form>

</div>








<jsp:include page="../../footer/footer1.jsp" /> 