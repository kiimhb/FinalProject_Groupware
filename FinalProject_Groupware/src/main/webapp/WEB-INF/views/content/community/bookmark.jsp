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
    .subjectStyle {
        font-weight: bold;
        color: navy;
        cursor: pointer;
    }
    a {text-decoration: none !important;}
    button.btn {
        background-color: #006769;
        color: white;
    }
</style>

<script type="text/javascript">

// 즐겨찾기 추가/삭제 AJAX 함수
function importantboard(button, board_no) {
    const icon = button.querySelector("i");
    const isBookmarked = icon.classList.contains("fa-star");

    $.ajax({
        url: isBookmarked ? "<%= ctxPath %>/community/bookmark/remove" : "<%= ctxPath %>/community/bookmark/add",
        type: "POST",
        data: { board_no: board_no },
        success: function(response) {
            if (response === "success") {
                if (isBookmarked) {
                    icon.classList.remove("fa-star");
                    icon.classList.add("fa-star-o");
                    icon.style.color = "gray";
                } else {
                    icon.classList.remove("fa-star-o");
                    icon.classList.add("fa-star");
                    icon.style.color = "gold";
                }
            } else if (response === "not_logged_in") {
                alert("로그인이 필요합니다.");
                location.href = "<%= ctxPath %>/login";
            } else {
                alert("즐겨찾기 처리 중 오류가 발생했습니다.");
            }
        }
    });
}

$(document).ready(function() {
    // 로그인한 사용자의 즐겨찾기 목록 가져오기
    $.ajax({
        url: "<%= ctxPath %>/community/bookmark/list",
        type: "GET",
        success: function(bookmarkedList) {
            if (bookmarkedList.length > 0) {
                $("button.btnstar").each(function() {
                    const board_no = $(this).attr("data-board-no"); // 버튼의 게시글 번호 가져오기
                    if (bookmarkedList.includes(parseInt(board_no))) {
                        $(this).find("i").removeClass("fa-star-o").addClass("fa-star").css("color", "gold");
                    }
                });
            }
        }
    });
});

// 즐겨찾기 추가/삭제 AJAX 함수
function importantboard(button, board_no) {
    const icon = button.querySelector("i");
    const isBookmarked = icon.classList.contains("fa-star");

    $.ajax({
        url: isBookmarked ? "<%= ctxPath %>/community/bookmark/remove" : "<%= ctxPath %>/community/bookmark/add",
        type: "POST",
        data: { board_no: board_no },
        success: function(response) {
            if (response === "success") {
                if (isBookmarked) {
                    icon.classList.remove("fa-star");
                    icon.classList.add("fa-star-o");
                    icon.style.color = "gray";
                } else {
                    icon.classList.remove("fa-star-o");
                    icon.classList.add("fa-star");
                    icon.style.color = "gold";
                }
            } else if (response === "not_logged_in") {
                alert("로그인이 필요합니다.");
                location.href = "<%= ctxPath %>/login";
            } else {
                alert("즐겨찾기 처리 중 오류가 발생했습니다.");
            }
        }
    });
}


// 검색 실행 함수
function goSearch() {
    document.searchFrm.submit();
}
</script>

<div style="display: flex;">
    <div style="margin: auto; padding-left: 3%;">

        <h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">즐겨찾기</h2>

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
                <c:if test="${not empty requestScope.bookmarkList}">
                    <c:forEach var="boardvo" items="${requestScope.bookmarkList}" varStatus="board_status">
                        <tr>
                            <td align="center">
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
							        onclick="importantboard(this, '${boardvo.board_no}')"
							        data-board-no="${boardvo.board_no}"
							        style="font-size: 1.5rem; color: gray; margin-left: 8px; background-color: transparent; border: none; outline: none;">
							        <i class="fa fa-star-o" aria-hidden="true"></i>
							    </button>
							</td>

                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${empty requestScope.bookmarkList}">
                    <tr>
                        <td colspan="6" style="text-align: center;">즐겨찾기 한 글이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
            ${requestScope.pageBar}
        </div>

        <form name="searchFrm" style="margin-top: 20px; text-align: center;">
            <select name="searchType" style="height: 26px;">
                <option value="board_subject">글제목</option>
                <option value="board_content">글내용</option>
                <option value="board_subject_board_content">글제목+글내용</option>
                <option value="board_name">글쓴이</option>
            </select>
            <input type="text" name="searchWord" size="28" autocomplete="off" />
            <button type="button" class="btn ml-2" onclick="goSearch()" id="btnWrite">검색</button>
        </form>
    </div>
</div>

<form name="goMyBoardViewFrm">
    <input type="hidden" name="board_no" />
    <input type="hidden" name="goBackURL" />
    <input type="hidden" name="searchType" />
    <input type="hidden" name="searchWord" />
</form>

<jsp:include page="../../footer/footer1.jsp" />