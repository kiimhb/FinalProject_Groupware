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


<style>
	
	div.writeContainer {
		border: solid 1px red;
		width: 95%;
		margin: auto;
		margin-top: 2%;
	}
	
	div#draft {
	    width: 100% !important;
	    margin: auto;
	    overflow: hidden;
	}
	
	h2 {
		margin-left: 2%;
		margin-top: 1%;
		margin-bottom: 3%;
	}
	
	button#btnType {
		float: left;
		margin-left: 2%;
	}
	
	span#btnRight {
	    float: right;
	    margin-left: 10px;
	    margin-right: 2%;
	}
	
	div.modal-footer button {
		float: right;
	}
</style>



<script type="text/javascript">
$(document).ready(function(){
	
	<%-- [결재양식선택] 클릭 시 모달 띄우기 --%>
	$("button#btnType").on("click", function(){
		
		// 모달을 띄울 위치
		const container = $("div#modalDraftType");
		
		// 모달 구조
		const modal_popup = `
							<div class="modal fade" id="draftType">
								<div class="modal-dialog modal-lg">
									<div class="modal-content">
										
										<div class="modal-header">
											<h5>결재양식선택</h5>
										</div>
										
										<div class="modal-body">
											<form id="draftTypeFrm">
												<select name="typeSelect" class="form-control">						
													<option value="">양식 선택</option>
													<option value="휴가신청서">휴가신청서</option>
													<option value="지출결의서">지출결의서</option>
													<option value="근무 변경 신청서">근무 변경 신청서</option>
													<option value="출장신청서">출장신청서</option>
												</select>
											</form>
										</div>
										
										<div id="draftFormExample">
										</div>
										
										<div class="modal-footer">
											<button type="button" class="btn btn-primary" onclick="goWrite()">작성하기</button>
											<button type="button" class="btn btn-secondary" id="btn_cancel" data-dismiss="modal">취소</button>
										</div>
									</div>
								</div>
							</div>
							`;
		
		// 모달 띄우기
		container.html(modal_popup);
		$("div#draftType").modal('show');
		
		// ==== 양식 선택에 따라 해당 양식의 예시를 보여주는 이벤트 ==== //
		$("select[name='typeSelect']").on("change", function(){
			
			const typeSelect = $("select[name='typeSelect']").val();
			const draftFormExample = $("div#draftFormExample");
			
			if(typeSelect=="") {
				draftFormExample.html("");
			}
			else {

				switch (typeSelect) {
					case "휴가신청서":
						draftFormExample.load("<%= ctxPath%>/approval/dayLeaveForm");
						break;
					case "지출결의서":
						draftFormExample.load("<%= ctxPath%>/approval/expenseReportForm");
						break;
					case "근무 변경 신청서":
						draftFormExample.load("<%= ctxPath%>/approval/workChangeForm");
						break;
					case "출장신청서":
						draftFormExample.load("<%= ctxPath%>/approval/businessTripForm");
						break;
				}

			}
			
		});// end of $("select#typeSelect").on("change", function(){})---------------
		
	});// end of $("button#btnType").on("click", function(){})-------
	
	
});// end of $(document).ready(function(){})----------------



/////////////////////////////////
// >>>> **** 함수 정의 **** <<<< //
////////////////////////////////

// ==== 선택한 기안문 양식을 불러오는 함수 ==== //
function goWrite() {
	
	// 선택한 양식
	const typeSelect = $("select[name='typeSelect']").val();
	
	if(typeSelect=="") {
		swal('기안문 양식을 선택해주세요!');
		return;
	}
	else {
	
		<%--
		if(typeSelect == "휴가신청서") {
			
		}
		else if(typeSelect == "지출결의서") {
			
		}
		else if(typeSelect == "근무 변경 신청서") {
					
		}
		else if(typeSelect == "출장신청서") {
			
		}
		--%>
		
		$.ajax({
			url: "<%= ctxPath%>/approval/writeDraft",
			data: {"typeSelect":typeSelect},
			type: "get",
			success: function(draftForm) {
				
				$("button#btn_cancel").trigger('click');
				
				$("div#draft").html(draftForm);
			},
			error: function() {
				swal('양식 가져오기 실패!',"다시 시도해주세요",'warning');
			}
			
		});
	}
	
}
</script>


<%-- ===================================================================== --%>
<div class="writeContainer">
	<h2>기안문작성</h2>
	
	<button type="button" id="btnType">결재양식선택</button>
	
	<span id="btnRight">
		<button type="button" id="btnSaved">임시저장</button>
		<button type="button" id="btnLine">결재선지정</button>
		<button type="button" id="btnRequest">결재요청</button>
	</span>
	
	<div id="modalDraftType"></div>
	
	<div id="draft" style="margin: auto;"></div>
	
</div>




	
<jsp:include page="../../footer/footer1.jsp" />    