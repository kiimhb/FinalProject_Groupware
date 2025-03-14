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
		border: solid 1px #D3D3D3;
		border-radius: 5px;
		width: 95%;
		height: 860px;
     	margin: auto;
      	margin-top: 4%;
	}
	
	div#draft {
	    width: 100% !important;
	    margin: auto;
	    overflow: hidden;
	}
	
	h2 {
		margin-left: 3%;
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
	
	a:hover {
		opacity: 0.5;
	}
	
	<%-- input 요소들 disable 후 배경색 변경 --%>
	input:disabled, textarea:disabled {
	    background-color: white !important; 
	    color: black !important; 
    	border-color: #ccc !important; 
  	}

  	input[type="checkbox"]:disabled, input[type="radio"]:disabled {
    	background-color: white !important;
    	color: black !important;
  	}
	
	<%-- 모달창 input-type:text --%>
	input {
		padding: .5rem 1.5rem;
	    font-size: 1rem;
		border-radius: .5rem;
		border: none;
		background-color: #efefef;
	}
	
	input:focus {
    	border: 0.125rem solid #509d9c !important;
    	outline: none; /* 기본적으로 브라우저에서 제공하는 포커스 아웃라인을 없애려면 추가 */
	}
</style>


<script type="text/javascript">
let arr_approvalLineMembers = [];	// 결재선에 추가된 멤버
let arr_referenceMembers = [];		// 참조자에 추가된 멤버

$(document).ready(function(){
	
	const draft_form_type = "${requestScope.approvalvo.draft_form_type}";
	
	<%-- 페이지 로드시 기안문 및 기안문 내용 불러오기 --%>
	$.ajax({
		url: "<%= ctxPath%>/approval/writeDraftTemp",
		data: {"typeSelect":draft_form_type},
		type: "get",
		success: function(draftForm) {
			
			$("div#draft").html(draftForm);
			
			const approval_status = "${requestScope.approvalvo.login_user_approval_status}";
			
			// 결재 할 기안문이 아니면 결재/반려 버튼 감추기
			if(approval_status != '결재예정') {
				$("button#btnApprove").hide();
				$("button#btnSendBack").hide();
			}
			
			// 기안문 형식 udate 로 변경
			$("input[id='draftMode']").val("update");
			
			// 결재 의견란 보이기
			$("div#feedback").css({"display":"block"});
			
			// >>> 기존의 값 기안문에 채워넣기 및 결재자 시점에서 disable <<< //
			// 1. 문서정보
			$("td#member_name").text("${requestScope.approvalvo.member_name}");					// 기안자
			$("td#parent_dept_name").text("${requestScope.approvalvo.parent_dept_name}");		// 부문
			$("td#child_dept_name").text("${requestScope.approvalvo.child_dept_name}");			// 부서
			$("td#member_position").text("${requestScope.approvalvo.member_position}");			// 직책
			$("td#draft_no").text("${requestScope.approvalvo.draft_no}");						// 문서번호
			
			// 2. 문서 내용
			$("input[name='draft_subject']").val("${requestScope.approvalvo.draft_subject}").prop("disabled", true); // 제목
			
			if(${requestScope.approvalvo.draft_urgent eq "1"}) {	
				$("input[name='draft_urgent']").prop("checked", true).prop("disabled", true);	// 긴급여부
			}
			
			if(${requestScope.approvalvo.draft_form_type eq "휴가신청서"}) {
				
				setTimeout(function() {
			        // 기존 라디오 버튼 해제
			        $("input:radio[name='dayLeave']").prop("checked", false);

			        // 조건에 맞는 라디오 버튼을 체크 
			        if (${requestScope.approvalvo.day_leave_cnt eq "0.5"}) {
			            $("input:radio[id='amDay']").prop("checked", true);	// 반차
			            $("input:radio").prop("disabled", true);
						
						$("div#halfDay").css({"display":"block"});
						$("div#allDay").css({"display":"none"});
									
						$("input[name='halfDay_leave_end']").val("${requestScope.approvalvo.day_leave_start}").prop("disabled", true);	// 반차사용일
			        } else {
			            $("input:radio[id='allDay']").prop("checked", true); // 연차
			            $("input:radio").prop("disabled", true);
						
						$("div#halfDay").css({"display":"none"});
						$("div#allDay").css({"display":"block"});	
									
						$("input[name='allDay_leave_start']").val("${requestScope.approvalvo.day_leave_start}").prop("disabled", true);  // 연차시작일
						$("input[name='allDay_leave_end']").val("${requestScope.approvalvo.day_leave_end}").prop("disabled", true);	  // 연차종료일
			        }
			    }, 0);
				
				
				const temp_day_leave_reason = "${requestScope.approvalvo.day_leave_reason}";
				$("textarea[name='day_leave_reason']").text(temp_day_leave_reason.replace(/<br\s*\/?>/gi, '\n')).prop("disabled", true);	// 휴가사유
				$('textarea').trigger('keyup');	// 글자수 세는 함수를 불러오기 위함
			}
			
			// 3. 기존 첨부파일 가져오기
			$("label#fileLabel").remove();
			$("input[type='file']").remove();
			$("div#fileAdd").off("dragneter");
			$("div#fileAdd").off("dragover");
			$("div#fileAdd").off("dragover");

			if(${not empty requestScope.approvalvo.draft_file_name}) {
				const draft_file_origin_name = "${requestScope.approvalvo.draft_file_origin_name}";
				const draft_file_size = "${requestScope.approvalvo.draft_file_size}";
				const draft_file_url = "<%= ctxPath%>/resources/draft/" + "${requestScope.approvalvo.draft_file_name}";
				
				setTimeout(function() {
					const draft_file_origin_name = "${requestScope.approvalvo.draft_file_origin_name}";
					const draft_file_url = "<%= ctxPath%>/resources/draft/" + "${requestScope.approvalvo.draft_file_name}"; // 파일 경로
					
					let html = `<div style="display: flex; height: 35px;"><a href="<%= ctxPath%>/approval/download?draft_file_name=${requestScope.approvalvo.draft_file_name}&draft_file_origin_name=${requestScope.approvalvo.draft_file_origin_name}" style="display:flex; width: 100%; align-items: center;"><span style="padding-left: 2%;"><i class="fa-solid fa-paperclip"></i>&nbsp;\${draft_file_origin_name}</span><span id="fileSize" style="margin-left: auto; padding-right: 4%;">\${draft_file_size}KB</span></a></div>`;

					$("div#fileAdd").append(html).show();
					
					$("div#fileAdd").off("drop");
					$("div#fileAdd").off("click");
					
					$("input[type='file']").prop("disabled", true);
				}, 0);
			}
			else  {
				// 파일이 없는 경우
				setTimeout(function() {
					let html = `<div style="height: 35px; padding-top: 5px;">첨부파일이 없습니다.</div>`;
					$("div#fileAdd").append(html).show();
					$("div#fileAdd").off("drop");
					$("div#fileAdd").off("click");	
					$("div#fileAdd").off('mouseenter').off('mouseleave');
				}, 10);
				
				// hover 효과 없애기
				$("div#fileAdd").css({"cursor":"auto","pointer-events":"none"});
			}

			<%-- 결재선/참조자 목록 불러오기 --%>
			getTempApprovalRefer("${requestScope.approvalvo.draft_no}");

			<%-- 결재의견 불러오기 --%>
			getApprovalFeedback("${requestScope.approvalvo.draft_no}");
		},
		error: function() {
			swal('양식 불러오기 실패!',"다시 시도해주세요",'error');
		}
		
	});
	
	///////////////////////////////////////////////////////////////////////////
	
	<%-- #1. 결재승인 버튼 클릭 이벤트 --%>
	$("button#btnApprove").on("click",function(e){
		
		// 모달을 넣을 위치
		const container = $("div#modalClickBtn");
		
		// 모달 구조
		const modal_popup = `
							<div class="modal fade" id="btnApproveModal" style="top:20%;">
								<div class="modal-dialog">
									<div class="modal-content">
										
										<div class="modal-header">
											<h4 style="margin-top: 2%;">결재승인</h4>	
										</div>
										
										<div class="modal-body">
											<div style="font-size: 16pt; margin-bottom: 3%;">결재의견<span style="font-size: 14pt;">&nbsp;(선택)</span></div>
											<form name="btnApproveModal_Frm">
												<input type="text" name="approval_feedback" style="width: 100%;" placeholder="결재의견을 입력해주세요.(50자 이내)"/>
											</form>
										</div>
										
										<div class="modal-footer">
											<button type="button" class="btn btn-primary" style="background-color: #509d9c; border-color: #509d9c;" onclick="goApprovalConfirm()">승인</button>
											<button type="button" class="btn btn-secondary" id="btn_cancel" data-dismiss="modal">취소</button>
										</div>
										
									</div>
								</div>
							</div>`;
		
		// 모달 띄우기
		container.html(modal_popup);
		$("div#btnApproveModal").modal("show");
	});
	
	
	<%-- 결재반려 버튼 클릭 이벤트 --%>
	$("button#btnSendBack").on("click",function(e){
		
		// 모달을 넣을 위치
		const container = $("div#modalClickBtn");
		
		// 모달 구조
		const modal_popup = `
							<div class="modal fade" id="btnApproveModal" style="top:20%;">
								<div class="modal-dialog">
									<div class="modal-content">
										
										<div class="modal-header">
											<h4 style="margin-top: 2%;">결재반려</h4>	
										</div>
										
										<div class="modal-body">
											<div style="font-size: 16pt; margin-bottom: 3%;">결재의견<span style="font-size: 14pt;">&nbsp;(필수)</span></div>
											<form name="btnApproveModal_Frm">
												<input type="text" name="approval_feedback" style="width: 100%;" placeholder="반려의견을 입력해주세요.(50자 이내)"/>
											</form>
										</div>
										
										<div class="modal-footer">
											<button type="button" class="btn btn-primary" style="background-color: #509d9c; border-color: #509d9c;" onclick="goSendBackConfirm()">반려</button>
											<button type="button" class="btn btn-secondary" id="btn_cancel" data-dismiss="modal">취소</button>
										</div>
										
									</div>
								</div>
							</div>`;
		
		// 모달 띄우기
		container.html(modal_popup);
		$("div#btnApproveModal").modal("show");
	});
	
	
	
	
});// end of $(document).ready(function(){})-----------------------------------------


////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////
//>>>> **** 함수 정의 **** <<<< //
////////////////////////////////
<%-- #2. 결재의견 작성 모달에서 승인버튼 클릭 이벤트 --%>
function goApprovalConfirm() {
	
	Swal.fire({
		title: "결재 승인",
		text: "승인하시겠습니까?",
		showCancelButton: true,
		confirmButtonColor: '#f68b1f',
		cancelButtonColor: '#857c7a',
		confirmButtonText: '확인',
		cancelButtonText: '취소',    
		width: 350,  // 너비 조정
	    padding: '20px',  // 패딩 조정
	}).then((result) => {
		
		if (result.isConfirmed) {
			
			const fk_draft_no = "${requestScope.approvalvo.draft_no}";
			const approval_feedback = $("input[name='approval_feedback']").val();
			const fk_member_userid = $("span#member_userid").text();
			const day_leave_cnt = $("span#day_leave_cnt").text();
			
			<%-- 결재의견 및 승인 처리 요청 --%>
			$.ajax({
				url:"<%= ctxPath%>/approval/goApprove",
				data: {"fk_draft_no":fk_draft_no
					  ,"approval_feedback":approval_feedback
					  ,"write_member_userid":fk_member_userid},
				type:"post",			
				success:function(json){

					if(json == 1) {
						Swal.fire({
						    icon: 'success',
						    title: "결재승인이 완료되었습니다.",
						}).then(() => {
	                        // "확인" 버튼을 클릭하면 페이지 새로고침
	                        location.reload();
	                    });
						
						$("button#btnApprove").hide();
						$("button#btnSendBack").hide();
					}	
				},
				error: function() {
					Swal.fire({
					    icon: 'error',
					    title: '승인 작업 수행 실패!',
					    text: '다시 시도해주세요.'
					});
				}
			});

		}

	});
	
}// end of function goApprovalConfirm() {}--------------------------------


<%-- 반려의견 작성 모달에서 반려버튼 클릭 이벤트 --%>
function goSendBackConfirm() {
	
	Swal.fire({
		title: "결재 반려",
		text: "반려하시겠습니까?",
		showCancelButton: true,
		confirmButtonColor: '#f68b1f',
		cancelButtonColor: '#857c7a',
		confirmButtonText: '확인',
		cancelButtonText: '취소',    
		width: 350,  // 너비 조정
	    padding: '20px',  // 패딩 조정
	}).then((result) => {
		
		if (result.isConfirmed) {
			
			const fk_draft_no = "${requestScope.approvalvo.draft_no}";
			const approval_feedback = $("input[name='approval_feedback']").val();
			
			if (approval_feedback == "") {
				
				Swal.fire({
				    icon: 'info',
				    title: '반려 의견은 필수 기입사항입니다.',
				    text: '다시 시도해주세요.'
				});
				
				return;
				
			}
			else {
				<%-- 반려의견 및 반려 처리 요청 --%>
				$.ajax({
					url:"<%= ctxPath%>/approval/goSendBack",
					data: {fk_draft_no:fk_draft_no
						  ,approval_feedback:approval_feedback},
					type:"post",			
					success:function(json){
	
						if(json == 1) {
							Swal.fire({
							    icon: 'success',
							    title: "결재반려가 완료되었습니다.",
							}).then(() => {
		                        // "확인" 버튼을 클릭하면 페이지 새로고침
		                        location.reload();
		                    });
							
							$("button#btnApprove").hide();
							$("button#btnSendBack").hide();
						}	
					},
					error: function() {
						Swal.fire({
						    icon: 'error',
						    title: '반려 처리 수행 실패!',
						    text: '다시 시도해주세요.'
						});
					}
				});
			}
		}

	});
}// end of function goSendBackConfirm() {}---------------------------------



<%-- ==== 기안문의 결재선/참조자 목록 불러오기 ==== --%>
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



<%-- ==== 결재의견 불러오기 ==== --%>
function getApprovalFeedback(draft_no) {

	$.ajax({
		url: "<%= ctxPath%>/approval/getApprovalFeedback",
		data: {"draft_no":draft_no},
		type: "get",
		success: function(json) {
			
			if(json.length > 0) {
				const addFeedback = $("div#feedbackContainer");
				
				let html = `<table id="Feedback_T" class="table" style="width: 100%; border: 1px #a39485 solid; box-shadow: 0 2px 5px rgba(0,0,0,.25); width: 100%; border-collapse: collapse; border-radius: 5px;">`;
				
				$.each(json, function(index, item){
					
					html += `<tr style="height: 40px; ">
								<td style="vertical-align:middle;">\${item.approval_step}</td>
								<td style="vertical-align:middle;"><img width="50" height="50" style="border-radius: 50%;" src="<%= ctxPath%>/resources/profile/\${item.member_pro_filename}" / >&nbsp;&nbsp;\${item.child_dept_name}</td>
								<td style="vertical-align:middle;">\${item.member_position}</td>
								<td style="vertical-align:middle;">\${item.member_name}</td>
								<td style="vertical-align:middle;">\${item.approval_status}</td>
								<td style="vertical-align:middle; text-align: left; padding-left: 1%; width: 60%; white-space: normal; word-wrap: break-word;">\${item.approval_feedback}</td>
							</tr>`;
				});
				
				html += `</table>`;
				
				$("div#defaultFeedback").hide();

				addFeedback.css({"border":"0px"});
				addFeedback.html(html);
			}
			
			
		},
		error: function() {
			Swal.fire({
				icon: 'error',
				title: '결재 의견 불러오기 실패!',
				text: '다시 시도해주세요.'
			});
		}
	});

}// end of function getApprovalFeedback((draft_no) {})--------------------------------


<%-- ==== 결재선 결재순위 지정 / 참조자 목록 순서 지정 ==== --%>
function func_goAddLine() {
	
	<%-- ==== 결재선 결재순위 지정 ==== --%> 
	if(arr_approvalLineMembers.length > 0) {
		
		const draft_no = "${requestScope.approvalvo.draft_no}";
		
		$.ajax({
			url:"<%= ctxPath%>/approval/orderByApprovalStep_withSign",
			data:{"draft_no":draft_no},
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
						$("tr#approvalLine_2").append(`<td class="table_title" style="width: 110px;">직책</td>`);
						$("tr#approvalLine_3").append(`<td class="table_title" style="width: 110px;">부서</td>`);
						$("tr#approvalLine_4").append(`<td class="table_title" style="width: 110px;">성명</td>`);
						$("tr#approvalLine_5").append(`<td class="table_title" style="width: 110px;">결재상태</td>`);
					}
	
					$.each(json, function(index, item){
						$("tr#approvalLine_1").append(`<td style="width: 120px;">\${item.member_step}</td>`);
						$("tr#approvalLine_2").append(`<td style="width: 120px;">\${item.member_position}</td>`);
						$("tr#approvalLine_3").append(`<td style="width: 120px;"><span class="span_member_userid" style="display: none;">\${item.member_userid}</span>\${item.child_dept_name}</td>`);
						$("tr#approvalLine_4").append(`<td style="width: 120px;">\${item.member_name}</td>`);
						if(item.member_sign_filename != '미결재') {
							
							if(item.approval_status == '승인' && item.member_sign_filename != 'noSign') {
								
								$("tr#approvalLine_5").append(`<td style="width: 120px;"><img width="50" height="50" style="border-radius: 50%;" src="<%= ctxPath%>/resources/profile/\${item.member_sign_filename}" / </td>`);
							}
							else if (item.approval_status == '승인' && item.member_sign_filename == 'noSign') {
								$("tr#approvalLine_5").append(`<td style="width: 120px; padding: 2%;">
								   		<div style="border: solid 2px blue; width: 80px; border-radius: 50%; height: 80px; margin: auto; font-size: 17pt; display: flex; justify-content: center; align-items: center;  box-sizing: border-box; padding: 5px; border-radius: 50%; background: white; position: relative;">
									        	<div style="border: solid 1px blue; width: 100%; height: 100%; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: blue;">
									            	승인
									        	</div>
									    	</div>
									   </td>`);
							}
							else if (item.approval_status == '반려' && item.member_sign_filename == 'noSign') {
								$("tr#approvalLine_5").append(`<td style="width: 120px; padding: 2%;">
															   		<div style="border: solid 2px red; width: 80px; border-radius: 50%; height: 80px; margin: auto; font-size: 17pt; display: flex; justify-content: center; align-items: center;  box-sizing: border-box; padding: 5px; border-radius: 50%; background: white; position: relative;">
															        	<div style="border: solid 1px red; width: 100%; height: 100%; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: red;">
															            	반려
															        	</div>
															    	</div>
															   </td>`);
							}
						}	
						else if(item.member_sign_filename == '미결재') {
							$("tr#approvalLine_5").append(`<td style="width: 120px; padding: 2%;">
															   		<div style="border: solid 2px gray; width: 80px; border-radius: 50%; height: 80px; margin: auto; font-size: 17pt; display: flex; justify-content: center; align-items: center;  box-sizing: border-box; padding: 5px; border-radius: 50%; background: white; position: relative;">
															        	<div style="border: solid 1px gray; width: 100%; height: 100%; border-radius: 50%; display: flex; justify-content: center; align-items: center;">
															            	대기
															        	</div>	
														    	</div>
														   </td>`);
						}
					});
				
				},200);
	
			},
			error: function() {
				Swal.fire({
				    title: '결재선 불러오기 실패!',
				    html: '다시 시도해주세요',
				    icon: 'error'
				});
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


</script>


<%-- ===================================================================== --%>
<div id="sub_mycontent"> 

	<div class="writeContainer">
		<h2 style="border-left: 5px solid #006769; padding-left: 1%; color: #4c4d4f; font-weight: bold;">결재안</h2>
	
		<span id="btnRight">
			<button type="button" id="btnApprove">결재승인</button>
			<button type="button" id="btnSendBack">결재반려</button>
			<button type="button" id="btnGoBackList" onclick="window.location.href='<%= ctxPath%>/approval/approvalPendingList'" style="background-color: #857c7a; padding: 5px; border-color: #857c7a; border-radius: 5px; color: white;">목록</button>
		</span>
	
		<div id="modalDraftType"></div>
		<div id="approvalLine"></div>
		<div id="modalClickBtn"></div>
		
		<div id="draft" style="margin: auto;"></div>
		
	</div>

</div>

<jsp:include page="../../footer/footer1.jsp" />  

