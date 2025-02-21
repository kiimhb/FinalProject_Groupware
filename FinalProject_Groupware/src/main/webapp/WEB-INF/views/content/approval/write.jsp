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

	
	
});// end of $(document).ready(function(){})----------------



/////////////////////////////////
// >>>> **** 함수 정의 **** <<<< //
////////////////////////////////

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

    
	let arr_approvalLineMembers = [];	// 결재선에 추가된 멤버
	let arr_referenceMembers = [];		// 참조자에 추가된 멤버
	
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
				        			<button type="button" class="btn btn-secondary" id="btn_cancel" data-dismiss="modal">취소</button>
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
		
		
		<%-- ==== 기존에 추가했던 결재선/참조자 사원을 목록에 불러오기 ==== --%>
		if($("table#designated_line_Table tr#approvalLine_1 > td").length > 0 ) {
			// 결재선/참조자 목록에 추가한 이력이 있으면
			
			let span_member_userid = document.querySelectorAll("tr#approvalLine_3 > td > span.span_member_userid");
			let arr_member_userid = []
			
			span_member_userid.forEach(function(item, index, array){
				
				// console.log(item.textContent); // 텍스트는 textContent로 접근
				arr_member_userid.push(item.textContent);
			});
			
			<%-- ==== 결재선 목록으로 넣기 ==== --%> 				
			$.ajax({
    			url:"<%= ctxPath%>/approval/insertToApprovalLine_Arr",
    			data:{"arr_member_userid":arr_member_userid},
    			type:"post",			
    			success:function(json){
    				
    				if(arr_approvalLineMembers.length < 3) {
    					// 결재선 목록에 있는 사원이 3명 미만인경우
    					
        				if(!arr_referenceMembers.includes(json.member_userid) && !arr_approvalLineMembers.includes(json.member_userid)){
        					// 결재선 및 참조자 목록에 없는 사원일 경우만 목록에 추가
        					
        					$.each(json, function(index, item){
        						arr_approvalLineMembers.push(json.member_userid);
   
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
        	
        	var member;
        	
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
        	
        	<%-- ==== 결재선 목록에서 빼기 ==== --%> 	
        	$("span#referLeftBtn").on("click", function(e){
        		$("table#referenceMember_T tr").eq(memberIndex).remove();
        		
        		// 배열에서도 제거
        		arr_referenceMembers.splice(memberIndex-1,1);
        	});
        	
        	
        });// end of $("table#referenceMember_T").on("click", "tr", function(e){})---------------------- 
        <%-- ==================== 사원 선택 후 참조자 목록에서 제거하는 이벤트 끝  ==================== --%>
    });
	
	
	<%-- ==================== 결재선지정 버튼 클릭 이벤트 시작 ==================== --%>
	$("button[id='goAddLine']").on("click",function(){
		
		// >>> 결재선 결재순위 지정 <<<
		$.ajax({
			url:"<%= ctxPath%>/approval/orderByApprovalStep",
			data:{"arr_approvalLineMembers":arr_approvalLineMembers},
			type:"post",			
			success:function(json){
				
				// AJAX 요청 성공 후, 취소 버튼 클릭을 강제로 트리거
	            $("button[id='btn_cancel']").click();  // 취소 버튼 클릭 시 모달 닫힘

	            // 모달이 닫힌 후 실행될 작업을 처리
				setTimeout(function(){
		
					// 기존에 회색 박스를 다시 감추고, 결재선 테이블을 보인다.
					$("div#undesignated_line").css({"display":"none"});
					$("table#designated_line_Table").css({"display":"table"})
					
					if($("table#designated_line_Table tr#approvalLine_1 > td").length == 0) {
						// 현재 결재선에 추가된 사람이 없을 경우
						$("tr#approvalLine_1").append(`<td class="table_title">순서</td>`);
						$("tr#approvalLine_2").append(`<td class="table_title">직책</td>	`);
						$("tr#approvalLine_3").append(`<td class="table_title">부문</td>`);
						$("tr#approvalLine_4").append(`<td class="table_title">성명</td>`);
						$("tr#approvalLine_5").append(`<td class="table_title">결재상태</td>`);
					}

					$.each(json, function(index, item){
						$("tr#approvalLine_1").append(`<td>\${item.member_step}</td>`);
						$("tr#approvalLine_2").append(`<td>\${item.member_position}</td>`);
						$("tr#approvalLine_3").append(`<td><span class="span_member_userid" style="display: none;">\${item.member_userid}</span>\${item.child_dept_name}</td>`);
						$("tr#approvalLine_4").append(`<td>\${item.member_name}</td>`);
						$("tr#approvalLine_5").append(`<td><div style="border: solid 1px gray; width: 70%; height: 80px; margin: auto;"></div></td>`);
					});
					
				
				},300);

			},
			error: function() {
				swal('결재선 불러오기 실패!',"다시 시도해주세요",'error');
			}
		});
	});
	<%-- ==================== 결재선지정 버튼 클릭 이벤트 끝  ==================== --%>
	
}// end of function setApprovalLine() {}------------------------------

////////////////////////////////////////////////////////////////////////////////////////

<%-- ==== 결재선지정 완료 함수 ==== --%>

</script>


<%-- ===================================================================== --%>
<div class="writeContainer">
	<h2>기안문작성</h2>
	
	<button type="button" id="btnType">결재양식선택</button>

	<span id="btnRight">
		<button type="button" id="btnSaved">임시저장</button>
		<button type="button" id="btnLine" onclick="setApprovalLine()">결재선지정</button>
		<button type="button" id="btnRequest">결재요청</button>
	</span>

	<div id="modalDraftType"></div>
	<div id="approvalLine"></div>
	
	<div id="draft" style="margin: auto;"></div>
	
</div>




	
<jsp:include page="../../footer/footer1.jsp" />    