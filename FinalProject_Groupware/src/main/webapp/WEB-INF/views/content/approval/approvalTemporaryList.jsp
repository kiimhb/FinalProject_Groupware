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
		margin-left: 2%;
		margin-top: 1%;
		margin-bottom: 3%;
	}
	
	div.tempListContainer {
		border: solid 1px red;
		width: 95%;
		margin: auto;
		margin-top: 2%;
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
	
	th {
	  text-align: left;
	}
	  
	thead {
	  font-weight: bold;
	  /* color: #fff; */
	  background-color: #509d9c;
	}
	  
	 td, th {
	  padding: 1em .5em;
	  vertical-align: middle;
	}
	  
	 td {
	  border-bottom: 1px solid rgba(0,0,0,.1);
	  background-color: #fff;
	}
</style>


<script type="text/javascript">
$(document).ready(function(){
	

});// end of $(document).ready(function(){})----------------
</script>

<%-- ===================================================================== --%>
<div class="tempListContainer">
	<h2>임시저장함</h2>
	
	<div id="topSearch">
		<form name="searchTempList">
			<select name="sizePerPage" class="topClass top_select">
				<option value="10개">10개</option>
				<option value="15개">15개</option>
				<option value="20개">20개</option>
			</select>
			
			<select name="sizePerPage" class="topClass top_select">
				<option value="">검색조건</option>
				<option value="draft_form_type">결재양식</option>
				<option value="draft_subject">제목</option>
			</select>
			
			<input type="text" name="searchWord" class="topClass" placeholder="검색어 입력"/>
			<button type="button" id="btnSearch" class="topClass">검색</button>
		</form>
	</div>
	
	<div id="middleTable">
		<table>
			<thead>
				<tr>
					<td>문서번호</td>
					<td>작성일</td>
					<td>기안부서</td>
					<td>기안자</td>
					<td>결재양식</td>
					<td>제목</td>
					<td>상태</td>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	
</div>

<jsp:include page="../../footer/footer1.jsp" />    