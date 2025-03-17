<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../../header/header1.jsp" /> 

<style type="text/css">
    
th {background-color: #e0eae6}
   
.subjectStyle {font-weight: bold;
                  color: #006769;
                  cursor: pointer; }
                  
a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
   
button.btn {
	background-color: #006769;
	color:white;
}

table {
  border: 1px #a39485 solid;
  box-shadow: 0 2px 5px rgba(0,0,0,.25);
  width: 100%;
  border-collapse: collapse;
  border-radius: 5px;
  overflow: hidden;
  font-weight: bold; 
}
	
	
.header .title {
    border-left: 5px solid #006769;  /* 바 두께 증가 */
    padding-left: 1.5%;  /* 왼쪽 여백 조정 */
    font-size: 28px;  /* h2 크기와 유사하게 증가 */
    margin-top: 2%;
    margin-bottom: 2%;
    color: #4c4d4f;
    font-weight: bold;
}

  /* 검색어 입력창 */
input[name='searchWord'] {
	width: 20% ;
  	color: #006769 ;
  	border: none ;
  	border-bottom: 1px solid #999999 ;  
  	padding: 9px ;
  	margin: 7px ;
}

.searchWord_input:placeholder {
  	color: rgba(255, 255, 255, 1) !important;
  	font-weight: 100 !important;
}

.searchWord_input:focus {
  	color: #006769 !important;
  	outline: none !important;
  	border-bottom: 1.3px solid #006769 !important; 
  	transition: .8s all ease !important;
}

.searchWord_input:focus::placeholder {
  	opacity: 0 !important;
}


<%-- select 태그 --%>
.top_select {
	padding: 5px;
	font-size: 14px;
	border-radius: 10px;
	color: #006769;
	border: solid 1px #8ac2bd;
}

<%-- 상단 검색 버튼 등 --%>
div#topSearch {
	text-align: right;
	margin-right: 3%;
}
  

/* 페이지바 */
div#pageBar_bottom a {
	color: #509d9c !important;
	cursor: pointer;
}
#pageBar_bottom > ul > li {
	color: #006769 !important;
	font-weight: bold;
	cursor: pointer;
}

</style>


<script type="text/javascript">
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
    
    frm.myboard_val.value = 'myboard_val';
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


 <div id="sub_mycontent">

<div style="display: flex;">
<div style="margin: auto; padding-left: 3%;">

    <div class="header">		
	  		<div class="title">내가 작성한 글</div>
	 </div>

    <table style="width: 1200px" class="table table-hover">
        <thead>
            <tr>
               <th style="width: 70px; text-align: center;">글번호</th>
			        <th style="width: 300px; text-align: center;">제목</th>
			        <th style="width: 70px; text-align: center;">작성자</th>
			        <th style="width: 150px; text-align: center;">작성일자</th>
			        <th style="width: 60px; text-align: center;">조회수</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${not empty requestScope.myBoardList}">
                <c:forEach var="boardvo" items="${requestScope.myBoardList}" varStatus="board_status">
                    <tr onclick="goMyBoardView('${boardvo.board_no}')" style="cursor: pointer;">
                        <td align="center" id="pageBar">
                            ${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (board_status.index) }
                        </td>
                       <td>
						    <span class="board_subject">
						        ${fn:length(boardvo.board_subject) > 30 ? fn:substring(boardvo.board_subject, 0, 28) + "..." : boardvo.board_subject}
						    
						    <!-- 첨부파일 아이콘 -->
					        <c:if test="${not empty boardvo.board_fileName}">
					            <i class="fa-solid fa-paperclip" style="color:#509d9c; margin-left: 5px;"></i>
					        </c:if>
					
					        <!-- 댓글 개수 표시 -->
					        <c:if test="${boardvo.board_commentCount > 0}">
					            <span style="color: #f68b1f; font-weight: bold; margin-left: 5px;">[${boardvo.board_commentCount}]</span>
					        </c:if>
						    
						    </span>
					   </td>
                        <td align="center">${boardvo.board_name}</td>
						<td align="center">${boardvo.board_regDate}</td>
						<td align="center">${boardvo.board_readCount}</td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty requestScope.myBoardList}">
                <tr>
                    <td colspan="7" style="text-align: center;">작성한 글이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>

			<div class="button-container" style="display: flex; justify-content: space-between; align-items: center; width: 1200px; margin-bottom: 5px;"> 
			    <p style="font-weight: bold; font-size: 16px; margin: 0;">총 게시글 수: ${totalCount}개</p>
			    <button type="button" class="btn btn ml-2"
			        onclick="javascript:location.href='<%=ctxPath%>/board/add'">글쓰기
			    </button>
			</div>

    </table>



    <%-- === 페이지바 === --%>
		<div align="center" id="pageBar_bottom"
			style="border: solid 0px gray; width: 80%; margin: 30px auto;">
			${requestScope.pageBar}</div>

     
  <%-- === #82. 글검색 폼 추가하기 : 글제목, 글내용, 글제목+글내용, 글쓴이로 검색을 하도록 한다. --%>
		<div id="topSearch">
			<form name="searchFrm" style="margin-top: 20px; text-align: center;">
				<select name="searchType" class="topClass top_select" style="height: 38px;">
					<option value="board_subject">글제목</option>
					<option value="board_content">글내용</option>
					<option value="board_subject_board_content">글제목+글내용</option>
					<option value="board_name">글쓴이</option>
				</select> 
				<input type="text" class="searchWord_input" name="searchWord" placeholder="검색어 입력를 입력하세요"/>
				<input type="text" style="display: none;" />
				<%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>
				<button type="button" class="btn ml-2" onclick="goSearch()" id="btnWrite">검색</button>
			</form>
		</div>
		
		</div>
  </div>
 </div>  
 
 <form name="goMyBoardViewFrm">
    <input type="hidden" name="board_no" /> 
	<input type="hidden" name="goBackURL" /> 
	<input type="hidden" name="searchType" /> 
	<input type="hidden" name="searchWord" />
	<input type="hidden" name="myboard_val" />
</form>
 


  <jsp:include page="../../../footer/footer1.jsp" />