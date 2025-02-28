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
        url: "<%= ctxPath%>/management/managementEdit",
        data: { "member_userid": member_userid },
        type: "post",
        dataType: "json",
        success: function(json) {
            console.log(json); // 데이터 확인

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
                                <input type="text" name="member_userid" id="member_userid" value="${member_userid}" readonly />
                                <input type="text" name="member_name" id="member_name" value="${member_name}" />
                                <input type="text" name="member_email" id="member_email" value="${member_email}" />
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                                <button type="button" class="btn btn-primary" id="saveChanges">저장</button>
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
	
	 <form name="searchFrm" style="margin-top: 20px;">
		<select name="searchType" style="height: 26px;">
			<option value="userid">사번명</option>
			<option value="position">직급명</option>
			<option value="name">사원명</option>
		</select>
		<input type="text" name="searchWord" size="10" autocomplete="off" /> 
		<input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>  
		<button type="button" onclick="goSearch()">검색</button> 
	</form>	
	
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
	<td>${managementVO_ga.member_position}</td>
	<td><button type="button" id="EditView" onclick="goEdit('${managementVO_ga.member_userid}')">정보수정</button> </td>
	<td><button type="button" onclick="goQuit()">퇴사처리</button> </td>
	</c:forEach>
	</c:if>
	  
	  <c:if test="${empty requestScope.Manag_List}">
	  <tr><td colspan="6">조회할 사원데이터가 없습니다.</td></tr>
	  </c:if>
		</tbody>
    </table>
    
	<div id="EditModal"></div>
    <div id="QuitModal"></div>
    
   <div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">${requestScope.pageBar}</div>
	
</div>

<form name="goViewFrm">
   <input type="hidden" name="mem_userid" />
   <input type="hidden" name="goBackURL" />
   <input type="hidden" name="searchType" />
   <input type="hidden" name="searchWord" />
</form>	

<jsp:include page="../../footer/footer1.jsp" />  