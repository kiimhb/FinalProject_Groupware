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
		margin-left: 4%;
		margin-top: 4%;
		margin-bottom: 3%;
		font-weight: bold;
		letter-spacing: 4px !important;
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
	
	div.modalDraftType button {
		float: right;
	}
	
	<%-- 결재선 모달 --%>
	.custom-modal-size {
		max-width: 650px !important;
	}
	
	<%-- 결재선/참조자 >> 버튼 able 효과 --%>
	.insertBtn.able {
		color: black;
		cursor: pointer;
	}
	
	.insertBtn.able:hover {
		color: #006709;
	}
	
	<%-- 결재선/참조자 << 버튼 able 효과 --%>
	.deleteBtn.able,
	#referLeftBtn.able,
	#lineLeftBtn.able {
		color: black;
		cursor: pointer;
	}
	.deleteBtn.able:hover,
	#referLeftBtn.able,
	#lineLeftBtn.able {
		color: #f68b1f;
	}

	
	<%-- 결재선/참조자 >> 버튼 disable 효과 --%>
	.insertBtn.disabled {
	    color: #ccc;
	    cursor: not-allowed;
	}
	
	.insertBtn.disabled {
	    color: #ccc;
	    cursor: not-allowed;
	}
	
	<%-- 결재선/참조자 << 버튼 disable 효과 --%>
	.deleteBtn.disabled {
	    color: #ccc;
	    cursor: not-allowed;
	}
	
	.insertBtn.disabled {
	    color: #ccc;
	    cursor: not-allowed;
	}
	
	<%-- 결재선목록/참조자목록 선택 효과 --%>
	tr.referenceMember_V,
	tr.approvalMember_V {
		cursor: pointer;
	}
	
	tr.referenceMember_V:hover,
	tr.approvalMember_V:hover {
		background-color: #eee;
	}
</style>



<script type="text/javascript">
let arr_approvalLineMembers = [];	// 결재선에 추가된 멤버
let arr_referenceMembers = [];		// 참조자에 추가된 멤버
	
$(document).ready(function(){
	
	<%-- 결재양식선택 전엔 상단 버튼 감추기 --%>
	$("button#btnSaved").hide();
	$("button#btnLine").hide();
	$("button#btnRequest").hide();
	
	////////////////////////////////////////////////////////////////////////////////

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
										
										<div class="modal-footer modalDraftType">
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
		
		// 모달 닫힌 후 상단 버튼 보이기
		$('div#draftType').on('hidden.bs.modal', function () {
			$("button#btnSaved").show();
			$("button#btnLine").show();
			$("button#btnRequest").show();
		});
		
	});// end of $("button#btnType").on("click", function(){})-------
	
	////////////////////////////////////////////////////////////////////////////////
	
	
	<%-- 임시저장목록에서 기안문 클릭시 기존 작성했던 정보 불러오기 --%>
	if(${not empty requestScope.approvalvo}) {

		const typeSelect = "${requestScope.approvalvo.draft_form_type}";
		
		$.ajax({
			url: "<%= ctxPath%>/approval/writeDraftTemp",
			data: {"typeSelect":typeSelect},
			type: "get",
			success: function(draftForm) {
				
				$("div#draft").html(draftForm);
				
				// 상단 저장/결재선/결재요청 버튼 보이기
				$("button#btnSaved").show();
				$("button#btnLine").show();
				$("button#btnRequest").show();
				
				// 기안문 형식 udate 로 변경
				$("input[id='draftMode']").val("update");
				
				// >>> 기존의 값 기안문에 채워넣기 <<< //
				// 1. 문서정보
				$("td#member_name").text("${requestScope.approvalvo.member_name}");					// 기안자
				$("td#parent_dept_name").text("${requestScope.approvalvo.parent_dept_name}");		// 부문
				$("td#child_dept_name").text("${requestScope.approvalvo.child_dept_name}");			// 부서
				$("td#member_position").text("${requestScope.approvalvo.member_position}");			// 직책
				$("td#draft_no").text("${requestScope.approvalvo.draft_no}");						// 문서번호
				
				// 2. 문서 내용
				$("input[name='draft_subject']").val("${requestScope.approvalvo.draft_subject}"); // 제목
				
				if(${requestScope.approvalvo.draft_urgent eq "1"}) {	
					$("input[name='draft_urgent']").prop("checked", true);	// 긴급여부
				}
				
				if(${requestScope.approvalvo.draft_form_type eq "휴가신청서"}) {
					
					setTimeout(function() {
				        // 기존 라디오 버튼 해제
				        $("input:radio[name='dayLeave']").prop("checked", false);

				        // 조건에 맞는 라디오 버튼을 체크
				        if (${requestScope.approvalvo.day_leave_cnt eq "0.5"}) {
				            $("input:radio[id='amDay']").prop("checked", true);	// 반차
							
							$("div#halfDay").css({"display":"block"});
							$("div#allDay").css({"display":"none"});
										
							$("input[name='halfDay_leave_end']").val("${requestScope.approvalvo.day_leave_start}");	// 반차사용일
				        } else {
				            $("input:radio[id='allDay']").prop("checked", true); // 연차
							
							$("div#halfDay").css({"display":"none"});
							$("div#allDay").css({"display":"block"});	
										
							$("input[name='allDay_leave_start']").val("${requestScope.approvalvo.day_leave_start}");  // 연차시작일
							$("input[name='allDay_leave_end']").val("${requestScope.approvalvo.day_leave_end}");	  // 연차종료일
				        }
				    }, 0);
					
					$("span#day_leave_cnt").text("${requestScope.approvalvo.day_leave_cnt}");
					
					const temp_day_leave_reason = "${requestScope.approvalvo.day_leave_reason}";
					$("textarea[name='day_leave_reason']").text(temp_day_leave_reason.replace(/<br\s*\/?>/gi, '\n'));	// 휴가사유
					$('textarea').trigger('keyup');	// 글자수 세는 함수를 불러오기 위함
				}
				
				// 기존 첨부파일 가져오기
				if(${not empty requestScope.approvalvo.draft_file_name}) {
					setTimeout(function() {
						const draft_file_origin_name = "${requestScope.approvalvo.draft_file_origin_name}";
						const draft_file_size = "${requestScope.approvalvo.draft_file_size}";
						const draft_file_url = "<%= ctxPath%>/resources/draft/" + "${requestScope.approvalvo.draft_file_name}"; // 파일 경로
						
						const fileInput = $("input[id='fileInput']")[0]; // 첫 번째 file input 요소 가져오기
						
						// File 객체 생성 (기존 파일을 URL로 가져와서 파일 객체로 생성)
						fetch(draft_file_url)
			            	.then(response => response.blob())
			            	.then(blob => {
			            		// Blob으로 파일 객체 생성
			            		const file = new File([blob], draft_file_origin_name, { type: blob.type });
			            		
			            		// DataTransfer 객체 생성
			                    const dataTransfer = new DataTransfer();
			            		
			                 	// 파일을 DataTransfer에 추가
			                    dataTransfer.items.add(file);

			                    // 파일을 input[type="file"]의 files 속성에 추가
			                    fileInput.files = dataTransfer.files;
			            	})
			            	.catch(error => {
				                console.error("파일을 로드하는 중 오류 발생:", error);
				            });
						
						let html = `<div style="display: flex; height: 35px;"><span style="padding-top: 5px; padding-left: 2%;"><i class="fa-solid fa-paperclip"></i>&nbsp;\${draft_file_origin_name}</span><span id="fileSize" style="margin-left: auto; padding-top: 5px; padding-right: 4%;">\${draft_file_size}KB</span><i id="fileDel" class="fa-regular fa-rectangle-xmark" style="margin: auto 1%;">&nbsp;</i></div>`;
	
					    // 기존 파일을 fileAdd에 추가
						const fileZone =  $("label#fileLabel");
						const fileAdd = $("div#fileAdd").hide();
						fileZone.hide();
						fileAdd.append(html).show();
					}, 0);
				}

				<%-- 결재선/참조자 목록 불러오기 --%>
				getTempApprovalRefer("${requestScope.approvalvo.draft_no}");		
			},
			error: function() {
				swal('양식 불러오기 실패!',"다시 시도해주세요",'error');
			}
			
		});
	}

	
	
});// end of $(document).ready(function(){})----------------


////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////
// >>>> **** 함수 정의 **** <<<< //
////////////////////////////////

<%-- ==== 임시저장한 내용 중 결재선/참조자 목록 불러오기 ==== --%>
function getTempApprovalRefer(draft_no) {
	
	$.ajax({
		url: "<%= ctxPath%>/approval/getTempApprovalRefer",
		data: {"draft_no":draft_no},
		type: "get",
		success: function(json) {

			$.each(json, function(index, item){	
				if(item.approval_step != "0") {
					arr_approvalLineMembers.push(item.fk_member_userid);
				}
				else if(item.approval_step == "0") {
					arr_referenceMembers.push(item.fk_member_userid);
				}
			});

			if(arr_approvalLineMembers.length > 0) {
				func_goAddLine();
			}
			
		},
		error: function() {
			Swal.fire({
			    icon: 'error',
			    title: '양식 불러오기 실패!',
			    text: '다시 시도해주세요.'
			});
		}
	});
	
}// end of function getTempApprovalRefer(draft_no) {}------------------------

////////////////////////////////////////////////////////////////////////////////////////
<%-- ==== 선택한 기안문 양식을 불러오는 함수 ==== --%>
function goWrite() {
	
	// 선택한 양식
	const typeSelect = $("select[name='typeSelect']").val();
	
	if(typeSelect=="") {
		swal('기안문 양식을 선택해주세요!');
		return;
	}
	else {
		
		$.ajax({
			url: "<%= ctxPath%>/approval/writeDraft",
			data: {"typeSelect":typeSelect},
			type: "get",
			success: function(draftForm) {
				
				$("button#btn_cancel").trigger('click');
				
				$("div#draft").html(draftForm);
			},
			error: function() {
				swal('양식 불러오기 실패!',"다시 시도해주세요",'error');
			}
		});
	}
	
}// end of function goWrite() {}------------------------------


////////////////////////////////////////////////////////////////////////////////////////
<%-- ==== 결재선지정 버튼 클릭 함수 ==== --%>
function setApprovalLine() {

	console.log(arr_approvalLineMembers);
	console.log(arr_referenceMembers);
	
	
	// 모달을 띄울 위치
	const container = $("div#approvalLine");
	
	// 모달 구조
	const modal_popup = `
						<div class="modal fade" id="selectApprovalLine">
							<div class="modal-dialog custom-modal-size">
						    	<div class="modal-content" style="display: flex; flex-direction: column; height: 100%;">
						    
							      	<!-- Modal Header -->
							      	<div class="modal-header">
							        	<h3>결재선지정</h3>
							      	</div>
					
							      	<!-- Modal Body -->
							      	<div class="modal-body" style="border: solid 1px blue; display: flex; flex-wrap: wrap; flex: 1; overflow-y: auto;">
							        	<div style="border: solid 1px gray; border-radius: 3px; flex: 4; height: 450px; overflow: auto;">
							        		<div id="treeView" style="margin: 0 0 5% 2%; "></div>
							        	</div>
							        	<div id="selectDiv" style="border: solid 1px gray; flex: 1; font-size: 19pt;">
							        		<div id="btnTop" style="display: flex; flex-direction: column; justify-content: center; margin-top: 85px; align-items: center;">
								        		<span class="insertBtn" id="lineRightBtn"><i class="fa-solid fa-angles-right"></i></span>
								        		<span class="deleteBtn" id="lineLeftBtn"><i class="fa-solid fa-angles-left"></i></span>
							        		</div>
							        		<div id="btnBottom" style="display: flex; flex-direction: column; justify-content: center; margin-top: 150px; align-items: center;">
								        		<span class="insertBtn" id="referRightBtn"><i class="fa-solid fa-angles-right"></i></span>
								        		<span class="deleteBtn" id="referLeftBtn"><i class="fa-solid fa-angles-left"></i></span>
							        		</div>
							        	</div>
							        <div id="selectMember" style="border: solid 1px red; flex: 5; padding-top: 3%;">
							          	<div id="modal_rightTop">
							            	<h5>결재선</h5>
							            	<div id="approvalLineMember" style="border: solid 1px gray; border-radius: 3px; height: 150px;">
							            		<table id="approvalLineMember_T" class="table-bordered" style="width: 100%;">
							            			<tr>
							            				<td>부문</td>
							            				<td>부서</td>
							            				<td>직급</td>
							            				<td>성명</td>
							            			</tr>
							            		</table>
							            	</div>
							          	</div>
							          	<div id="modal_rightBottom" style="margin-top: 13%;">
							            	<h5>참조자</h5>
							            	<div id="referenceMember" style="border: solid 1px gray; border-radius: 3px; height: 150px;">
								            	<table id="referenceMember_T" class="table-bordered" style="width: 100%;">
							            			<tr>
							            				<td>부문</td>
							            				<td>부서</td>
							            				<td>직급</td>
							            				<td>성명</td>
							            			</tr>
							            		</table>
							            	</div>
							          	</div>
							        </div>
								</div>
				
				      			<!-- Modal Footer -->
				      			<div class="modal-footer" style="margin-top: auto;">
				        			<button type="button" class="btn btn-primary" id="goAddLine">결재선지정</button>
				        			<button type="button" class="btn btn-secondary" id="btn_madal_cancel" data-dismiss="modal">취소</button>
				      			</div>
					    	</div>
					  	</div>
					</div>`;
	
	// 모달 띄우기
	container.html(modal_popup);
	$("div#selectApprovalLine").modal('show');
	
	// 모달이 띄워지면 aria-hidden 속성을 제거
	$('#selectApprovalLine').on('shown.bs.modal', function () {
	    $(this).removeAttr('aria-hidden');  // aria-hidden="true" 을 제거하여 모달 버튼이나 입력요소 등 접근이 가능하도록 수정
	});
	
	// 조직도 페이지 가져오기
	$("div#treeView").load("<%=ctxPath%>/organization/selectApprovalLine", function() {
        
		// << >> 버튼 모두 비활성화
		$("span.insertBtn").addClass("disabled");
		$("span.deleteBtn").addClass("disabled");
		
		
		<%-- ==================== 기존에 추가했던 결재선/참조자 사원을 목록에 불러오기 시작 ==================== --%>
		if($("table#designated_line_Table tr#approvalLine_1 > td").length > 0 ) {
			// 결재선 목록에 추가한 이력이 있으면

			let span_member_userid = document.querySelectorAll("tr#approvalLine_3 > td > span.span_member_userid");
			
			if($("input[name='draftMode']").val() == 'insert') {
				span_member_userid.forEach(function(item, index, array){
					arr_approvalLineMembers.push(item.textContent);
				});
			}
				
			<%-- ==== 결재선 목록으로 넣기 ==== --%> 				
			$.ajax({
    			url:"<%= ctxPath%>/approval/insertToApprovalLine_Arr",
    			data:{"arr_approvalLineMembers":arr_approvalLineMembers},
    			type:"post",			
    			success:function(json){
    				
       				if(!arr_referenceMembers.includes(json.member_userid) && !arr_approvalLineMembers.includes(json.member_userid)){
       					// 결재선 및 참조자 목록에 없는 사원일 경우만 목록에 추가
       					
       					$.each(json, function(index, item){
  
            				let html = `<tr class="approvalMember_V">
               							 	<td>\${item.parent_dept_name}</td>
               							 	<td>\${item.child_dept_name}</td>
               							 	<td>\${item.member_position}</td>
               							 	<td>\${item.member_name}</td>
               							 </tr>`;
	 
       						$("table#approvalLineMember_T").append(html);		
       					});
       				}
       				else {
       					swal('이미 선택된 사원입니다.',"다시 시도해주세요",'warning');
       				}

    			},
    			error: function() {
					swal('결재선 목록에 추가 실패!',"다시 시도해주세요",'error');
				}
    		});
			
			
			<%-- ==== 참조자 목록에 추가한 이력이 있다면 목록으로 넣기 ==== --%> 	
			if($("table#undesignated_refer_Table tr.referenceMember").length > 0 && arr_referenceMembers.length > 0) {
				
				let span_member_userid = document.querySelectorAll("tr.referenceMember > td span.span_member_userid");

				if($("input[name='draftMode']").val() == 'insert') {
					span_member_userid.forEach(function(item, index, array){
						arr_referenceMembers.push(item.textContent);
					});
				}
					
				$.ajax({
	    			url:"<%= ctxPath%>/approval/insertToReferenceMember_Arr",
	    			data:{"arr_referenceMembers":arr_referenceMembers},
	    			type:"post",			
	    			success:function(json){
	    				
	       				if(!arr_referenceMembers.includes(json.member_userid) && !arr_approvalLineMembers.includes(json.member_userid)){
	       					// 결재선 및 참조자 목록에 없는 사원일 경우만 목록에 추가
	       					
	       					$.each(json, function(index, item){
	  
	            				let html = `<tr class="referenceMember_V">
	               							 	<td>\${item.parent_dept_name}</td>
	               							 	<td>\${item.child_dept_name}</td>
	               							 	<td>\${item.member_position}</td>
	               							 	<td>\${item.member_name}</td>
	               							 </tr>`;
		 
	       						$("table#referenceMember_T").append(html);		
	       					});
	       				}
	       				else {
	       					swal('이미 선택된 사원입니다.',"다시 시도해주세요",'warning');
	       				}

	    			},
	    			error: function() {
						swal('참조자 목록에 추가 실패!',"다시 시도해주세요",'error');
					}
	    		});
			}
			
			
		}// end of if($("table#designated_line_Table tr#approvalLine_1 > td").length > 0 ) {}------------------
		
		<%-- ==================== 기존에 추가했던 결재선/참조자 사원을 목록에 불러오기 끝  ==================== --%>
		
		
        <%-- ==================== 사원 선택 후 결재선/참조자 목록으로 넣는 이벤트 시작 ==================== --%>
        $("div#tree").on("select_node.jstree", function(e, data) {
			
        	// << 버튼 모두 비활성화
        	$("span.deleteBtn").removeClass("able");
        	
        	var member = data.node.data;	// 클릭한 사원의 "data" 객체
        	
        	// 조직도 선택 노드 초기화 (기존 노드 상태 비움)
            $("div#selectDiv span").off("click");  // 기존에 바인딩된 클릭 이벤트 제거
        	
        	if(member != null && member.member_userid) {// 다른 노드가 아닌 사원 노드를 선택했을 경우에만 이벤트 처리
        		
        		const member_userid = member.member_userid;

        		// >> 버튼 활성화
            	$("span.insertBtn").removeClass("disabled");
            	$("span.insertBtn").addClass("able");
            	
            	
        		$("div#selectDiv span").on("click", function(e){
        			
        			if($(this).attr('id') == "lineRightBtn") {
        				
        				<%-- ==== 결재선 목록으로 넣기 ==== --%> 				
        				$.ajax({
                			url:"<%= ctxPath%>/approval/insertToApprovalLine",
                			data:{"member_userid":member_userid},
                			type:"post",			
                			success:function(json){
                				
                				if(arr_approvalLineMembers.length < 3) {
                					// 결재선 목록에 있는 사원이 3명 미만인경우
                					
	                				if(!arr_referenceMembers.includes(member_userid) && !arr_approvalLineMembers.includes(member_userid)){
	                					// 결재선 및 참조자 목록에 없는 사원일 경우만 목록에 추가
	                					arr_approvalLineMembers.push(member_userid);
		                				
		                				let html = `<tr class="approvalMember_V">
			               							 	<td>\${json.parent_dept_name}</td>
			               							 	<td>\${json.child_dept_name}</td>
			               							 	<td>\${json.member_position}</td>
			               							 	<td>\${json.member_name}</td>
			               							 </tr>`;
				 
		           						$("table#approvalLineMember_T").append(html);

	                				}
	                				else {
	                					swal('이미 선택된 사원입니다.',"다시 시도해주세요",'warning');
	                				}
                				}
                				else {
                					// 결재선 목록에 있는 사원이 3명 이상인 경우
                					Swal.fire({
                					    title: '',
                					    html: '<span style="font-size: 20px;">결재선 지정은 3명까지만<br>가능합니다.</span>',
                					    icon: 'warning'
                					});
                				}

                			},
                			error: function() {
            					swal('결재선 목록에 추가 실패!',"다시 시도해주세요",'error');
            				}
                		});
        				
        			}
        			else if($(this).attr('id') == "referRightBtn") {
        				
        				<%-- ==== 참조자 목록으로 넣기 ==== --%> 	
        				$.ajax({
                			url:"<%= ctxPath%>/approval/insertToReference",
                			data:{"member_userid":member_userid},
                			type:"post",			
                			success:function(json){

                				if(arr_referenceMembers.length < 3) {
                					// 참조자 목록에 있는 사원이 3명 미만인경우
                					
	                				if(!arr_referenceMembers.includes(member_userid) && !arr_approvalLineMembers.includes(member_userid)){
	                					// 결재선 및 참조자 목록에 없는 사원일 경우만 목록에 추가
	                					arr_referenceMembers.push(member_userid);
		                				
		                				let html = `<tr class="referenceMember_V">
			               							 	<td>\${json.parent_dept_name}</td>
			               							 	<td>\${json.child_dept_name}</td>
			               							 	<td>\${json.member_position}</td>
			               							 	<td>\${json.member_name}</td>
			               							 </tr>`;
				 
		           						$("table#referenceMember_T").append(html);

	                				}
	                				else {
	                					swal('이미 선택된 사원입니다.',"다시 시도해주세요",'warning');
	                				}
                				}
                				else {
                					// 참조자 목록에 있는 사원이 3명 이상인 경우
                					Swal.fire({
                					    title: '',
                					    html: '<span style="font-size: 20px;">참조자 지정은 3명까지만<br>가능합니다.</span>',
                					    icon: 'warning'
                					});
                				}

                			},
                			error: function() {
            					swal('결재선 목록에 추가 실패!',"다시 시도해주세요",'error');
            				}
                		});
        				
        			}
        			
        		});// end of $("div#selectDiv span").on("click", function(e){})-------------------------------------

        	}
        	else {
        		// >> 버튼 비활성화
            	$("span.insertBtn").removeClass("able");
            	$("span.insertBtn").addClass("disabled");
        	}
        	
        });
        <%-- ==================== 사원 선택 후 결재선/참조자 목록으로 넣는 이벤트 끝  ==================== --%>
        
        
        
        <%-- ==================== 사원 선택 후 결재선 목록에서 제거하는 이벤트 시작 ==================== --%>
        $("table#approvalLineMember_T").on("click", "tr", function(e){

        	// 조직도 선택 노드 초기화 (기존 노드 상태 비움)
            $("div#selectDiv span").off("click");  // 기존에 바인딩된 클릭 이벤트 제거
            
        	// 나머지 버튼 비활성화
        	$("span.insertBtn").removeClass("able");
        	$("span.insertBtn").addClass("disabled");
        	$("span#referLeftBtn").removeClass("able");
        	
        	// << 결재선 버튼 활성화
        	$("span#lineLeftBtn").addClass("able");
        	
        	// 배경색 모두 빼기
        	$("tr.referenceMember_V").css({"background-color":"#fff"});
        	$("tr.approvalMember_V").css({"background-color":"#fff"});
        	
        	if($(this).index() > 0) {
        		// 선택한 직원의 행 색 변경
        		$(this).css({"background-color":"#eee"});
        	}

        	// 선택한 사원의 인덱스 번호
        	const memberIndex = $(this).index();
        	
        	<%-- ==== 결재선 목록에서 빼기 ==== --%> 	
        	$("span#lineLeftBtn").on("click", function(e){
        		$("table#approvalLineMember_T tr").eq(memberIndex).remove();
        		
        		// 배열에서도 제거
        		arr_approvalLineMembers.splice(memberIndex-1,1);
        	});
	
        });// end of $("table#approvalLineMember_T").on("click", function(e){})---------------------- 
        <%-- ==================== 사원 선택 후 결재선 목록에서 제거하는 이벤트 끝  ==================== --%>
        
        
        <%-- ==================== 사원 선택 후 참조자 목록에서 제거하는 이벤트 시작 ==================== --%>
		$("table#referenceMember_T").on("click", "tr", function(e){
        	console.log(arr_referenceMembers);
        	// 조직도 선택 노드 초기화 (기존 노드 상태 비움)
            $("div#selectDiv span").off("click");  // 기존에 바인딩된 클릭 이벤트 제거
            
        	// 나머지 버튼 비활성화
        	$("span.insertBtn").removeClass("able");
        	$("span.insertBtn").addClass("disabled");
        	$("span#lineLeftBtn").removeClass("able");
        	
        	// << 참조자 버튼 활성화
        	$("span#referLeftBtn").addClass("able");
        	
        	// 배경색 모두 빼기
        	$("tr.referenceMember_V").css({"background-color":"#fff"});
        	$("tr.approvalMember_V").css({"background-color":"#fff"});
        	
        	if($(this).index() > 0) {
        		// 선택한 직원의 행 색 변경
        		$(this).css({"background-color":"#eee"});
        	}

        	// 선택한 사원의 인덱스 번호
        	const memberIndex = $(this).index();
        	
        	<%-- ==== 참조선 목록에서 빼기 ==== --%> 	
        	$("span#referLeftBtn").on("click", function(e){
        		$("table#referenceMember_T tr").eq(memberIndex).remove();
        		
        		// 배열에서도 제거
        		arr_referenceMembers.splice(memberIndex-1,1);
        	});
			
			console.log(arr_referenceMembers);
        	
        });// end of $("table#referenceMember_T").on("click", "tr", function(e){})---------------------- 
        <%-- ==================== 사원 선택 후 참조자 목록에서 제거하는 이벤트 끝  ==================== --%>
    });
	
	
	<%-- ==================== 결재선지정 버튼 클릭 이벤트 시작 ==================== --%>
	$(document).on("click", "button[id='goAddLine']", function() {

		func_goAddLine();
	});
	<%-- ==================== 결재선지정 버튼 클릭 이벤트 끝  ==================== --%>
	
}// end of function setApprovalLine() {}------------------------------


function func_goAddLine() {
	
	<%-- ==== 결재선 결재순위 지정 ==== --%> 
	if(arr_approvalLineMembers.length > 0) {
		$.ajax({
			url:"<%= ctxPath%>/approval/orderByApprovalStep",
			data:{"arr_approvalLineMembers":arr_approvalLineMembers},
			type:"post",			
			success:function(json){
				
				// AJAX 요청 성공 후, 취소 버튼 클릭을 강제로 트리거
	            $("button[id='btn_madal_cancel']").click();
	
	            // 모달이 닫힌 후 실행될 작업을 처리
				setTimeout(function(){
		
					// 기존에 회색 박스를 다시 감추고, 결재선 테이블을 보인다.
					$("div#undesignated_line").css({"display":"none"});
					$("table#designated_line_Table").css({"display":"table"});
					
					// 결재선 목록에 추가되는 인원 수에 따라서 width 가 잡히도록 설정.
					$("div#undesignated_line_total").css({"width":"auto"});
					
					// 기존의 결재선 목록을 없앤다.
					$("tr.approvalLine_view").html("");
					
					if($("table#designated_line_Table tr#approvalLine_1 > td").length == 0) {
						// 현재 결재선에 추가된 사람이 없을 경우
						$("tr#approvalLine_1").append(`<td class="table_title" style="width: 110px;">순서</td>`);
						$("tr#approvalLine_2").append(`<td class="table_title" style="width: 110px;">직책</td>	`);
						$("tr#approvalLine_3").append(`<td class="table_title" style="width: 110px;">부서</td>`);
						$("tr#approvalLine_4").append(`<td class="table_title" style="width: 110px;">성명</td>`);
						$("tr#approvalLine_5").append(`<td class="table_title" style="width: 110px;">결재상태</td>`);
					}
	
					$.each(json, function(index, item){
						$("tr#approvalLine_1").append(`<td style="width: 120px;">\${item.member_step}</td>`);
						$("tr#approvalLine_2").append(`<td style="width: 120px;">\${item.member_position}</td>`);
						$("tr#approvalLine_3").append(`<td style="width: 120px;"><span class="span_member_userid" style="display: none;">\${item.member_userid}</span>\${item.child_dept_name}</td>`);
						$("tr#approvalLine_4").append(`<td style="width: 120px;">\${item.member_name}</td>`);
						$("tr#approvalLine_5").append(`<td style="width: 120px;"><div style="border: solid 1px gray; width: 70%; height: 80px; margin: auto;"></div></td>`);
					});
				
				},200);
	
			},
			error: function() {
				swal('결재선 불러오기 실패!',"다시 시도해주세요",'error');
			}
		});
		
	}
	else {
		// 결재선 목록에 추가하지 않고 버튼을 클릭한 경우
		Swal.fire({
		    title: '',
		    html: '<span style="font-size: 20px;">결재선 목록에 최소 한 명 이상<br>추가 해야합니다.</span>',
		    icon: 'warning'
		});
		
		return;
	}
	
	<%-- ==== 참조자 목록 순서 지정 ==== --%>
	if(arr_referenceMembers.length > 0) {
		$.ajax({
			url:"<%= ctxPath%>/approval/orderByReferenceMember",
			data:{"arr_referenceMembers":arr_referenceMembers},
			type:"post",			
			success:function(json){
				
				// AJAX 요청 성공 후, 취소 버튼 클릭을 강제로 트리거
	            // $("button[id='btn_cancel']").click();
	
	            // 모달이 닫힌 후 실행될 작업을 처리
				setTimeout(function(){
		
					// 기존에 회색 박스를 다시 감추고, 참조선 테이블을 보인다.
					$("div#undesignated_refer").css({"display":"none"});
					$("table#undesignated_refer_Table").css({"display":"table"});
					
					// 참조선 목록에 추가되는 인원 수에 따라서 width 가 잡히도록 설정.
					$("div#undesignated_line_total").css({"width":"auto"});
					
					// 기존의 참조선 목록을 없앤다.
					$("table#undesignated_refer_Table").html("");
					
					if($("table#undesignated_refer_Table tr#referenceMember > td").length == 0) {
						// 현재 참조선 추가된 사람이 없을 경우
						
						if($("table#undesignated_refer_Table tr").length == 0) {
							html = `<tr>
										<th class="table_title">부문</th>
										<th class="table_title">부서</th>
										<th class="table_title">직책</th>
										<th class="table_title">성명</th>
									</tr>`;
							
							$("table#undesignated_refer_Table").append(html);
						}
						
						$.each(json, function(index, item){
							html = `<tr class="referenceMember">
										<td style="width: 100px;">\${item.parent_dept_name}</td>
										<td style="width: 100px;">\${item.child_dept_name}</td>
										<td style="width: 100px;">\${item.member_position}</td>
										<td style="width: 100px;"><span class="span_member_userid" style="display: none;">\${item.member_userid}</span>\${item.member_name}</td>
									</tr>`;
									
							$("table#undesignated_refer_Table").append(html);
		
						});
					}
	
				},100);
	
			},
			error: function() {
				swal('참조선 불러오기 실패!',"다시 시도해주세요",'error');
			}
		});
	}
	else {
		$("table#undesignated_refer_Table").html("");
		// 기존에 결재선 테이블을 다시 감추고, 회색 박스를 보인다.
		$("table#undesignated_refer_Table").css({"display":"none"});	
		$("div#undesignated_refer").css({"display":"block"});
	}
	
}


////////////////////////////////////////////////////////////////////////////////////////


<%-- ==== 임시저장 버튼 함수 ==== --%>
function goTemporaryStored(btnType) {

	let titleText = '';
    let messageText = '';

    // btnType에 따라 title과 message 설정
    if (btnType == "임시저장") {
        titleText = '임시저장 하시겠습니까?';
        messageText = "저장된 항목은 '임시저장함'에서 확인하실 수 있습니다.";
    } 
	else if (btnType == "결재요청") {
        titleText = '결재요청 하시겠습니까?';
        messageText = "저장된 항목은 '결재상신함'에서 확인하실 수 있습니다.";
    }
		
	Swal.fire({
		title: titleText,
		text: messageText,
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#3085d6',
		cancelButtonColor: '#d33',
		confirmButtonText: '확인',
		cancelButtonText: '취소',      
	}).then((result) => {
		
		if (result.isConfirmed) {
			
			func_goTempAndSubmitDraft(btnType);
		}

	});
}


<%-- 임시저장 및 결재요청 시 데이터 취합하여 보내기 --%>
function func_goTempAndSubmitDraft(btnType) {
	
	// >>> 기안문 insert/update 여부 <<<
	var draftMode = $("input[id='draftMode']").val();
	
	// >>> 결재선 가져오기 <<<
	let approvalLineMember = func_approvalLineMember();
	
	// >>> 참조자 가져오기 <<<
	let referMember = func_referMember();

	// >>> 공통 문서정보 <<< 
	const fk_member_userid = $("span#member_userid").text();						// 작성자id
	const draft_no = $("td#draft_no").text().toString();							// 문서번호
	const draft_form_type = $("h2#draftSubject").text();							// 기안문유형
	const draft_subject = $("input:text[name='draft_subject']").val();				// 제목
	const draft_write_date = $("td#draft_write_date").text();						// 작성일자
	const draft_urgent = $("input:checkbox[name='draft_urgent']:checked").length.toString();	// 긴급여부
	
	/////////////////////////////////////////////////////////////////////////////////////
	// ==== >>> 데이터 모으기 ==== <<< //
	let day_leave_end;		// 연차종료일
	let day_leave_start;	// 연차시작일
	let day_leave_cnt;		// 연차사용일
	let day_leave_reason;	// 휴가사유
	const dayLeaveType = ($("input:radio[name='dayLeaveType']:checked").val()); // 연차, 반차 중 어느 것인지 구분을 위한 변수
	
	if(draft_form_type == "휴가신청서") {
		
		if(dayLeaveType == "연차") {
			day_leave_start = $("input[name='allDay_leave_start']").val();	// 연차시작일
			day_leave_end = $("input[name='allDay_leave_end']").val();		// 연차종료일
			day_leave_cnt = $("span#day_leave_cnt").text();					// 연차사용일
			
		}
		else if (dayLeaveType == "오전반차" || dayLeaveType == "오후반차") {
			day_leave_end = $("input[name='halfDay_leave_end']").val();			// 반차시작일
			day_leave_start = day_leave_end;									// 반차종료일
			day_leave_cnt = 0.5;												// 반차사용일
		}

		day_leave_reason = $("textarea[name='day_leave_reason']").val();			// 휴가사유
		day_leave_reason = day_leave_reason.replace(/(?:\r\n|\r|\n)/g,'<br/>');		// 줄바꿈을 문자열로 바꾸어주기
			
	}
	else if (draft_form_type == "근무변경") {
			
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// ==== >>> 유효성 검사 <<< ==== //
	if (btnType == "임시저장") {
		// 제목을 작성하지 않은 경우
		if(draft_subject.trim() == "") {
			Swal.fire({
			    icon: 'info',
			    title: '제목을 작성해 주세요',
			    text: '다시 시도해주세요.'
			});
			return;
		}
	}
	else if (btnType == "결재요청") {
		
		if (draft_subject.trim() == "") {
			// 제목을 작성하지 않은 경우
			Swal.fire({
				icon: 'info',
			    title: '제목을 작성해 주세요',
			    text: '다시 시도해주세요.'
			});
			return;
		} 
		
		if (Object.keys(approvalLineMember).length == 0) {
			// 결재선을 추가하지 않은 경우
			Swal.fire({
				icon: 'info',
			    title: '결재선을 추가해주세요',
			    text: '다시 시도해주세요.'
			});
			return;
		}

		if(day_leave_reason == "") {
			// 휴가사유를 입력하지 않은 경우
			Swal.fire({
				icon: 'info',
			    title: '휴가사유를 입력해주세요.',
			    text: '다시 시도해주세요.'
			});
			return;
		}
	
		if(draft_form_type == "휴가신청서") {
			
			if(dayLeaveType == "연차") {			
				if (day_leave_start == "") {
					// 연차시작일을 입력하지 않은 경우
					Swal.fire({
						icon: 'info',
					    title: '휴가 시작일을 입력해주세요.',
					    text: '다시 시도해주세요.'
					});
					return;
				}
				
				if (day_leave_end == "") {
					// 연차종료일을 입력하지 않은 경우
					Swal.fire({
						icon: 'info',
					    title: '휴가 종료일을 입력해주세요.',
					    text: '다시 시도해주세요.'
					});
					return;
				}
			}
			else if (dayLeaveType == "오전반차" || dayLeaveType == "오후반차") {
				if (day_leave_end == "") {
					// 반차 사용일을 입력하지 않은 경우
					Swal.fire({
						icon: 'info',
					    title: '반차 사용일을 입력해주세요.',
					    text: '다시 시도해주세요.'
					});
					return;
				}
			}
		}// end of if(draft_form_type == "휴가신청서") {}-----------------------------
		
	}


	// alert 메세지 
	let titleText = '';
    let messageText = '';

    
    
	// 접근 경로 및 작업에 따라 service 단에서 다르게 처리하기 위한 용도
	if (draftMode == "update") {
		if(btnType == "임시저장") {
			// 임시저장 목록을 통해 들어온 후 --> 임시저장 버튼 클릭
			draftMode = "update";
			titleText = "임시 저장 완료";
			messageText = "임시 저장이 성공적으로 완료되었습니다.";
		}
		else if(btnType == "결재요청") {
			// 임시저장 목록을 통해 들어온 후 --> 결재요청 버튼 클릭
			draftMode = "update_Submit";
			titleText = "결재 요청 완료";
			messageText = "결재 요청이 성공적으로 완료되었습니다.";
		}
	}
	else if (draftMode == "insert") {
		if(btnType == "임시저장") {
			// 기안문 작성을 통해 들어온 후 --> 임시저장 버튼 클릭
			draftMode = "insert"
			titleText = "임시 저장 완료";
			messageText = "임시 저장이 성공적으로 완료되었습니다.";
		}
		else if(btnType == "결재요청") {
			// 기안문 작성을 통해 들어온 후 --> 결재요청 버튼 클릭
			draftMode = "insert_Submit";
			titleText = "결재 요청 완료";
			messageText = "결재 요청이 성공적으로 완료되었습니다.";
		}
	}
	
	
	<%-- 임시저장 및 결재요청하기 위해 데이터 취합 --%>		
	var formData = new FormData();
	
	formData.append("draftMode", draftMode);
	formData.append("approvalLineMember", JSON.stringify(approvalLineMember));
	formData.append("referMember", JSON.stringify(referMember));
	formData.append("fk_member_userid", fk_member_userid);
	formData.append("draft_no", draft_no);
	formData.append("draft_form_type", draft_form_type);
	formData.append("draft_subject", draft_subject);
	formData.append("draft_write_date", draft_write_date);
	formData.append("draft_urgent", draft_urgent);
	formData.append("day_leave_start", day_leave_start);
	formData.append("day_leave_end", day_leave_end);
	formData.append("day_leave_cnt", day_leave_cnt);
	formData.append("day_leave_reason", day_leave_reason);
	
	// 파일데이터가 있다면 파일데이터도 추가
	var fileInput = $("input[type='file']")[0];
	var file = fileInput.files[0];
	
	if(file) {
		formData.append("file", file);
	}
	

	<%-- 임시저장 ajax 요청 --%>
	$.ajax({
		url:"<%= ctxPath%>/approval/insertToTemporaryStored",
		data: formData,
		processData: false,
	    contentType: false,
		type:"post",			
		success:function(json){

			if(json == 1) {
				Swal.fire({
				    icon: 'success',
				    title: titleText,
				    text: messageText
				});
			}	
		},
		error: function() {
			Swal.fire({
			    icon: 'error',
			    title: '작업 수행 실패!',
			    text: '다시 시도해주세요.'
			});
		}
	});

}// end of function func_goTempAndSubmitDraft() {}------------------------------


<%-- 결재선 가져오기 --%>
let step = "step";

function func_approvalLineMember() {
	
	let approvalLineMember = {};
	
	let span_member_userid = document.querySelectorAll("tr#approvalLine_3 > td > span.span_member_userid");
	
	span_member_userid.forEach(function(item, index, array){

		approvalLineMember[step+(index+1).toString()] = item.textContent;  // 컨트롤러에서 Map<String, Object> 형태를 맞춰주기 위해 형변환
	});
	
	return approvalLineMember;
}

<%-- 참조선 가져오기 --%>
function func_referMember() {
	
	let referMember = {};
	
	let span_member_userid = document.querySelectorAll("tr.referenceMember > td span.span_member_userid");
	
	span_member_userid.forEach(function(item, index, array){

		referMember[step+(index+1).toString()] = item.textContent;  // 컨트롤러에서 Map<String, Object> 형태를 맞춰주기 위해 형변환
	});
	
	return referMember;
}
</script>


<%-- ===================================================================== --%>
<div class="writeContainer">
	<h2>기안문작성</h2>
	
	<button type="button" id="btnType">결재양식선택</button>

	<span id="btnRight">
		<button type="button" id="btnSaved" onclick="goTemporaryStored('임시저장')">임시저장</button>
		<button type="button" id="btnLine" onclick="setApprovalLine()">결재선지정</button>
		<button type="button" id="btnRequest" onclick="goTemporaryStored('결재요청')">결재요청</button>
	</span>

	<div id="modalDraftType"></div>
	<div id="approvalLine"></div>
	
	<div id="draft" style="margin: auto;"></div>
	
</div>




	
<jsp:include page="../../footer/footer1.jsp" />    