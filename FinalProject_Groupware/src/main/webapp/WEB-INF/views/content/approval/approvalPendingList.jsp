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
		margin-left: 3%;
      	margin-top: 4%;
      	margin-bottom: 3%;
      	letter-spacing: 4px !important;
		border-left: 5px solid #006769;   
		padding-left: 1%;
		margin-bottom: 1%;
		color: #4c4d4f;
		font-weight: bold;
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
	button.btn {
		background-color: #006769;
		color:white; 
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
/*   	  background-color: #fff; */
	}
	
	tr:hover {
		cursor: pointer;
		color: #999999;
	}
	
	<%-- 결재 진행 중 상태일 때 --%>
	.approved {
	    background-color: #d4edda;  /* 연두색 배경 */
	    color: #155724;  /* 어두운 녹색 텍스트 */
	}
	
	<%-- 페이지 이동 버튼 스타일 --%>
	div#pageBar a {
		color: #509d9c;
		cursor: pointer;
	}
	#pageBar > ul > li {
		color: #006769;
		font-weight: bold;
		cursor: pointer;
	}
	.page-link {
		border: none;
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
		
		if(${not empty requestScope.pendingList}) {
			const frm = document.detailTempFrm;
			$("input[name='draft_no']").val(click_draft_no);
			frm.method = "post";
			frm.action = "<%= ctxPath%>/approval/approvalPendingListDetail";
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
	frm.action = "<%= ctxPath%>/approval/approvalPendingList";
	frm.submit();
}

</script>

<%-- ===================================================================== --%>
<div id="sub_mycontent"> 
	<div class="tempListContainer">
		<h2><a href="<%= ctxPath%>/approval/approvalPendingList" style="text-decoration: none; color: inherit; ">결재문서함</a></h2>
		
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
					<option value="member_name">기안자</option>
					<option value="parent_dept_name">기안부서</option>
				</select>
				
				<input type="text" name="searchWord" class="topClass" placeholder="검색어 입력"/>
				<button type="button" id="btnSearch" class="topClass btn" onclick="goSearch()">검색</button>
			</form>
		</div>
		
		<div id="middleTable">
			<table >
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
					<c:if test="${not empty requestScope.pendingList}">			
						<%-- ============ 긴급한 기안문 ============ --%>		
						<c:forEach var="approvalvo" items="${requestScope.pendingList}" varStatus="pending_status"> 
							<c:if test="${approvalvo.draft_urgent eq '1' && approvalvo.approval_status eq '결재예정'}">
								<%-- 첨부파일 없는 경우 --%>
								<c:if test="${empty approvalvo.draft_file_name}">
									<tr>
										<td>${approvalvo.draft_no}</td>
										<td>${approvalvo.parent_dept_name}</td>
										<td>${approvalvo.member_name}</td>
										<td>${approvalvo.draft_form_type}</td>
										<td style="text-align:left;"><i class="fa-solid fa-bell fa-shake" style="color: #f68b1f;"></i>&nbsp;&nbsp;${approvalvo.draft_subject}</td>
										<td>
											<c:if test="${approvalvo.draft_status == '진행중'}">
												<span style="border: solid 1px #28a745; border-radius: 5px; padding: 6.5px; background-color: #28a745; color: white;">${approvalvo.draft_status}</span>
											</c:if>	
											<c:if test="${approvalvo.draft_status == '반려완료'}">
												<span style="border: solid 1px #dc3545; border-radius: 5px; padding: 6.5px 13px; background-color: #dc3545; color: white;">반려</span>
											</c:if>	
											<c:if test="${approvalvo.draft_status == '승인완료'}">
												<span style="border: solid 1px #17a2b8; border-radius: 5px; padding: 6.5px 13px; background-color: #17a2b8; color: white;">승인</span>
											</c:if>
											<c:if test="${approvalvo.draft_status == '대기'}">
												<span style="border: solid 1px #ffc107; border-radius: 5px; padding: 6.5px 13px; background-color: #ffc107; color: white;">대기</span>
											</c:if>		
										</td>
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
										<td style="text-align:left;"><i class="fa-solid fa-bell fa-shake" style="color: #f68b1f;"></i>&nbsp;&nbsp;${approvalvo.draft_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color: #cb2525;"></i></td>
										<td>
											<c:if test="${approvalvo.draft_status == '진행중'}">
												<span style="border: solid 1px #28a745; border-radius: 5px; padding: 6.5px; background-color: #28a745; color: white;">${approvalvo.draft_status}</span>
											</c:if>	
											<c:if test="${approvalvo.draft_status == '반려완료'}">
												<span style="border: solid 1px #dc3545; border-radius: 5px; padding: 6.5px 13px; background-color: #dc3545; color: white;">반려</span>
											</c:if>	
											<c:if test="${approvalvo.draft_status == '승인완료'}">
												<span style="border: solid 1px #17a2b8; border-radius: 5px; padding: 6.5px 13px; background-color: #17a2b8; color: white;">승인</span>
											</c:if>	
											<c:if test="${approvalvo.draft_status == '대기'}">
												<span style="border: solid 1px #ffc107; border-radius: 5px; padding: 6.5px 13px; background-color: #ffc107; color: white;">대기</span>
											</c:if>	
										</td>
										<td>${approvalvo.draft_write_date}</td>
									</tr>
								</c:if>	
							</c:if>
						</c:forEach>
						
						<%-- ============ 일반 기안문 ============ --%>	
						<c:forEach var="approvalvo" items="${requestScope.pendingList}" varStatus="pending_status"> 
							<c:if test="${approvalvo.draft_urgent eq '0' || (approvalvo.draft_urgent eq '1' && approvalvo.approval_status ne '결재예정')}">
								<%-- 첨부파일 없는 경우 --%>
								<c:if test="${empty approvalvo.draft_file_name}">
									<c:if test="${approvalvo.approval_status == '결재예정'}">
										<tr>
											<td>${approvalvo.draft_no}</td>
											<td>${approvalvo.parent_dept_name}</td>
											<td>${approvalvo.member_name}</td>
											<td>${approvalvo.draft_form_type}</td>
											<td style="text-align:left;"><i class="fa-solid fa-bell fa-shake" style="color: #f68b1f;"></i>&nbsp;&nbsp;${approvalvo.draft_subject}</td>
											<td>
												<c:if test="${approvalvo.draft_status == '진행중'}">
													<span style="border: solid 1px #28a745; border-radius: 5px; padding: 6.5px; background-color: #28a745; color: white;">${approvalvo.draft_status}</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '반려완료'}">
													<span style="border: solid 1px #dc3545; border-radius: 5px; padding: 6.5px 13px; background-color: #dc3545; color: white;">반려</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '승인완료'}">
													<span style="border: solid 1px #17a2b8; border-radius: 5px; padding: 6.5px 13px; background-color: #17a2b8; color: white;">승인</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '대기'}">
													<span style="border: solid 1px #ffc107; border-radius: 5px; padding: 6.5px 13px; background-color: #ffc107; color: white;">대기</span>
												</c:if>	
											</td>
											<td>${approvalvo.draft_write_date}</td>
										</tr>
									</c:if>
									<c:if test="${approvalvo.approval_status != '결재예정'}">
										<tr style="background-color: #f1f9f7;">
											<td>${approvalvo.draft_no}</td>
											<td>${approvalvo.parent_dept_name}</td>
											<td>${approvalvo.member_name}</td>
											<td>${approvalvo.draft_form_type}</td>
											<td style="text-align:left;"><i class="fa-solid fa-bell fa-shake" style="color: #f68b1f;"></i>&nbsp;&nbsp;${approvalvo.draft_subject}</td>
											<td>
												<c:if test="${approvalvo.draft_status == '진행중'}">
													<span style="border: solid 1px #28a745; border-radius: 5px; padding: 6.5px; background-color: #28a745; color: white;">${approvalvo.draft_status}</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '반려완료'}">
													<span style="border: solid 1px #dc3545; border-radius: 5px; padding: 6.5px 13px; background-color: #dc3545; color: white;">반려</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '승인완료'}">
													<span style="border: solid 1px #17a2b8; border-radius: 5px; padding: 6.5px 13px; background-color: #17a2b8; color: white;">승인</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '대기'}">
													<span style="border: solid 1px #ffc107; border-radius: 5px; padding: 6.5px 13px; background-color: #ffc107; color: white;">대기</span>
												</c:if>	
											</td>
											<td>${approvalvo.draft_write_date}</td>
										</tr>
									</c:if>
								</c:if>	
								<%-- 첨부파일 있는 경우 --%>
								<c:if test="${not empty approvalvo.draft_file_name}">
									<c:if test="${approvalvo.approval_status == '결재예정'}">
										<tr>
											<td>${approvalvo.draft_no}</td>
											<td>${approvalvo.parent_dept_name}</td>
											<td>${approvalvo.member_name}</td>
											<td>${approvalvo.draft_form_type}</td>
											<td style="text-align:left;">${approvalvo.draft_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color: #cb2525;"></i></td>
											<td>
												<c:if test="${approvalvo.draft_status == '진행중'}">
													<span style="border: solid 1px #28a745; border-radius: 5px; padding: 6.5px; background-color: #28a745; color: white;">${approvalvo.draft_status}</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '반려완료'}">
													<span style="border: solid 1px #dc3545; border-radius: 5px; padding: 6.5px 13px; background-color: #dc3545; color: white;">반려</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '승인완료'}">
													<span style="border: solid 1px #17a2b8; border-radius: 5px; padding: 6.5px 13px; background-color: #17a2b8; color: white;">승인</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '대기'}">
													<span style="border: solid 1px #ffc107; border-radius: 5px; padding: 6.5px 13px; background-color: #ffc107; color: white;">대기</span>
												</c:if>	
											</td>
											<td>${approvalvo.draft_write_date}</td>
										</tr>
									</c:if>	
									<c:if test="${approvalvo.approval_status != '결재예정'}">
										<tr style="background-color: #f1f9f7;">
											<td>${approvalvo.draft_no}</td>
											<td>${approvalvo.parent_dept_name}</td>
											<td>${approvalvo.member_name}</td>
											<td>${approvalvo.draft_form_type}</td>
											<td style="text-align:left;">${approvalvo.draft_subject}&nbsp;<i class="fa-solid fa-paperclip" style="color: #cb2525;"></i></td>
											<td>
												<c:if test="${approvalvo.draft_status == '진행중'}">
													<span style="border: solid 1px #28a745; border-radius: 5px; padding: 6.5px; background-color: #28a745; color: white;">${approvalvo.draft_status}</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '반려완료'}">
													<span style="border: solid 1px #dc3545; border-radius: 5px; padding: 6.5px 13px; background-color: #dc3545; color: white;">반려</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '승인완료'}">
													<span style="border: solid 1px #17a2b8; border-radius: 5px; padding: 6.5px 13px; background-color: #17a2b8; color: white;">승인</span>
												</c:if>	
												<c:if test="${approvalvo.draft_status == '대기'}">
													<span style="border: solid 1px #ffc107; border-radius: 5px; padding: 6.5px 13px; background-color: #ffc107; color: white;">대기</span>
												</c:if>	
											</td>
											<td>${approvalvo.draft_write_date}</td>
										</tr>
									</c:if>	
								</c:if>	
							</c:if>
						</c:forEach>
					</c:if>
					<c:if test="${empty requestScope.pendingList}">	
						<tr>
							<td colspan="7">결재 예정인 문서가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			
			<c:if test="${not empty requestScope.pendingList}">
				<div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
					${requestScope.pageBar}
				</div>
			</c:if>
		</div>
		
		<form name="detailTempFrm">
			<input type="hidden" name="draft_no" />
		</form>
	</div>
</div>

<jsp:include page="../../footer/footer1.jsp" />    