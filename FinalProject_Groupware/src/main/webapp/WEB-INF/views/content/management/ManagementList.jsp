<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%
String ctxPath = request.getContextPath();
//     /med-groupware
%>
<jsp:include page="../../header/header1.jsp" />
<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/management/managementList.css" />

<script type="text/javascript">

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//===검색기능 js===//
$(document).ready(function(){
	   $("input:text[name='searchWord']").bind("keyup", function(e){
		   if(e.keyCode == 13){ // 엔터를 했을 경우
			   goSearch();
		   }
	   });
	   
	   // 검색시 검색조건 및 검색어 값 유지시키기
	   if(${not empty requestScope.paraMap}) {
		   $("select[name='searchType']").val("${requestScope.paraMap.searchType}");
		   $("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
	   }
	   
 	   $("div#displayList").hide();
	   
	   $("input[name='searchWord']").keyup(function(){
		  
		   const wordLength = $(this).val().trim().length;
		   // 검색어에서 공백을 제거한 길이를 알아온다.
		   
		   if(wordLength == 0) {
			   $("div#displayList").hide();
			   // 검색어가 공백이거나 검색어 입력후 백스페이스키를 눌러서 검색어를 모두 지우면 검색된 내용이 안 나오도록 해야 한다. 
		   }
		   
		   else {
			   
			   if( $("select[name='searchType']").val() == "userid" || 
			       $("select[name='searchType']").val() == "position" ||
			       $("select[name='searchType']").val() == "name" ) {
				
				   $.ajax({
					   url:"<%= ctxPath%>/management/wordSearchShow",
					   type:"get",
					   data:{"searchType":$("select[name='searchType']").val()
						    ,"searchWord":$("input[name='searchWord']").val()},
					   dataType:"json",
					   success:function(json){
						 //console.log(JSON.stringify(json));
						  
						   <%-- === #93. 검색어 입력시 자동글 완성하기 7 === --%>
						   if(json.length > 0){
							   // 검색된 데이터가 있는 경우임.
							   
							   let v_html = ``;
							   
							   $.each(json, function(index, item){
								   const word = item.word;
								   
							       const idx = word.toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase());
							   
							       const len = $("input[name='searchWord']").val().length; 
								   
							       const result = word.substring(0, idx) + "<span style='color:purple;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len); 
							       
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
	   
	   
	$(document).on("click", "span.result", function(e){
		 const word = $(e.target).text();
		 $("input[name='searchWord']").val(word); 
		 $("div#displayList").hide();
		 goSearch();
	});   
});// end of $(document).ready(function(){})-------------------------------	   
function goSearch() {
	 const frm = document.searchFrm;
	 frm.submit();
}// end of function goSearch()-----------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
//===사원수정기능 js===//
function goEdit(member_userid) {

    $.ajax({
        url: "<%= ctxPath%>/management/managementone",
        data: { "member_userid": member_userid },
        type: "post",
        dataType: "json",
        success: function(json) {

            // 모달을 띄울 위치
            const EditModal_container = $("div#EditModal");

            // 모달 HTML 생성 (json 사용)
            const modal_popup = `
            	<div class="modal fade" id="EditView" aria-labelledby="EditViewLabel" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="EditViewLabel">사원 정보 수정</h5>
                        </div>
                        <div class="modal-body">
                            <form name="Managementedt" enctype="multipart/form-data">
                                
                                <div class="form-container">
                                    <div class="profile-section">
                                        <img id="previewimg"  width="137" height="176" src="<%=ctxPath%>/resources/profile/\${json.member_pro_filename}" alt="프로필">
                                        <input type="file" name="attach" class="img_file" accept="image/*">
                                    </div>

                                    <!-- 오른쪽: 입력 필드 -->
                                    <div class="form-section">
                                        <div class="input-group">
                                            <label>사번</label>
                                            <input type="text" name="member_userid" id="member_userid" value="\${json.member_userid}" readonly />
                                        </div>

                                        <div class="input-group">
                                            <label>성명</label>
                                            <input type="text" name="member_name" id="member_name" value="\${json.member_name}" />
                                        </div>

                                        <div class="input-group">
                                            <label>상위부서</label>
                                            <select name="parentDept" id="parentDeptSelect">
                                                <option value="\${json.parent_dept_no}">\${json.parent_dept_name}</option>
                                            </select>
                                        </div>

                                        <div class="input-group">
                                            <label>하위부서</label>
                                            <select name="fk_child_dept_no">
                                                <option value="\${json.child_dept_no}">\${json.child_dept_name}</option>
                                            </select>
                                        </div>

                                        <div class="input-group">
                                            <label>직급</label>
                                            <select name="member_position">
                                                <option value="\${json.member_position}">\${json.member_position}</option>
                                            </select>
                                        </div>

                                        <div class="input-group">
                                            <label>전화번호</label>
                                            <div class="phone-group">
                                                <input type="text" name="hp1" id="hp1" maxlength="3" value="010" readonly />
                                                <span>-</span>
                                                <input type="text" name="hp2" id="hp2" maxlength="4" value="\${json.member_mobile.substring(4,8)}" />
                                                <span>-</span>
                                                <input type="text" name="hp3" id="hp3" maxlength="4" value="\${json.member_mobile.substring(9)}" />
                                            </div>
                                        </div>

                                        <div class="input-group">
                                            <label>생년월일</label>
                                            <input type="date" name="member_birthday" id="member_birthday" value="\${json.member_birthday}" />
                                        </div>

                                        <div class="input-group">
                                            <label>성별</label>
                                            <input type="radio" name="member_gender" value="남" id="male" class="requiredInfo_radio"
                                                \${json.member_gender == '남' ? 'checked' : ''} />
                                            <label for="male" style="margin-left: 1.5%;">남자</label>

                                            <input type="radio" name="member_gender" value="여" id="female" class="requiredInfo_radio"
                                                style="margin-left: 10%;" \${json.member_gender == '여' ? 'checked' : ''} />
                                            <label for="female" style="margin-left: 1.5%;">여자</label>
                                        </div>

                                        <div class="input-group">
                                            <label>이메일</label>
                                            <input type="text" name="member_email" id="member_email" value="\${json.member_email}" />
                                        </div>

                                        <div class="input-group">
                                            <label>입사일</label>
                                            <input type="date" name="member_start" id="member_start" value="\${json.member_start}" />
                                        </div>

                                        <div class="input-group">
                                            <label>연차</label>
                                            <input type="text" name="member_yeoncha" id="member_yeoncha" value="\${json.member_yeoncha}" readonly />
                                        </div>

                                        <div class="input-group">
                                            <label>근무시간</label>
                                            <select name="member_workingTime">
                                                <option value="\${json.member_workingTime}">\${json.member_workingTime}</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" id="saveChanges" onclick="submitForm()">수정</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                        </div>
                    </div>
                </div>
            </div>
            `;
     
             
            // 모달 HTML 삽입
            EditModal_container.html(modal_popup);
            
        	
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
            
               
            
            //상위부서 데이터값 불러오기
            const parentDeptSelect = $("#parentDeptSelect");
		    let ParentValue = parentDeptSelect.val(); // 기존 선택된 값 저장
	
           // AJAX로 상위 부서 목록을 불러오기
           $.ajax({
               url: "${pageContext.request.contextPath}/management/parentDeptJSON",
               dataType: "json",
               success: function(json) {
            	   
            	   // 기존 옵션 초기화
       		       parentDeptSelect.empty();

            	   json.forEach(function(item) {
                       let isSelected = (item.parent_dept_no == ParentValue) ? "selected" : "";
                       parentDeptSelect.append('<option value="' + item.parent_dept_no ${isSelected}+ '">' + item.parent_dept_name + '</option>');
                   });
            	   
            	   ParentValue = parentDeptSelect.val();

                  
               },
               error: function(request, status, error) {
            	   alert("code: " + request.status + "\nmessage: " + request.responseText + "\nerror: " + error);
               }
           });
           	
           	 //하위부서 데이터값 불러오기
                $("select[id='parentDeptSelect']").change(function(){	
                	let ParentValue = $(this).val(); 
                    const childDeptSelect = $("select[name='fk_child_dept_no']");

                    // 기존 옵션 초기화
                    childDeptSelect.empty();
                    childDeptSelect.append('<option value=""> 하위부서 선택 </option>');
                    
                    if (ParentValue) { // 부서가 선택되었을 때만 AJAX 요청
                        $.ajax({
                            url: "${pageContext.request.contextPath}/management/childDeptJSON",
                            data: {"dept": ParentValue},
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
                $("select[id='parentDeptSelect']").change(function() {
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
               
               	const workingTime = $("select[name='member_workingTime']"); 
               	workingTime.empty();
               	
               	workingTime.append('<option value="day"> day </option>')
               	workingTime.append('<option value="evening"> evening </option>')
               	workingTime.append('<option value="night"> night </option>')
                
                

            // 모달 띄우기
            $('div#EditView').modal('show');
           	
            
        },
        error: function(request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    });

}

function submitForm() {
    const frm = document.forms["Managementedt"];
    frm.method = "post";
    frm.action = "<%= ctxPath %>/management/ManagementForm";  
    frm.submit(); 
}



/* === 회원 퇴사처리 js === */
function goQuit(member_userid) {
	
	const now = new Date();
 	const daysOfWeek = ["일","월","화","수","목","금","토"];
 	const dayOfWeek = daysOfWeek[now.getDay()];
 	const year = now.getFullYear();
 	const month = (now.getMonth()+1).toString().padStart(2, '0');
 	const day = now.getDate().toString().padStart(2, '0')
 	

 	const timeString = `\${year}-\${month}-\${day}`
	
	
	 $.ajax({
	        url: "<%= ctxPath%>/management/managementone",
	        data: { "member_userid": member_userid },
	        type: "post",
	        dataType: "json",
	        success: function(json) {
	        	
	            // 모달을 띄울 위치
	            const EditModal_container = $("div#EditModal");
	            console.log(timeString);
	            // 모달 HTML 생성 (json 사용)
	            const modal_popup = `
	                <div class="modal fade" id="EditView" aria-labelledby="EditViewLabel" tabindex="-1" aria-hidden="true">
	                    <div class="modal-dialog modal-lg">
	                        <div class="modal-content">
	                            <div class="modal-header">
	                                <h5 class="modal-title" id="EditViewLabel">사원 퇴사 처리</h5>
	                            </div>
	                            <div class="modal-body">
	                            <div style="display: flex; align-items: center; width: 100%; max-width: 800px; margin: auto;">
	                            <!-- 프로필 사진 -->
	                            <div class="delete_member">
	                                <img width="137" height="176" src="<%=ctxPath%>/resources/profile/\${json.member_pro_filename}" 
	                                     alt="프로필">
	                            </div>

	                            <div class="delete_member0">
	                                <div class="delete_member1">
	                                    <label class="delabel">사번</label>
	                                    <input type="text" name="member_userid" id="member_userid" value="\${json.member_userid}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">성명</label>
	                                    <input type="text" name="member_name" id="member_name" value="\${json.member_name}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">상위 부서</label>
	                                    <input type="text" name="child_dept_name" id="child_dept_name" value="\${json.child_dept_name}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">하위 부서</label>
	                                    <input type="text" name="parent_dept_name" id="parent_dept_name" value="\${json.parent_dept_name}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">직급</label>
	                                    <input type="text" name="member_position" id="member_position" value="\${json.member_position}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">전화번호</label>
	                                    <input type="text" name="member_mobile" id="member_mobile" value="\${json.member_mobile}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">생년월일</label>
	                                    <input type="text" name="member_birthday" id="member_birthday" value="\${json.member_birthday}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">성별</label>
	                                    <input type="text" name="member_gender" id="member_gender" value="\${json.member_gender}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">이메일</label>
	                                    <input type="text" name="member_email" id="member_email" value="\${json.member_email}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">입사일</label>
	                                    <input type="text" name="member_start" id="member_start" value="\${json.member_start}" readonly />
	                                </div>

	                                <div class="delete_member1">
	                                    <label class="delabel">연차</label>
	                                    <input type="text" name="member_yeoncha" id="member_yeoncha" value="\${json.member_yeoncha}" readonly />
	                                </div>
	                            </div>
	                        </div>
			                        <div style="margin-top: 20px; text-align: center;">
			                            <span style="font-weight: bold;">\${timeString}</span>
			                            <p style="color: red;">오늘 날짜로 퇴사처리 됩니다.</p>
		                        	</div>


	                            <div class="modal-footer">
	                                <button type="button" class="btn btn-primary" id="saveChanges">퇴사처리</button>
	                                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            `;
	     
	             
	            // 모달 HTML 삽입
	            EditModal_container.html(modal_popup);
	            
	            // 모달 띄우기
	            $('div#EditView').modal('show');
	            
	            
	        },
	        error: function(request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	    });
}


</script>

<div class="subContent">

	<div class="manag_h3">
		<h3>인사관리 <사원목록조회> </h3>
	</div>
	
	
	<div id="displayList" style="border:solid 1px gray; border-top:0px; height:40px; margin-left:8.6%; margin-top:-1px;  overflow:auto;"></div>
	
	<table>
		<thead>
		    <tr>
		    	<th>순서</th>
		    	<th>사번</th>
		    	<th>프로필</th>
		    	<th>하위부서명</th>
		    	<th>성명</th>
				<th>성별</th>
				<th>근무시간</th>
				<th>직급</th>
		   </tr>
		</thead>
		
		<tbody>
	<c:if test="${not empty requestScope.Manag_List}">
	<c:forEach var="managementVO_ga" items="${requestScope.Manag_List}" varStatus="status">
	<tr>
	<td>${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (status.index) }
	</td>
	<td>${managementVO_ga.member_userid}</td>
	<td><img width="50" height="50" src="<%=ctxPath%>/resources/profile/${managementVO_ga.member_pro_filename}" alt="프로필"></td>
	<td>${managementVO_ga.child_dept_name}</td>
	<td>${managementVO_ga.member_name}</td>
	<td>${managementVO_ga.member_gender}</td>
	<td>${managementVO_ga.member_workingTime}</td>
	<td>${managementVO_ga.member_position}</td>
	<td><button type="button" id="EditView" onclick="goEdit('${managementVO_ga.member_userid}')">정보수정</button> </td>
	<td><button type="button" onclick="goQuit('${managementVO_ga.member_userid}')">퇴사처리</button> </td>
	</c:forEach>
	</c:if>
	  
	  <c:if test="${empty requestScope.Manag_List}">
	  <tr><td colspan="6">조회할 사원데이터가 없습니다.</td></tr>
	  </c:if>
		</tbody>
    </table>
    
	<div id="EditModal"></div>
    <div id="QuitModal"></div>
    
<div>
   <div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">${requestScope.pageBar}</div>
   
    <form name="searchFrm" style="margin-top: 20px;">
		<select name="searchType" style="height: 26px;">
			<option value="userid">사번명</option>
			<option value="position">직급명</option>
			<option value="name">사원명</option>
		</select>
		<input type="text" name="searchWord" size="10" autocomplete="off" /> 
		<input type="text" style="display: none;"/>  
		<button type="button" onclick="goSearch()">검색</button> 
	</form>	
</div>
	
</div>


	

<form name="goViewFrm">
   <input type="hidden" name="mem_userid" />
   <input type="hidden" name="goBackURL" />
   <input type="hidden" name="searchType" />
   <input type="hidden" name="searchWord" />
</form>	

<jsp:include page="../../footer/footer1.jsp" />  