<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/notice/noticeDetail.css" />

<jsp:include page="../../header/header1.jsp" /> 

<script type="text/javascript">
$(document).ready(function(){  
	
	// 공지사항 삭제하기 
	$("div#noticedelete").on("click", function(){
		
		if(confirm("공지사항을 삭제하시겠습니까?")) {
			
			const notice_no = $("input[name='notice_no']").val();
			const login_userid = $("input[name='login_userid']").val();
		
			// 삭제하기 ajax 
			$.ajax({
				 url:"<%= ctxPath%>/notice/delete",
				 type: "DELETE", 
				 data:{"notice_no":notice_no},
				 dataType: "json",
				 success:function(response){
					 
					 if(response.status == "success") {
						 alert(response.message);
						 window.location.href = "<%= ctxPath%>/notice/list";
					 }
					 else {
						 alert(response.message);
					 }
					 
				 },error: function(error){
					let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
			   		alert(errorMessage);
			 	 }
			});
			
			
		} else {
			alert("공지사항 삭제가 취소되었습니다.")
		}
		
	}); // end of $("div#noticedelete").on("click", function()
			
			
	// 공지사항 삭제기능		
	$("div#noticeupdate").on("click", function(){
		alert("수정기능은 아직입니다 ~ ");
	});
	
});
</script>
	
      <div class="header">
	  		<div class="title">
	  			<span class="title">공지사항</span>
	  			<span class="date">작성부서 
	  			<c:choose>
					<c:when test="${requestScope.noticevo.fk_child_dept_no >= 1 and requestScope.noticevo.fk_child_dept_no <= 7}">
							진료부
						</c:when>
						<c:when test="${requestScope.noticevo.fk_child_dept_no >= 8 and requestScope.noticevo.fk_child_dept_no <= 10}">
							간호부
						</c:when>
						<c:when test="${requestScope.noticevo.fk_child_dept_no >= 11 and requestScope.noticevo.fk_child_dept_no <= 13}">
							경영지원부
						</c:when>
					</c:choose>
	  			</span>
	  		</div>
	  		<div class="viewcnt">
				<span class="writedate">${requestScope.noticevo.notice_write_date} </span>
	  									조회수 ${requestScope.noticevo.notice_view_cnt}
  			</div>
      </div>
      
      <div class="content">
      	
      	<div class="top">
			<input type="hidden" value="${requestScope.notice_no}" name="notice_no"/>
			<input type="hidden" name="login_userid" value="${sessionScope.loginuser.member_userid}"/>
			
			<div class="notice_title">
	      		<span class="bold mr-3">TITLE</span>
	      		<span class="notice_title">${requestScope.noticevo.notice_title}</span>
			</div>
			<c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.member_userid == requestScope.noticevo.fk_member_userid}">
      			<div class="btn-group" id="dropdown">
			  		<button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			    		<i class="fa-solid fa-ellipsis-vertical"></i>
			  		</button>
			  		<div class="dropdown-menu">
			    		<div class="noticeupdate" id="noticeupdate">수정하기</div>
			    		<div class="noticeupdate" id="noticedelete">삭제하기</div>
	  				</div>
  				</div>
			</c:if>
				
			
      	</div>
      	
      	<div class="bottom">
      		<div class="bold mb-3" >
      				Content
      				<div class="addfile">
      					<c:if test="${requestScope.noticevo.notice_fileName != null}">
      						<span>첨부파일</span>
      						<span><a href="<%= ctxPath%>/notice/download?notice_no=${requestScope.noticevo.notice_no}">${requestScope.noticevo.notice_orgFilename}</a></span>
      					</c:if>
      					<c:if test="${requestScope.noticevo.notice_fileName == null}">
      						${requestScope.noticevo.notice_orgFilename}
      					</c:if>
      				</div>
      		</div>
      		<div>
      			 <p class="notice_content">
      			 	${requestScope.noticevo.notice_content}
				 <p>
      		</div>
      		<div class="notice_dept">
      			<span>공지대상
      				<c:choose>
					<c:when test="${requestScope.noticevo.notice_dept eq 0}">
							전체
						</c:when>
						<c:when test="${requestScope.noticevo.notice_dept eq 1}">
							진료부
						</c:when>
						<c:when test="${requestScope.noticevo.notice_dept eq 2}">
							간호부
						</c:when>
						<c:when test="${requestScope.noticevo.notice_dept eq 3}">
							원무과
						</c:when>
					</c:choose>

      			</span>
      		</div>
      	</div>
      	
      </div>
      
      <div class="button">
      	<button type="button" class="btn backbtn" onclick="location.href='<%= ctxPath%>/notice/list'">목록으로</button>
      </div>
  
<jsp:include page="../../footer/footer1.jsp" />   