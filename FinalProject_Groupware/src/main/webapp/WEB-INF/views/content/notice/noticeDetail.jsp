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
	
	// 수정 모달폼
	modalId = "#noticeUpdate";
	modal = $(modalId); // 모달 id
	
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
					 
				 }, error: function(error){
					let errorMessage = error.responseJSON?.message || "삭제 중 오류가 발생했습니다.";
			   		alert(errorMessage);
			 	 }
			});
			
			
		} else {
			alert("공지사항 삭제가 취소되었습니다.")
		}
		
	}); // end of $("div#noticedelete").on("click", function()
			
			
	// 공지사항 수정하기 모달창 오픈
	$("div.noticeupdate").on("click", function(){
		
		$("#noticeUpdate").modal("show"); // 모달 열기
		
		// 공지대상부서 
		const notice_dept_val = $("input#notice_dept").val(); // 공지대상부서
		let content_val = $("textarea[name='notice_content']").val();

		if(notice_dept_val == 0) {
			$("select[name='notice_dept']").val("0");
		}
		else if(notice_dept_val == 1) {
			$("select[name='notice_dept']").val("1");
		}
		else if(notice_dept_val == 2) {
			$("select[name='notice_dept']").val("2");
		}
		else if(notice_dept_val == 3) {
			$("select[name='notice_dept']").val("3");
		}
		
		// 고정글 여부
		const fix = $("input.fix").val(); // 고정여부
		
		if(fix == 1) {
			$("input.fix").prop("checked", true); // 고정글 여부가 1이면 체크되어지도록
		}
		
		content_val = content_val.replace(/<br\s*\/?>/g, "\n");  // 공백(&nbsp;)을 "" 으로 변환
		$("textarea[name='notice_content']").val(content_val);   // 변환값을 다시 입력하기
		
		
		// 수정하기 클릭
		$("button.noticeUpdate").on("click", function(){
			
			const checkbox = $("input.fix").prop("checked"); // 체크여부 true, false
			
			// checkbox 상태에 따른 value 값 설정해주기
			if(checkbox) { // 체크 해제된 상태
				$("input.fix").val(1);
			}
			else {
				$("input.fix").val(0);
			}
					
			alert("공지사항을 수정하시겠습니까?");
			
			const notice_no = $("input[name='notice_no']").val();
			const notice_dept = $("select.notice_dept").val();
			const notice_title = $("input[name='notice_title']").val();
			const notice_content = $("textarea[name='notice_content']").val();
			const notice_fix = $("input[name='notice_fix']").val();
			
			$.ajax({
				url:"<%= ctxPath%>/notice/notice_update",
				type: "PATCH", 
				data:{"notice_no": notice_no,
					  "notice_dept":notice_dept,
					  "notice_title":notice_title,
					  "notice_content":notice_content,
					  "notice_fix":notice_fix},
				dataType: "json",
			    success:function(response){	
			        	
			    	if(response.status == "success") { // controller 에서 수정이 성공된 상태를 나타낸다. 
						 alert(response.message);
						 window.location.href = `<%= ctxPath%>/notice/detail/\${notice_no}`;
					 }
					 else { // controller 에서 수정이 실패된 상태를 나타낸다. 
						 alert(response.message);
					 }
			    	
			    }, error: function(error){
					let errorMessage = error.responseJSON?.message || "예약 중 오류가 발생했습니다.";
			   		alert(errorMessage);
			    }
			});
		});
	});
	
	$("#noticeUpdate").on("hidden.bs.modal", function () {
        $(".modal-backdrop").remove(); // 백드롭 제거
        	$("body").removeClass("modal-open"); // body에 남아 있는 모달 효과 제거
    });
	
});
</script>
<div id="sub_mycontent">	
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
	      		<span class="notice_title">
	      			<c:choose>
					<c:when test="${requestScope.noticevo.notice_dept eq 0}">
							[전체]
						</c:when>
						<c:when test="${requestScope.noticevo.notice_dept eq 1}">
							[진료부]
						</c:when>
						<c:when test="${requestScope.noticevo.notice_dept eq 2}">
							[간호부]
						</c:when>
						<c:when test="${requestScope.noticevo.notice_dept eq 3}">
							[원무과]
						</c:when>
					</c:choose>
	      		 ${requestScope.noticevo.notice_title}</span>
			</div>
			
			<!--작성자 본인만 수정 및 삭제가 가능하다 -->
			<c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.member_userid == requestScope.noticevo.fk_member_userid}">
      			<div class="btn-group" id="dropdown">
			  		<button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			    		<i class="fa-solid fa-ellipsis-vertical"></i>
			  		</button>
			  		<div class="dropdown-menu">
			    		<div id="noticeupdate" class="noticeupdate" data-toggle="modal" data-id="${requestScope.notice_no}" data-target="#noticeUpdate">수정하기</div>
			    		<div class="noticedelete" id="noticedelete">삭제하기</div>
	  				</div>
  				</div>
			</c:if>
			
			<!-- modal 만들기 시작 -->
			<div class="modal fade" id="noticeUpdate" data-backdrop="static">
				<div class="modal-dialog modal-dialog-centered modal-xl">
				  <div class="modal-content">
					<!-- Modal header -->
					<div class="modal-header">
					  <h5 class="modal-title">공지사항 수정하기</h5>
					  <button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>
					<!-- Modal body -->
					<div class="modal-body">
					<div class="noticeInput">
						<div class="modal_header">
							<div class="subtitle">공지대상부서</div>
							<input type="hidden" id="notice_dept" value="${requestScope.noticevo.notice_dept}" />
							<select class="notice_dept" name="notice_dept">
								<option value="0">전체</option>
								<option value="1">진료과</option>
								<option value="2">간호과</option>
								<option value="3">경영지원부</option>
							</select>
							</div>
							
							<div class="modal_title">
								<div class="subtitle">제목</div>
								<input type="text" class="input" name="notice_title" value="${requestScope.noticevo.notice_title}">
							</div>
							
							<div class="modal_content">
								<div class="subtitle">내용</div>
								<textarea rows="13" cols="92" class="content" name="notice_content">${requestScope.noticevo.notice_content}</textarea>
							</div>	
							
							<div class="modal_fixcheck">
								<div class="subtitle">고정글여부</div>
								<input type="checkbox" class="fix" name="notice_fix" value="${requestScope.noticevo.notice_fix}" />
							</div>
						</div>
						
					</div>
					<!-- Modal footer -->
					<div class="modal-footer">
					  <button type="button" class="noticeUpdate btn">수정하기</button>
					  <button type="button" class="btn btn-dark" data-dismiss="modal">Close</button>
					</div>
				  </div>
				</div>
			</div>
			<!-- modal 만들기 끝 -->
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
      	</div>
      	
      </div>
      
      <div class="button">
      	<button type="button" class="btn backbtn" onclick="location.href='<%= ctxPath%>/notice/list'">목록으로</button>
      </div>
</div>	  

	  		
  
<jsp:include page="../../footer/footer1.jsp" />   