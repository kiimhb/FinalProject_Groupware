<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>

<jsp:include page="../../header/header1.jsp" />

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />

<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<%-- jsTree --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree-bootstrap-theme@1.0.1/dist/themes/proton/style.min.css" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<!-- SweetAlert2 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.0/dist/sweetalert2.min.css">

<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.0/dist/sweetalert2.min.js"></script>


<style>
	h2 {
		margin-left: 4%;
		margin-top: 4%;
		margin-bottom: 1%;
		font-weight: bold;
		letter-spacing: 4px !important;
	}
	
	div.tempListContainer {
		border: solid 1px #D3D3D3;
		border-radius: 5px !important;
		width: 95%;
		height: 860px;
		margin: auto;
		margin-top: 4%;
	}
	
	<%-- 검색어 입력 창 --%>
	input {
		/* background: #f0f0f0;  */
	  	width: 20%;
	  	color: #006769;
	  	border: none;
	  	border-bottom: 1px solid #999999; 
	  	padding: 9px;
	  	margin: 7px;
	}
	
	input:placeholder {
	  	color: rgba(255, 255, 255, 1);
	  	font-weight: 100;
	}
	
	input:focus {
	  	color: #006769;
	  	outline: none;
	  	border-bottom: 1.3px solid #006769; 
	  	transition: .8s all ease;
	}
	
	input:focus::placeholder {
	  	opacity: 0;
	}
	
	<%-- 검색 버튼 --%>
	button {
  		padding: 12px;
  		text-transform: uppercase;
  		letter-spacing: 3px;
  		font-size: 11px;
  		border-radius: 10px;
  		margin: auto;
  		outline: none;
	}

	#btnSearch:hover {
  		background: #509d9c; /* $pale를 실제 색상으로 대체 */
  		color: white; /* $white를 실제 색상으로 대체 */
  		transition: background-color 1s ease-out;
	}

	#btnSearch {
  		background: white; /* $white를 실제 색상으로 대체 */
  		color: #006769; /* $pink를 실제 색상으로 대체 */
 		border: solid 1px #8ac2bd; /* $pale를 실제 색상으로 대체 */
	}
	
	<%-- select 태그 --%>
	.top_select {
		padding: 10px;
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
	
	<%-- 테이블 --%>
	div#middleTable {
		margin: 3%;
	}
	
	table {
	  border: 1px #a39485 solid;
	  font-size: .9em;
	  box-shadow: 0 2px 5px rgba(0,0,0,.25);
	  width: 100%;
	  border-collapse: collapse;
	  border-radius: 5px;
	  overflow: hidden;
	}
	  
	thead td{
	  font-weight: bold;
	  color: #fff;
	  text-align: center;
	  background-color: #509d9c;
	}
	  
	 td {
	  padding: 1em .5em;
	  vertical-align: middle;
	  text-align: center;
	  border-bottom: 1px solid rgba(0,0,0,.1);
  	  background-color: #fff;
	}
	
	tr:hover {
		cursor: pointer;
		color: #999999;
	}
	
	
	<%-- 페이지 이동 버튼 스타일 --%>
	/* 페이지바 컨테이너 */
	.pagination-container {
	    text-align: center;
	    margin-top: 5%;
	    margin-bottom: 6%;
	}
	
	/* 기본 리스트 스타일 */
	.pagination-container ul {
	    list-style: none;
	    padding: 0;
	    margin: 0;
	    display: inline-flex;
	    align-items: center;
	}
	
	/* 페이지 버튼 스타일 */
	.pagination-container li {
	    margin: 0 4px;
	}
	
	.pagination-container a, .pagination-container span {
	    display: block;
	    padding: 10px 16px;
	    font-size: 14px;
	    color: #4c4d4f;
	    text-decoration: none;
	    background-color: #fff;  /* 배경색 설정 */
	    border-radius: 10px; /* 둥근 버튼 */
	    transition: all 0.3s ease;
	    cursor: pointer;
	    box-shadow:  0 2px 5px rgba(0,0,0,.25); /* 부드러운 그림자 */
	}
	
	/* 호버 효과 */
	.pagination-container a:hover {
	    background-color: #f68b1f;
	    color: #fff;
	    transform: translateY(-3px); /* 살짝 떠오르는 느낌 */
	}
	
	/* 활성화된 페이지 스타일 */
	.pagination-container li.active span {
	    background-color: #f68b1f !important;
	    color: white;
	    border-color: #f68b1f !important;
	}
	
	/* 비활성화된 페이지 스타일 (이전, 다음 버튼) */
	.pagination-container li.disabled a {
	    color: #fff;
	    background-color: #f5f5f5;
	    border-color: #ddd;
	    cursor: not-allowed;
	}
	
	/* 페이지바 양끝 스타일 */
	.pagination-container li:first-child a {
	    border: none;
	    font-weight: bold;
	}
	
	.pagination-container li:last-child a {
	    border: none;
	    font-weight: bold;
	}
	
	/* 반응형 디자인 */
	@media (max-width: 768px) {
	    .pagination-container a {
	        padding: 8px 12px;
	        font-size: 12px;
	    }
	}
</style>


<script type="text/javascript">
$(document).ready(function(){
	
	<%-- 검색 조건 및 검색어 유지시키기 --%>
	if(${not empty requestScope.paraMap}) {
		$("select[name='searchType']").val("${requestScope.paraMap.searchType}");
        $("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
        
	}
	$("select[name='sizePerPage']").val("${requestScope.sizePerPage}");
	
	<%-- 기안문서 클릭 이벤트 --%>
	$("tbody > tr").on("click", function(e){
		
		const click_draft_no = $(this).children("td").eq(0).text();	// 클릭한 기안문의 문서번호
		
		if(${not empty requestScope.temporaryList}) {
			const frm = document.detailTempFrm;
			$("input[name='draft_no']").val(click_draft_no);
			frm.method = "post";
			frm.action = "<%= ctxPath%>/approval/approvalTemporaryDetail";
			frm.submit();
		}
	});// end of $("tbody > tr").on("click", function(e){})-----------------------------
	

});// end of $(document).ready(function(){})----------------

///////////////////////////////////////////////////////////
<%-- 검색 버튼 클릭 이벤트 --%>
function goSearch() {
	
	const sizePerPage = $("select[name='sizePerPage']").val();
	const searchType = $("select[name='searchType']").val();
	const searchWord = $("input[name='searchWord']").val();
	
	if(searchType && !searchWord) {
		Swal.fire("검색어를 입력해주세요!");
		return;
	}
	
	const frm = document.searchTempListFrm;
	frm.method = "get";
	frm.action = "<%= ctxPath%>/approval/approvalTemporaryList";
	frm.submit();
}

</script>

<%-- ===================================================================== --%>
<div class="tempListContainer">
	<h2><a href="<%= ctxPath%>/approval/approvalTemporaryList" style="text-decoration: none; color: inherit; ">임시저장함</a></h2>
	
	<div id="topSearch">
		<form name="searchTempListFrm">
			<select name="sizePerPage" class="topClass top_select">
				<option value="10">10개</option>
				<option value="15">15개</option>
				<option value="20">20개</option>
			</select>
			
			<select name="searchType" class="topClass top_select">
				<option value="">검색조건</option>
				<option value="draft_form_type">결재양식</option>
				<option value="draft_subject">제목</option>
			</select>
			
			<input type="text" name="searchWord" class="topClass" placeholder="검색어 입력"/>
			<button type="button" id="btnSearch" class="topClass" onclick="goSearch()">검색</button>
		</form>
	</div>
	
	<div id="middleTable">
		<table>
			<thead>
				<tr>
					<td>문서번호</td>
					<td>기안부서</td>
					<td>기안자</td>
					<td>결재양식</td>
					<td>제목</td>
					<td>상태</td>
					<td>작성일</td>
				</tr>
			</thead>
			<tbody>
				<c:if test="${not empty requestScope.temporaryList}">					
					<c:forEach var="approvalvo" items="${requestScope.temporaryList}" varStatus="temp_status"> 
						<%-- 첨부파일 없는 경우 --%>
						<c:if test="${empty approvalvo.draft_file_name}">
							<tr>
								<td>${approvalvo.draft_no}</td>
								<td>${approvalvo.parent_dept_name}</td>
								<td>${approvalvo.member_name}</td>
								<td>${approvalvo.draft_form_type}</td>
								<td style="text-align:left;">${approvalvo.draft_subject}</td>
								<td><span style="border: solid 1px gray; border-radius: 5px; padding: 6.5px; background-color: gray; color: white;">${approvalvo.draft_status}</span></td>
								<td>${approvalvo.draft_write_date}</td>
							</tr>
						</c:if>	
						<%-- 첨부파일 있는 경우 --%>
						<c:if test="${not empty approvalvo.draft_file_name}">
							<tr>
								<td>${approvalvo.draft_no}</td>
								<td>${approvalvo.parent_dept_name}</td>
								<td>${approvalvo.member_name}</td>
								<td>${approvalvo.draft_form_type}</td>
								<td style="text-align:left;">${approvalvo.draft_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color: #cb2525;"></i></td>
								<td><span style="border: solid 1px gray; border-radius: 5px; padding: 6.5px; background-color: gray; color: white;">${approvalvo.draft_status}</span></td>
								<td>${approvalvo.draft_write_date}</td>
							</tr>
						</c:if>	
					</c:forEach>
				</c:if>
				<c:if test="${empty requestScope.temporaryList}">	
					<tr>
						<td colspan="7">임시저장된 문서가 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
		
		<c:if test="${not empty requestScope.temporaryList}">
			<div id="pageBar" style="text-align: center; margin-top: 5%;" class="pagination-container">
				${requestScope.pageBar}
			</div>
		</c:if>
	</div>
	
	<form name="detailTempFrm">
		<input type="hidden" name="draft_no" />
	</form>
	
</div>

<jsp:include page="../../footer/footer1.jsp" />    