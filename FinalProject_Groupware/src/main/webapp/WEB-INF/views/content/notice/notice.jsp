<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/notice/notice.css" />

<jsp:include page="../../header/header1.jsp" /> 

<script type="text/javascript">
$(document).ready(function(){  
	
	// 모달에 fk_member_userid 값 넘겨주기 (input 태그 hidden 처리)
	$("div#noticeWrite").on('show.bs.modal', function(e){
		
		const button = $(e.relatedTarget);
		const fk_member_userid = button.data("id");
		
		const modal = $(this);
		modal.find("input[name='fk_member_userid']").val(fk_member_userid);
	});
	
	
	// 모달창으로 공지글 작성하기 (글 작성하기)
	$("button.noticeWrite").on("click", function(){
		
		if(confirm("공지사항을 작성 하시겠습니까?")) {
			
			const checkbox = $("input[name='notice_fix']");

			if(checkbox.prop("checked")) {
				checkbox.val("1"); // 체크 되었다면 value 값을 1로 설정한다.
			};
			
			// 폼(form)을 전송(submit)
		    const frm = document.writeNoticeFrm;
		    frm.method = "post";
		    frm.action = "<%= ctxPath%>/notice/write";
		    frm.submit();
		}
		else {
			alert("공지사항 작성이 취소되었습니다.")
		}

	});


});

// 공지사항 디테일 페이지로 이동
function detailNotice(notice_no) {
	// alert(notice_no);	
	window.location.href = `<%= ctxPath%>/notice/detail/\${notice_no}`;
}

</script>
<div id="sub_mycontent">	
      <div class="header">
      		
	  		<div class="title">
	  			<span class="title">공지사항</span>
	  			<span class="sub">총 <span class="cnt">${requestScope.totalCount}</span>건의 공지가 있습니다.</span>
	  		</div>
	  		<form name="writeNoticeFrm" enctype="multipart/form-data">
	  				
		  			<c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.member_grade == 5}"> 
				  		<div class="notice_write">
				  			<button type="button" class="btn" data-toggle="modal" data-id="${requestScope.fk_member_userid}" data-target="#noticeWrite"><i class="fa-solid fa-pen mr-2"></i>작성하기</button>
				  		</div>
			  		</c:if>	
						
			  		<!-- modal 만들기 시작 -->
					<div class="modal fade" id="noticeWrite" data-backdrop="static">
						<div class="modal-dialog modal-dialog-centered modal-xl">
						  <div class="modal-content">
							<!-- Modal header -->
							<div class="modal-header">
							  <h5 class="modal-title">공지사항 작성하기</h5>
							  <button type="button" class="close" data-dismiss="modal">&times;</button>
							</div>
							<!-- Modal body -->
							<div class="modal-body">
							<div class="noticeInput">
								<div class="modal_header">
									<div class="subtitle">공지대상부서</div>
									<input type="hidden" name="fk_member_userid"/>
									<select class="notice_dept" name="notice_dept">
										<option value="0">전체</option>
										<option value="1">진료과</option>
										<option value="2">간호과</option>
										<option value="3">경영지원부</option>
									</select>
									</div>
									
									<div class="modal_title">
										<div class="subtitle">제목</div>
										<input type="text" class="input" name="notice_title">
									</div>
									
									<div class="modal_content">
										<div class="subtitle">내용</div>
										<textarea rows="13" cols="92" class="content" name="notice_content"></textarea>
									</div>
									
									<div class="modal_file">
										<div class="subtitle">첨부파일</div>
										<input type="file" class="file" name="attach" />
									</div>
									
									<div class="modal_fixcheck">
										<div class="subtitle">고정글여부</div>
										<input type="checkbox" class="fix" name="notice_fix" value="0"/>
									</div>
								</div>
								
							</div>
							<!-- Modal footer -->
							<div class="modal-footer">
							  <button type="button" class="noticeWrite btn">작성하기</button>
							  <button type="button" class="btn btn-dark" data-dismiss="modal">Close</button>
							</div>
						  </div>
						</div>
					</div>
				<!-- modal 만들기 끝 -->
		 	</form>			
      	</div>
	
      
	      <div class="notice">
	      
	      	<div class="article">
	      		<c:if test="${not empty requestScope.notice_list}" > 
			      	<c:forEach var="nvo" items="${requestScope.notice_list}">
			      		<div class="one_row" data-id="${nvo.notice_fix}" onclick="detailNotice(`${nvo.notice_no}`)">
			      			
			      			<div class="article_main">
			      			
		      					<div class="article_title" style="${nvo.notice_fix eq '1' ? 'color:black; font-weight:bold;' : ''}"><c:choose>
								<c:when test="${nvo.notice_dept eq 0}">
									[전체]
								</c:when>
								<c:when test="${nvo.notice_dept eq 1}">
									[진료부]
								</c:when>
								<c:when test="${nvo.notice_dept eq 2}">
									[간호부]
								</c:when>
								<c:when test="${nvo.notice_dept eq 3}">
									[원무과]
								</c:when>
							</c:choose>${nvo.notice_title}
		      						<c:if test="${not empty nvo.notice_fileName}">
				      						<i class="fa-solid fa-paperclip" style="color:#509d9c;"></i>
			      					</c:if>
		      					</div>
			      				
		      					<div class="fix">
		      						<c:if test="${nvo.notice_fix eq '1'}"><i class="fa-solid fa-thumbtack"></i></c:if> 
		      					</div>
			      				
		      				</div>	
		      				
			      			<div class="article_info">${nvo.notice_write_date}
			      			<c:choose>
								<c:when test="${nvo.fk_child_dept_no >= 1 and nvo.fk_child_dept_no <= 7}">
									<td>진료부</td>
								</c:when>
								<c:when test="${nvo.fk_child_dept_no >= 8 and nvo.fk_child_dept_no <= 10}">
									<td>간호부</td>
								</c:when>
								<c:when test="${nvo.fk_child_dept_no >= 11 and nvo.fk_child_dept_no <= 13}">
									<td>경영지원부</td>
								</c:when>
							</c:choose>
			      			</div> 		
		      			</div>
			   		</c:forEach>
		   		</c:if>
		   		<c:if test="${empty requestScope.notice_list}" > 
		   			<div class="one_row">
		   				등록된 공지사항이 없습니다.
		   			</div>	
		   		</c:if>
	      	</div>
	      </div>
	      
	      
	      <%-- 페이지바 === --%>
	      <c:if test="${not empty requestScope.notice_list}" > 
	      		<div align="center" id="pageBar" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
					${requestScope.pageBar}
	   	   		</div>
	   	   </c:if>
	   	   <c:if test="${empty requestScope.notice_list}" > 
	   	   		
	   	   </c:if>
</div>
  	
<jsp:include page="../../footer/footer1.jsp" />   