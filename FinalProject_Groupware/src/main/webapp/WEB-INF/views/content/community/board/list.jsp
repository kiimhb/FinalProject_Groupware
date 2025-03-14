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

<jsp:include page="../../../header/header1.jsp" /> 

<style type="text/css">
    
  th {background-color: #ddd}
  
  .subjectStyle {font-weight: bold;
                 color: navy;
                 cursor: pointer; }
                 
  a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
  
  div.button {text-align: right;}
  

.header .title {
     border-left: 5px solid #006769;  /* 바 두께 증가 */
    padding-left: 1.5%;  /* 왼쪽 여백 조정 */
    font-size: 28px;  /* h2 크기와 유사하게 증가 */
    margin-top: 2%;
    margin-bottom: 2%;
    color: #4c4d4f;
    font-weight: bold;
}

  
  button.btn {
	background-color: #006769;
	color:white;
	
	.no-outline:focus {
    outline: none; /* 포커스 시 파란 테두리 제거 */
    box-shadow: none; /* 추가적인 파란색 그림자 제거 */
  }

/* 페이지바 */
div#pageBar a {
	color: #509d9c;
	cursor: pointer;
}
#pageBar > ul > li {
	color: #006769;
	font-weight: bold;
	cursor: pointer;
}

div#pageBar a {
    color: #509d9c;
    cursor: pointer;
    text-decoration: none;
}

#pageBar > ul {
    list-style: none;
    padding: 0;
    display: flex;
    justify-content: center;
}

#pageBar > ul > li {
    color: #006769;
    font-weight: bold;
    cursor: pointer;
    padding: 5px 10px;
    border-radius: 5px;
    margin: 0 5px;
    transition: background-color 0.2s ease-in-out;
}

</style>


<script type="text/javascript">
//즐겨찾기 추가/삭제 함수
function importantboard(board_no, button) {
    let icon = $(button).find("i"); // 클릭한 버튼 내 아이콘 요소 찾기
    let isBookmarked = icon.hasClass("fa-star"); // 현재 즐겨찾기 여부 확인

    $.ajax({
        url: "<%= ctxPath%>/board/bookmark",
        type: "POST",
        data: { "board_no": board_no },
        success: function (response) {
            if (response.success) {
                if (!isBookmarked) {
                    icon.removeClass("fa-star-o").addClass("fa-star").css("color", "gold"); // 즐겨찾기 추가
                    //localStorage.setItem("bookmark_" + board_no, "true"); // LocalStorage 저장
                } else {
                    icon.removeClass("fa-star").addClass("fa-star-o").css("color", "gray"); // 즐겨찾기 삭제
                    //localStorage.removeItem("bookmark_" + board_no); // LocalStorage 삭제
                }

                // 모든 페이지에서 동일한 글의 아이콘 상태 변경
                $(".btnstar[data-board-no='" + board_no + "'] i")
                    .removeClass(isBookmarked ? "fa-star" : "fa-star-o")
                    .addClass(isBookmarked ? "fa-star-o" : "fa-star")
                    .css("color", isBookmarked ? "gray" : "gold");
            }
        },
        error: function () {
            console.error("즐겨찾기 상태 업데이트 실패");
        }
    });
}

$(document).ready(function() {


    // window.addEventListener("storage")를 활용.
    window.addEventListener("storage", function(event) {
        if (event.key === "updateBookmark") {
            $(".btnstar").each(function() {
                let board_no = $(this).attr("data-board-no");
                let icon = $(this).find("i");

                //if (localStorage.getItem("bookmark_" + board_no) === "true") {
                //    icon.removeClass("fa-star-o").addClass("fa-star").css("color", "gold");
                //} else {
                //    icon.removeClass("fa-star").addClass("fa-star-o").css("color", "gray");
                //}
            });
        }
    });
});


$(document).ready(function(){
	
	// 즐겨찾기 여부 확인
	$.ajax({
        url: "<%= ctxPath%>/board/selectbookmark",
        type: "GET",
        success: function (response) {
        	//console.log(response[0].fk_board_no);
        	//console.log(JSON.stringify(response));
        	const btnstar = $("button.btnstar");
        	
        	//console.log(btnstar);
        	//sconsole.log(btnstar.data("board-no"));
        	
		  	$.each(response, function(index, bookmark) {
        		//let icon = $(button).find("i"); // 클릭한 버튼 내 아이콘 요소 찾기
        		
        		//console.log(bookmark.fk_board_no);
        		
     		    $("button.btnstar").each(function(index, btnitem, array){
	    			//console.log($(btnitem2).data("board-no"));
	    			//console.log(btnitem2);
	    			
	    			var star_btn = $(btnitem).data("board-no");
	    			//console.log(star_btn);
	    			
	        		if(star_btn == bookmark.fk_board_no) {
	        			console.log($(btnitem).find("i"));
	        			$(btnitem).find("i").removeClass("fa-star-o").addClass("fa-star").css("color", "gold");
	        			return;
	        		}
            	
    		
    			});

        		
            });
        	

        },
        error: function () {
            console.error("즐겨찾기 상태 업데이트 실패");
        }
    });

    
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
                      // word.toLowerCase() 은 word 를 모두 소문자로 변경하는 것이다.
                      /*     java가 쉽나요?
                            java공부를 하려고 해요. 도와주세요~~
                            프로그래밍은 java 를 해야 하나요?
                            javascript 는 쉬운가요?
                            프론트 엔드를 하려면 javascript 를 해야 하나요?
                            질문있어요 jquery 와 javascript 는 관련이 있나요?        
                      */ 
                         
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
 
 
 // Function Declaration
 function goView(board_no) {
   
    <%-- location.href=`<%= ctxPath%>/board/view?seq=\${seq}`;  --%>
    
    const goBackURL = "${requestScope.goBackURL}";
    //  console.log(goBackURL);
    //  /board/list?searchType=subject&searchWord=%EC%9E%85%EB%8B%88%EB%8B%A4&currentShowPageNo=7
          
   <%--  
    !!!! 아래처럼 get 방식으로 보내면 안된다. 왜냐하면 get방식에서 &는 데이터의 구분자로 사용되기 때문이다 !!!!
    그래서 boardController 의 @GetMapping("view") 에 가서 @RequestParam String  goBackURL
    /board/list?searchType=subject&searchWord=%EC%9E%85%EB%8B%88%EB%8B%A4&currentShowPageNo=7 와 같이 안나오고
    /board/list?searchType=subject 만 나온다.
    그래서 보내줄 데이터의 & 가 들어가 있는 경우라면 get방식이 아닌 post방식으로 전달해주어야한다.
    
    location.href=`<%= ctxPath%>/board/view?seq=\${seq}&goBackURL=\${goBackURL}`;    
   --%>
   
   <%--  
     그러므로 &를 데이터의 구분자로 사용하지 않고 글자 그대로 인식하도록하기 위해 post 방식으로 보내야 한다.
     아래의 본문에 #105 에 표기된 form 태그를 먼저 만든다.
  --%>
   const frm = document.goViewFrm;
   frm.board_no.value = board_no;
   frm.goBackURL.value = goBackURL
   
   

   if(${not empty requestScope.paraMap}) {  // 검색조건이 있을 경우 (#107.)
  	 	frm.searchType.value = "${requestScope.paraMap.searchType}";
 	    frm.searchWord.value = "${requestScope.paraMap.searchWord}";
   }
   
   frm.method = "post";
   frm.action = "<%= ctxPath%>/board/view";
   frm.submit();
    
 }// end of goView(board_no)----------------------
 
 
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

		<div class="header">
			<div class="title">자유게시판</div>
		</div>

		<table style="width: 1200px" class="table table-hover">
			<thead>
			    <tr>
			    	<th style="width: 70px; text-align: center;">글번호</th>
<!-- 			        <th style="width: 70px; text-align: center;">글번호</th> -->
			        <th style="width: 300px; text-align: center;">제목</th>
			        <th style="width: 70px; text-align: center;">작성자</th>
			        <th style="width: 150px; text-align: center;">작성일자</th>
			        <th style="width: 60px; text-align: center;">조회수</th>
			        <th style="width: 60px; text-align: center;">즐겨찾기</th>
			    </tr>
			</thead>

			<tbody>
				<c:if test="${not empty requestScope.boardList}">
					<c:forEach var="boardvo" items="${requestScope.boardList}" varStatus="board_status">
						<tr onclick="goView('${boardvo.board_no}')">
							<td align="center" id="pageBar">${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (board_status.index) }
								<%-- >>> 페이징 처리시 보여주는 순번 공식 <<<
		                           데이터개수 - (페이지번호 - 1) * 1페이지당보여줄개수 - 인덱스번호 => 순번 
		                        
		                           <예제>
		                           데이터개수 : 12
		                           1페이지당보여줄개수 : 5
		                        
		                           ==> 1 페이지       
		                           12 - (1-1) * 5 - 0  => 12
		                           12 - (1-1) * 5 - 1  => 11
		                           12 - (1-1) * 5 - 2  => 10
		                           12 - (1-1) * 5 - 3  =>  9
		                           12 - (1-1) * 5 - 4  =>  8
		                        
		                           ==> 2 페이지
		                           12 - (2-1) * 5 - 0  =>  7
		                           12 - (2-1) * 5 - 1  =>  6
		                           12 - (2-1) * 5 - 2  =>  5
		                           12 - (2-1) * 5 - 3  =>  4
		                           12 - (2-1) * 5 - 4  =>  3
		                        
		                           ==> 3 페이지
		                           12 - (3-1) * 5 - 0  =>  2
		                           12 - (3-1) * 5 - 1  =>  1 
		                    --%>

							</td>
 							<%-- <td align="center">${boardvo.board_no}</td>  --%>
							<td>
								<%-- === 댓글쓰기 및 답변형 및 파일첨부가 있는 게시판 시작 === --%> 

								<%-- ========= #157. 첨부파일이 없는 경우 시작 ========= --%> <c:if
									test="${empty boardvo.board_fileName}">
									<%-- >>>>>>>>> #142. 원글인 경우 시작 <<<<<<<<< --%>
									<%-- 댓글이 있는 경우 시작 --%>
									<c:if test="${boardvo.board_depthno == 0 && boardvo.board_commentCount > 0}">
										<c:if test="${fn:length(boardvo.board_subject) < 30}">
											<span class="board_subject">${boardvo.board_subject}<span style="color: #f68b1f; font-weight: bold; margin-left: 5px;">[${boardvo.board_commentCount}]</span>
											</span>
										</c:if>
										<c:if test="${fn:length(boardvo.board_subject) >= 30}">
											<span class="board_subject"
												onclick="goView('${boardvo.board_no}')">${fn:substring(boardvo.board_subject, 0, 28)}..<span style="color: #f68b1f; font-weight: bold; margin-left: 5px;">[${boardvo.board_commentCount}]</span>
											</span></span>
										</c:if>
									</c:if>
									<%-- 댓글이 있는 경우 끝  --%>

									<%-- 댓글이 없는 경우 시작 --%>
									<c:if
										test="${boardvo.board_depthno == 0 && boardvo.board_commentCount == 0}">
										<c:if test="${fn:length(boardvo.board_subject) < 30}">
											<span class="board_subject"
												onclick="goView('${boardvo.board_no}')">${boardvo.board_subject}</span>
										</c:if>
										<c:if test="${fn:length(boardvo.board_subject) >= 30}">
											<span class="board_subject"
												onclick="goView('${boardvo.board_no}')">${fn:substring(boardvo.board_subject, 0, 28)}..</span>
										</c:if>
									</c:if>
									<%-- 댓글이 없는 경우 끝  --%>
									<%-- >>>>>>>>> #142. 원글인 경우 끝  <<<<<<<<< --%>

								</c:if> <%-- ========= 첨부파일이 없는 경우 끝 ========= --%> 
								
								<%-- ========= #158. 첨부파일이 있는 경우 시작 ========= --%>
								<c:if test="${not empty boardvo.board_fileName}">
									<%-- >>>>>>>>> #142. 원글인 경우 시작 <<<<<<<<< --%>
									<%-- 댓글이 있는 경우 시작 --%>
									<c:if
										test="${boardvo.board_depthno == 0 && boardvo.board_commentCount > 0}">
										<c:if test="${fn:length(boardvo.board_subject) < 30}">
											<span class="board_subject"
												onclick="goView('${boardvo.board_no}')">${boardvo.board_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color:#509d9c; margin-left: 5px;"></i><span style="color: #f68b1f; font-weight: bold; margin-left: 5px;">[${boardvo.board_commentCount}]</span>
											</span>
										</c:if>
										<c:if test="${fn:length(boardvo.board_subject) >= 30}">
											<span class="board_subject"
												onclick="goView('${boardvo.board_no}')">${fn:substring(boardvo.board_subject, 0, 28)}..&nbsp;<i class="fa-solid fa-paperclip" style="color:#509d9c; margin-left: 5px;"></i><span style="color: #f68b1f; font-weight: bold; margin-left: 5px;">[${boardvo.board_commentCount}]</span>
											</span>
										</c:if>
									</c:if>
									<%-- 댓글이 있는 경우 끝  --%>

									<%-- 댓글이 없는 경우 시작 --%>
									<c:if
										test="${boardvo.board_depthno == 0 && boardvo.board_commentCount == 0}">
										<c:if test="${fn:length(boardvo.board_subject) < 30}">
											<span class="board_subject"
												onclick="goView('${boardvo.board_no}')">${boardvo.board_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color:#509d9c; margin-left: 5px;"></i><span style="color: #f68b1f; font-weight: bold; margin-left: 5px;"></span>
										</c:if>
										<c:if test="${fn:length(boardvo.board_subject) >= 30}">
											<span class="board_subject"
												onclick="goView('${boardvo.board_no}')">${fn:substring(boardvo.board_subject, 0, 28)}..&nbsp;<i class="fa-solid fa-paperclip" style="color:#509d9c; margin-left: 5px;"></i><span style="color: #f68b1f; font-weight: bold; margin-left: 5px;"></span>
										</c:if>
									</c:if>
									<%-- 댓글이 없는 경우 끝  --%>
									<%-- >>>>>>>>> #142. 원글인 경우 끝  <<<<<<<<< --%>

								</c:if> <%-- ========= 첨부파일이 있는 경우 끝 ========= --%> 
								
								<%-- === 댓글쓰기 및 답변형 및 파일첨부가 있는 게시판 끝 === --%>
							</td>
							<td align="center">${boardvo.board_name}</td>
							<td align="center">${boardvo.board_regDate}</td>
							<td align="center">${boardvo.board_readCount}</td>
							<td align="center">
							    <button type="button" class="btnstar btn-link p-0 no-outline" 
							        data-board-no="${boardvo.board_no}"
							        onclick="importantboard('${boardvo.board_no}', this)"
							        style="font-size: 1.5rem; color: gray; margin-left: 8px; background-color: transparent; border: none; outline: none;">
							        <i class="fa fa-star-o" aria-hidden="true"></i>
							    </button>
							</td>



						</tr>
					</c:forEach>
				</c:if>

				<c:if test="${empty requestScope.boardList}">
					<tr>
						<td colspan="7"
							style="text-align: center; vertical-align: middle;">데이터가 없습니다.</td>
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
			</select> 
			<input type="text" name="searchWord" size="28" autocomplete="off" placeholder="검색어을 입력하세요" />
			<input type="text" style="display: none;" />
			<%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>
			<button type="button" class="btn ml-2" onclick="goSearch()" id="btnWrite">검색</button>

		</form>


		<%-- === #87. 검색어 입력시 자동글 완성하기 1 === --%>
<%-- 		
		<div id="displayList"
			style="border: solid 0px gray; border-top: 0px; height: 100px; margin-left: 13.2%; margin-top: -1px; margin-bottom: 30px; overflow: auto; text-align: center;">
		</div>
--%>
	</div>
</div>

<%-- === #105. 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
               사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
               현재 페이지 주소를 뷰단으로 넘겨준다. --%>
<form name="goViewFrm">
	<input type="hidden" name="board_no" /> 
	<input type="hidden" name="goBackURL" /> 
	<input type="hidden" name="searchType" /> 
	<input type="hidden" name="searchWord" />
</form>

 
 

   
   
   <jsp:include page="../../../footer/footer1.jsp" />