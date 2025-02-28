<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../header/header1.jsp" /> 

<style type="text/css">
    
    th {background-color: #ddd}
    
    .subjectStyle {font-weight: bold;
                   color: navy;
                   cursor: pointer; }
                   
    a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
    
      button.btn {
	background-color: #006769;
	color:white;
</style>


<script type="text/javascript">

//즐겨찾기 토글 함수
function importantboard(button) {
	  const icon = button.querySelector("i");
	  if (icon.classList.contains("fa-star-o")) {
	    // 비어 있는 별 -> 채워진 별
	    icon.classList.remove("fa-star-o");
	    icon.classList.add("fa-star");
	    icon.style.color = "gold";
	  } else {
	    // 채워진 별 -> 비어 있는 별
	    icon.classList.remove("fa-star");
	    icon.classList.add("fa-star-o");
	    icon.style.color = "gray";
	  }
}



$(document).ready(function(){
    
    $("span.board_subject").hover(function(e){
       $(e.target).addClass("subjectStyle");
    }, function(e){
       $(e.target).removeClass("subjectStyle");
    });
    
    
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
    
    
    <%-- === #88. 검색어 입력시 자동글 완성하기 2 === --%>
    $("div#displayList").hide();
    
    $("input[name='searchWord']").keyup(function(){
      
       const wordLength = $(this).val().trim().length;
       // 검색어에서 공백을 제거한 길이를 알아온다.
       
       if(wordLength == 0) {
          $("div#displayList").hide();
          // 검색어가 공백이거나 검색어 입력후 백스페이스키를 눌러서 검색어를 모두 지우면 검색된 내용이 안 나오도록 해야 한다. 
       }
       
       else {
          
          if( $("select[name='searchType']").val() == "board_subject" || 
              $("select[name='searchType']").val() == "board_name") {
          
             $.ajax({
                url:"<%= ctxPath%>/board/wordSearchShow",
                type:"get",
                data:{"searchType":$("select[name='searchType']").val()
                    ,"searchWord":$("input[name='searchWord']").val()},
                dataType:"json",
                success:function(json){
                // console.log(JSON.stringify(json));
                   
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
    
    
    <%-- === #94. 검색어 입력시 자동글 완성하기 8 === --%>
    $(document).on("click", "span.result", function(e){
       const word = $(e.target).text();
       $("input[name='searchWord']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다.
       $("div#displayList").hide();
       goSearch();
    });
    
 });// end of $(document).ready(function(){})-------------------------------
 

 function goMyBoardView(board_no) {
    const goBackURL = "${requestScope.goBackURL}"; // 뒤로가기 URL 유지

    const frm = document.goMyBoardViewFrm;
    frm.board_no.value = board_no;
    frm.goBackURL.value = goBackURL;
    
    if(${not empty requestScope.paraMap}) {  // 검색조건이 있을 경우 (#107.)
  	 	frm.searchType.value = "${requestScope.paraMap.searchType}";
 	    frm.searchWord.value = "${requestScope.paraMap.searchWord}";
   }
    
    frm.method = "post"; 
    frm.action = "<%= ctxPath%>/board/view"; // MyboardController의 view 매핑
    frm.submit();
}
 
 // Function Declaration
 function goSearch() {
    const frm = document.searchFrm;
<%-- frm.method = "get";
    frm.action = "<%= ctxPath%>/board/list";
--%>
    frm.submit();
 }// end of function goSearch()-----------------

</script>

<div style="display: flex;">
<div style="margin: auto; padding-left: 3%;">

   <h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">내가 작성한 글</h2>
   
    <table style="width: 1200px" class="table table-hover">
        <thead>
            <tr>
               <th style="width: 70px; text-align: center;">글번호</th>
			        <th style="width: 300px; text-align: center;">제목</th>
			        <th style="width: 70px; text-align: center;">작성자</th>
			        <th style="width: 150px; text-align: center;">작성일자</th>
			        <th style="width: 60px; text-align: center;">조회수</th>
			        <th style="width: 60px; text-align: center;">즐겨찾기</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${not empty requestScope.myBoardList}">
                <c:forEach var="boardvo" items="${requestScope.myBoardList}" varStatus="board_status">
                    <tr>
                        <td align="center" id="pageBar">
                            ${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (board_status.index) }
                        </td>
                       <td>
						    <span class="board_subject" onclick="goMyBoardView('${boardvo.board_no}')">
						        ${fn:length(boardvo.board_subject) > 30 ? fn:substring(boardvo.board_subject, 0, 28) + "..." : boardvo.board_subject}
						    </span>
					   </td>
                        <td align="center">${boardvo.board_name}</td>
						<td align="center">${boardvo.board_regDate}</td>
						<td align="center">${boardvo.board_readCount}</td>
						<td align="center">
							    <button type="button" class="btnstar btn-link p-0 no-outline" 
							        onclick="importantboard(this, '${board.board_no}')" 
							         style="font-size: 1.5rem; color: gray; margin-left: 8px; background-color: transparent; border: none; outline: none;">
							        <i class="fa fa-star-o" aria-hidden="true"></i>
							    </button>
						</td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty requestScope.myBoardList}">
                <tr>
                    <td colspan="7" style="text-align: center;">작성한 글이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
       		<div class="button">
				<button type="button" class="btn btn ml-2"
					onclick="javascript:location.href='<%=ctxPath%>/board/add'"
					style="margin-bottom: 10px;">글쓰기</button>
			</div>
    </table>

    <%-- === 페이지바 === --%>
		<div align="center" id="pageBar"
			style="border: solid 0px gray; width: 80%; margin: 30px auto;">
			${requestScope.pageBar}</div>

     
  <%-- === #82. 글검색 폼 추가하기 : 글제목, 글내용, 글제목+글내용, 글쓴이로 검색을 하도록 한다. --%>
		<form name="searchFrm" style="margin-top: 20px; text-align: center;">
			<select name="searchType" style="height: 26px;">
				<option value="board_subject">글제목</option>
				<option value="board_content">글내용</option>
				<option value="board_subject_board_content">글제목+글내용</option>
				<option value="board_name">글쓴이</option>
			</select> <input type="text" name="searchWord" size="28" autocomplete="off" />
			<input type="text" style="display: none;" />
			<%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>
			<button type="button" class="btn ml-2" onclick="goSearch()" id="btnWrite">검색</button>

		</form>
   
<%-- === #87. 검색어 입력시 자동글 완성하기 1 === --%>
		<div id="displayList"
			style="border: solid 0px gray; border-top: 0px; height: 100px; margin-left: 13.2%; margin-top: -1px; margin-bottom: 30px; overflow: auto;">
		</div>
  </div>
 </div>  
 
 <form name="goMyBoardViewFrm">
    <input type="hidden" name="board_no" /> 
	<input type="hidden" name="goBackURL" /> 
	<input type="hidden" name="searchType" /> 
	<input type="hidden" name="searchWord" />
</form>
 
 

  <jsp:include page="../../footer/footer1.jsp" />