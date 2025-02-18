<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>

<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>

<script type="text/javascript">

$(document).ready(function(){
	
<%-- 모달 껐다 키기--%>	
	const regNewModalOpen = document.getElementById('regNewModalOpen');
	const regExistModalOpen = document.getElementById('regExistModalOpen');
	const regNewModalClose = document.getElementById('regNewModalClose');
	const regExistModalClose = document.getElementById('regExistModalClose');
	const modal1 = document.getElementById('modalContainer');
	const modal2 = document.getElementById('modalContainer2');

	
	regNewModalOpen.addEventListener('click', () => {
		modal1.classList.remove('hidden');
	});
	
	regExistModalOpen.addEventListener('click', () => {
		modal2.classList.remove('hidden');
	});

	regNewModalClose.addEventListener('click', () => {
		modal1.classList.add('hidden');
	});
	
	regExistModalClose.addEventListener('click', () => {
		modal2.classList.add('hidden');
	});
	
	
	
	
	
<%-- === 검색어 입력시 자동글 완성하기 2 === --%>
	   $("div#displayList").hide();
	   
	   $("input[name='searchWord']").keyup(function(){
		  
		   const wordLength = $(this).val().trim().length;
		   // 검색어에서 공백을 제거한 길이를 알아온다.
		   
		   if(wordLength == 0) {
			   $("div#displayList").hide();
			   // 검색어가 공백이거나 검색어 입력후 백스페이스키를 눌러서 검색어를 모두 지우면 검색된 내용이 안 나오도록 해야 한다. 
		   }
		   
		   else {
			   
			   if( $("select[name='searchType']").val() == "patient_jubun") {
				
				   $.ajax({
					   url:"<%= ctxPath%>/patient/wordSearchShow",
					   type:"get",
					   data:{"searchType":$("select[name='searchType']").val()
						    ,"searchWord":$("input[name='searchWord']").val()},
					   dataType:"json",
					   success:function(json){
							console.log(JSON.stringify(json));

						   
						   <%-- === #93. 검색어 입력시 자동글 완성하기 7 === --%>
						   if(json.length > 0){
							   // 검색된 데이터가 있는 경우임.
							   
							   let v_html = ``;
							   
							   $.each(json, function(index, item){
								   const word = item.word;
								   
							   // word.toLowerCase() 은 word 를 모두 소문자로 변경하는 것이다.
							   /*     java가 쉽나요?
								      java공부를 하려고 해요. 도와주세요~~
								      프로그래밍은 java 를 해야 하나요?
								      javascript 는 쉬운가요?
								      프론트 엔드를 하려면 javascript 를 해야 하나요?
								      질문있어요 jquery 와 javascript 는 관련이 있나요?		  
							   */ 
								   
							       const idx = word.toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase());
								   // 만약에 검색어가 JavA 이라면
								   
							   
							       const len = $("input[name='searchWord']").val().length; 
								   // 검색어(JavA)의 길이 len 은 4 가 된다. 
							   /*	   
							       console.log("~~~~ 시작 ~~~~");
								   console.log(word.substring(0, idx));       // 검색어(JavA) 앞까지의 글자      ==> 프로그래밍은 
								   console.log(word.substring(idx, idx+len)); // 검색어(JavA) 글자             ==> Java
								   console.log(word.substring(idx+len));      // 검색어(JavA) 뒤부터 끝까지 글자  ==>  를 해야 하나요?  
							       console.log("~~~~ 끝 ~~~~");
							   */
							       
							       const result = word.substring(0, idx) + "<span style='font-weight:bold;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len); 
							       
								   v_html += `<span style='cursor:pointer;' class='result'>\${result}</span><br>`;
								   
							   }); // end of $.each(json, function(index, item){})-----------
							   
							   const input_width = $("input[name='searchWord']").css("width"); // 검색어 input 태그 width 값 알아오기  
							   
							   $("div#displayList").css({"width":input_width}); // 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
							   
							   $("div#displayList").html(v_html).show();
						   }
					   },
					   error: function(request, status, error){
						   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					   }    
				   });
				   
			   }
		   }
	   });// end of $("input[name='searchWord']").keyup(function(){})--------
	   
	   
	   <%-- === #94. 검색어 입력시 자동글 완성하기 8 === --%>
	   $(document).on("click", "span.result", function(e){
		   const word = $(e.target).text();
		   $("input[name='searchWord']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다.
		   $("div#displayList").hide();
		   <%-- goSearch(); --%>
	   });
	
	<%-- 주민번호 검색해서 회원 정보 보여주기--%>
	$("button[name='goShow']").click(function(){
		$("div#displayList").hide();
		if($("input[name='searchWord']").val() !=""){
					
			$.ajax({
				
				url:"<%= ctxPath%>/patient/existPatientShow",
				data:{"searchWord":$("input[name='searchWord']").val()},
				dataType:"json",
				success:function(json){						
					console.log(JSON.stringify(json));
					
					v_html = ``;
					
					$.each(json, function(index, item){
						
						v_html += `	<tr>
										<td>\${item.patient_name}</td>
										<td>\${item.patient_gender}</td>
										<td>\${item.patient_jubun}</td>
										<td>\${item.child_dept_name}</td>
									</tr>
						`;
												
					$("tbody#searchShow").html(v_html);
					
					
					
					
					})
					
						

				},
				error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
		
		} // end of if($("input[name='searchWord']").val() !=""){
	});	
	
});


</script>

<style>


#modalContainer {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContent {
  position: absolute;
  background-color: #ffffff;
  width: 900px;
  height: 550px;
  padding: 20px;
  border-radius: 20px;
}

#modalContainer.hidden {
  display: none;
}
#modalContainer {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContainer.hidden {
  display: none;
}


#modalContainer2 {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContent2 {
  position: absolute;
  background-color: #ffffff;
  width: 900px;
  height: 550px;
  padding: 20px;
  border-radius: 20px;
}

#modalContainer2.hidden {
  display: none;
}
#modalContainer2 {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContainer2.hidden {
  display: none;
}


</style>


<jsp:include page="../../header/header1.jsp" />


<div style="font-size:15pt; text-align:center; border:solid 1px red; margin: 1% 10%; background-color:#b3d6d2;"><span>환자 등록</span></div>

<div id="container">


	<div id="patinetRegSelectBoxes" class="row justify-content-around" style="margin:12% 10%;">
	
		<div class="col-3" style="background-color:#b3d6d2; text-align:center; line-height:300px; border:solid 1px black; border-radius:20px; height:300px;">
			<a style="cursor: pointer;" data-toggle="modal" data-target="#patientRegNew" data-dismiss="modal"><span id="regNewModalOpen" style="font-size:15pt">신규환자 등록</span></a>
		</div>

		<div class="col-3" style="background-color:#b3d6d2; text-align:center; line-height:300px; border:solid 1px black; border-radius:20px; height:300px;">
			<a style="cursor: pointer;" data-toggle="modal" data-target="#patientRegRe" data-dismiss="modal"><span id="regExistModalOpen" style="font-size:15pt">기존환자 조회 및 접수</span></a>
		</div>		
	</div>	
</div>




<!-- 신규환자 등록 모달 -->
<div id="modalContainer" class="hidden" >
	  <div id="modalContent">
	  <div style="font-size:15pt; text-align:center; border:solid 1px red; margin: 1% 5%; background-color:#b3d6d2;"><span>신규환자 등록</span></div>


<div style="border:solid 1px blue; ">
	<form name="registerFrm">	
		<div style="margin:1% 5%; border: solid 1px green">
			<table id="tblMemberRegister" class="w-100">				
					<tbody>
						<tr>
							<td>
								<span>접수 일자</span>
							</td>
							<td>
								<span>sysdate</span>
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
								<textarea style="width:615px; height:150px; resize:none;"></textarea>
							</td>						
						</tr>
					</tbody>
				</table>
				<div class="row justify-content-around mt-3">						
					<input type="button" class="btn btn-outline-success btn-lg col-3" value="등록 및 접수" onclick="patientRegNcheck()" />
					<input type="button" class="btn btn-outline-danger btn-lg col-3" value="등록 취소" id="regNewModalClose" />												
				</div>

		</div>

	</form>

</div>	
</div>
</div>



<!-- 기존환자 등록 및 접수 모달 -->
<div id="modalContainer2" class="hidden" >
	<div id="modalContent2">
	  <div style=" border-radius: 10px; font-size:15pt; text-align:center; border:solid 1px red; margin: 1% 5%; background-color:#b3d6d2;"><span>기존환자 등록 및 접수</span></div>

			<div style="border:solid 1px blue; ">
				<form name="patientSearchFrm">	
					<div style="margin:1% 5%; border: solid 1px green">												
							<div id ="patientSearch" style="margin: auto; text-align:center;">
								<select name="searchType" class = "text-center" style="width: 20%; height:7%">
									<option value="patient_jubun">주민번호로 검색</option>		
								</select>
								<input type="text" placeholder="입력란" name="searchWord" style="width: 68.5%;height:7%"></input>
								<input type="text" style="display: none;" />
								<button type="button" class="btn btn-outline-dark" style="width: 10%; height:7%" name="goShow"><i class="fa fa-search"></i></button>				
							</div>
							<div id="displayList" style="background-color:white; position:absolute;z-index: 3; border:solid 1px gray; border-top:0px; height:100px; margin-left:17.8%; margin-top:-1px; margin-bottom:30px; overflow:auto;">
							</div>
					</div>
				</form>	
				
							
				<div style="margin:1% 5%;">
					<table style="width:100%; text-align:center;">
						<thead>
							<tr>
								<th style="border:solid 1px black;">성함</th>
								<th style="border:solid 1px black;">성별</th>
								<th style="border:solid 1px black;">주민번호</th>
								<th style="border:solid 1px black;">진료구분</t>														
							</tr>	
						</thead>	
						<tbody id="searchShow" style="position:relative;"></tbody>									
					</table>								
				</div> 
							 

							<div style="position:relative; z-index: 2;" class="row justify-content-around mt-3">						
								<input type="button" class="btn btn-outline-success btn-lg col-3" value="등록 및 접수" onclick="patientRegNcheck()" />
								<input type="button" class="btn btn-outline-danger btn-lg col-3" value="등록 취소" id="regExistModalClose" />												
							</div>
			
					</div>
				
			</div>	
</div>


















<jsp:include page="../../footer/footer1.jsp" /> 