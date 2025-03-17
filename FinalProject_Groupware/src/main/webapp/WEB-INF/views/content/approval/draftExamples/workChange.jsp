<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<style>
	.draftContainer {
		border: solid 1px gray;
		border-radius: 3px;
		margin: 2%;
		padding: 2.5%;
	}
	
	#draftSubject {
		padding-top: 3%;
		padding-bottom: 4%;
		font-weight: bold;
		background-color: #eee;
		margin: 1% 0 5% 0;
	}
	
	.draftInfo {
		font-weight: bold;
		font-size: 15.5pt;
		margin-bottom: 1%;
	}
	
	.input_margin {
		margin-top: 1.5%;
	}
	
	label {
    	cursor: pointer;
	}
	
	<%-- 테이블 --%>
	body table tr {
		height: 20px;
	}

	.table_header {
		font-size: 15pt !important;
		font-weight: bold !important;
		padding-bottom: 4%;
	}

	.table_title {
		font-weight: bold;
		text-align: center;
		background-color: #eee;
	}

	.topTables {
		font-size: 11.5pt;
		margin-bottom: 5%;
	}

	.table_approval tr td,
	.table-bordered tr td{
		text-align: center;
	}

	table#designated_line_Table {
		width: auto;
		table-layout: auto;
	}
</style>

<script type="text/javascript">
$(document).ready(function(){
	
	// ==== 오늘날짜 이후부터 선택하도록 한다 ==== //
	// 오늘 날짜 구하기
    const today = new Date();
	
 	// 오늘 날짜에 1일 추가
    today.setDate(today.getDate() + 1);
 	
    // 오늘 날짜를 구하기
    const todayDate = today.toISOString().slice(0, 10);  // 2025-02-26T00:00:00.000Z 에서 날짜만 가져오기
    
    // 날짜 최소값 설정
    $("input[name='work_change_start']").attr('min', todayDate);
    $("input[name='work_change_end']").attr('min', todayDate);
    
	////////////////////////////////////////////////////////////////////////////////

	// ===== (Drag & Drop) 첨부파일 추가 이벤트 ===== //
	const fileAdd = $("div#fileAdd").hide();
	const fileZone =  $("label#fileLabel");
	let file_arr = [];

	fileZone.on("dragneter", function(e){
		e.preventDefault();
		e.stopPropagation();
	}).on("dragover", function(e){
		e.preventDefault();
		e.stopPropagation();
		$(this).css("background-color", "#403D39");
	}).on("dragleave", function(e){
		e.preventDefault();
		e.stopPropagation();
		$(this).css("background-color", "#eee");
	}).on("drop", function(e){
		e.preventDefault();
		
		var fileList = e.originalEvent.dataTransfer.files;
		var file = fileList[0];
		
		//alert(file.name);
		
		if(file != null && file != undefined) {
			
			// 배열에 해당 파일을 넣는다.
			file_arr.push(file);
			
			let html = `<div style="display: flex; height: 35px;"><span style="padding-top: 5px; padding-left: 2%;"><i class="fa-solid fa-paperclip"></i>&nbsp;\${file.name}</span><span id="fileSize" style="margin-left: auto; padding-top: 5px; padding-right: 4%;">\${file.size}KB</span><i id="fileDel" class="fa-regular fa-rectangle-xmark" style="margin: auto 1%;">&nbsp;</i></div>`;
			
			fileZone.hide();
			fileAdd.append(html).show();
		}
	});// end of fileZone.on("dragneter", function(e){})-------------------------------


	// ===== (클릭) 첨부파일 추가 이벤트 ===== //
	$("input[id='fileInput']").on("change", function(e){
		
		var fileList = e.target.files;
		var file = fileList[0];
		
		if(file != null && file != undefined) {
			
		// 배열에 해당 파일을 넣는다.
		file_arr.push(file);
			
			let html = `<div style="display: flex; height: 35px;"><span style="padding-top: 5px; padding-left: 2%;"><i class="fa-solid fa-paperclip"></i>&nbsp;\${file.name}</span><span id="fileSize" style="margin-left: auto; padding-top: 5px; padding-right: 4%;">\${file.size}KB</span><i id="fileDel" class="fa-regular fa-rectangle-xmark" style="margin: auto 1%;">&nbsp;</i></div>`;
			
			fileZone.hide();
			fileAdd.append(html).show();
		}
	});// end of fileZone.on("change", function(e){})---------------------------------


	// ===== 첨부파일 삭제 이벤트 ===== //
	// >>> [x] 마우스 이벤트 <<<
	$("div#fileAdd").on("mouseover", "i#fileDel", function(e) {
		$(e.target).css("color", "red");
	}).on("mouseout", "i#fileDel", function(e) {
		$(e.target).css("color", ""); // 원래 색상으로 복원
	});// end of $("i#fileDel").on("mouseover", function(){})-------------------------

	// >>> [x] 클릭 이벤트 <<< 
	$("div#fileAdd").on("click", function(e) {
		
		// 배열에서 파일삭제
		file_arr.splice(0,1);
		
		// 올려뒀던 파일 없애기
		fileAdd.append("").hide();
		
		// html 로 append 한 파일이름과 사이즈 등 정보 삭제
	    $(e.target).closest("div").remove();
		
		// 다시 파일 드래그 영역 보이기
		fileZone.css("background-color", "#eee").show();
	});// end of $("div#fileAdd").on("mouseover", function(e) {})----------------------

	////////////////////////////////////////////////////////////////////////////////
	
	
	<%-- 근무변경 시작일 변경 시 연차종료일 초기화 --%>
	$("input[name='work_change_start']").on("change", function(){
		$("input[name='work_change_end']").val("");
	});// end of $("input[name='work_change_start']").on("click", function(){})-------------------


	<%-- 근무변경일수 계산 이벤트 --%>
	$("input[name='work_change_end']").on("change", function(){
		calc_day_cnt();
	});// end of $("input[name='allDay_leave_start']").on("click", function(){})-------------------
		
});	


/////////////////////////////////
// >>>> **** 함수 정의 **** <<<< //
////////////////////////////////
//===== 근무변경일수 계산 이벤트 ===== //
function calc_day_cnt() {
	
	const day_leave_start = $("input[name='work_change_start']").val();	// 근무변경 시작일
	const day_leave_end = $("input[name='work_change_end']").val();		// 근무변경 종료일
	
	/// 문자열을 Date 객체로 변환
	const start_date = new Date(day_leave_start + "T00:00:00");  // 근무변경 시작일
	const end_date = new Date(day_leave_end + "T00:00:00");      // 근무변경 종료일
	
	// 오늘 날짜
	const today = new Date();
	
	// 두 날짜 간의 차이를 밀리초로 계산 및 일로 변환
	let day_leave_cnt = ((end_date.getTime() - start_date.getTime()) / (1000 * 60 * 60 * 24)) + 1 ;

	if(day_leave_cnt < 1) {
		// 시작날짜가 종료날짜 이후인 경우
		$("input[name='work_change_start']").val("");
		$("input[name='work_change_end']").val("");
		
		Swal.fire({
            title: '잘못된 날짜를 입력했습니다',
            text: "다시 시도해주세요",
            icon: 'error'
        });
		
	}
	else {
		
		$("span#day_cnt").text(day_leave_cnt);
	}
}
</script>	

<%-- ===================================================================== --%>
<body>
	<div class="draftContainer" style="height: 600px; overflow: auto;">
		<input type="hidden" name="draftMode" id="draftMode" value="insert" /> 
		<h2 id="draftSubject" style="text-align: center;">근무 변경 신청서</h2>
		
		<form action="">
			<div class="topTables" style="display: flex;">
				<div style="border: solid 0px blue; flex: 2; vertical-align: top;">
					<div class="table_header" style="padding-bottom: 4%">문서정보</div>
					<table class="table-bordered" style="width: 80%; line-height: 2.3;">
						<tr>
							<td class="table_title">기안자</td>
							<td id="member_name"><span id="member_userid" style="display: none;">${requestScope.paraMap.memverInfo.member_userid}</span>${requestScope.paraMap.memverInfo.member_name}</td>
						</tr>
						<tr>
							<td class="table_title">부문</td>
							<td id="parent_dept_name">${requestScope.paraMap.memverInfo.parent_dept_name}</td>
						</tr>
						<tr>
							<td class="table_title">부서</td>
							<td id="child_dept_name">${requestScope.paraMap.memverInfo.child_dept_name}</td>
						</tr>
						<tr>
							<td class="table_title">직책</td>
							<td id="member_position">${requestScope.paraMap.memverInfo.member_position}</td>
						</tr>
						<tr>
							<td class="table_title">기안일</td>
							<td id="draft_write_date">${requestScope.paraMap.now_date}</td>
						</tr>
						<tr>
							<td class="table_title">문서번호</td>
							<td id="draft_no">${requestScope.paraMap.draft_no}</td>
						</tr>
					</table>
				</div>
				
				
				<div style="border: solid 0px green; flex: 3;">
					<div id="undesignated_line_total" style="border: solid 0px orange; float: right; width: 73%;">
						<div class="table_header">결재선</div>
						<div id="undesignated_line" style="width: 100%; height: 174px; background-color: #eee"></div>
							<table id="designated_line_Table" class="table-bordered table_approval table-bordered" style="display: none; float: right; line-height: 2.3;">	
								<tr class="approvalLine_view" id="approvalLine_1"></tr>
								<tr class="approvalLine_view" id="approvalLine_2"></tr>
								<tr class="approvalLine_view" id="approvalLine_3"></tr>
								<tr class="approvalLine_view" id="approvalLine_4"></tr>
								<tr class="approvalLine_view" id="approvalLine_5"></tr>
							</table>
						</div>
					
						<div id="undesignated_refer_total" style="border: solid 0px orange; float: right; width: 80%; margin-top: 8%;">
							<div class="table_header">참조자</div>
							<div id="undesignated_refer" style="width: 100%; height: 60px; background-color: #eee"></div>
							<table id="undesignated_refer_Table" class="table-bordered" style="width: 100%; display:none; line-height: 2.3;">
							</table>
						</div>
					</div>
				</div>
				
				<hr style="border: solid 1px gray; margin: 3% 0.5%;">
				
				<div>
					<div class="draftInfo" style="display: inline-block;">제목 :</div>
					<input type="text" class="form-control" name="draft_subject" style="display: inline-block; width: 80%; margin-left: 1%;"/>
									
					<span style="display: inline-block; margin-left: 3%;">
						<span>긴급</span>
						<input type="checkbox" name="draft_urgent"/>
					</span>
				</div>
				
				<hr style="border:0; height:1px; background: #bbb; margin: 3% 0.5%;">
				
				<div class="input_margin">
					<div class="draftInfo">변경사유</div>
					<textarea name="work_change_reason" class="form-control" style="width: 100%; height: 150px;" ></textarea>
				</div>
				
				<div class="input_margin" style="padding: 10px 0;">
					<div class="draftInfo">변경 요청 일자</div>
					<input name="work_change_start" type="date" class="form-control" style="width: 150px; display: inline-block;"> 부터
					<input name="work_change_end" type="date" class="form-control" style="width: 150px; display: inline-block; margin-left: 10px;"> 까지
					<div id="dayCnt_workChange" style="display: inline-block;">(총 <span id="day_cnt"></span>일)</div>
				</div>
				
				<div class="input_margin" style="padding: 10px 0;">
					<div class="draftInfo">변경 시간</div>
					<select name="work_change_member_workingTime" class="form-control" style="width: 150px; display: inline-block;">
						<option value="">선택</option>
						<option value="day">day</option>
						<option value="evening">evening</option>
						<option value="night">night</option>
					</select>
				</div>
				
				<div class="input_margin">
					<div class="draftInfo">참고</div>
					<div style="font-size: 10pt; border: solid 1px gray; border-radius: 3px; padding: 0.5%;">
						1. 근무변경은 원칙적으로 사전 승인된 경우에만 허용된다. <br>    
						&nbsp;(단, 불가피한 사유로 근무 변경이 필요한 경우, 사후 승인을 받아야 하며 사유서 및 관련 서류를 제출해야 한다.)<br>
						2. 긴급한 사유에 의한 근무변경 <br>    
						- 긴급한 사유로 근무 변경이 필요한 경우, 사전 승인을 받지 못한 경우라도 사후에 즉시 사유서를 제출하고 승인을 받아야 한다.<br> 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이 경우에도 반드시 관련 서류(예: 법적 증빙 서류 등)를 제출해야 한다.<br>
						3. 근무변경에 따른 유의사항 <br>    
						- 근무 변경을 승인받은 후에는 변경된 근무 일정에 맞추어 작업을 수행해야 하며, 변동 사항이 생길 경우 즉시 관리자에게 보고해야 한다.<br>
					</div>
				</div>
				
				<hr style="border: solid 1px gray; margin: 3% 0.5%;">
				
				<div style="margin-top: -1%;">
					<div class="draftInfo">첨부파일</div>
					<label id="fileLabel" class="fileLabel" for="fileInput" style="cursor: pointer; height: 80px; border-radius: 8px; font-size: 16px; line-height: 80px; text-align: center; width: 100%; background-color: #eee;">
		  				드래그하거나 클릭해서 업로드
					</label>
			    	<input id="fileInput" class="fileInput" accept="image/*" type="file" required multiple hidden="true" />
			    	<div id="fileAdd" style="cursor: pointer; border-radius: 8px; font-size: 16px; text-align: center; width: 100%; background-color: #eee;"></div>
				</div> 
				
				<div id="feedback" class="input_margin" style="display: none; margin-top: 3%;">
					<div class="draftInfo" >결재 의견</div>
					<div id="feedbackContainer" style="border: solid 1px #eee; border-radius: 3px;">
						<div id="defaultFeedback" style="display: flex; height: 50px; justify-content: center; align-items: center; background-color: #eee;">결재 의견이 비어 있습니다.</div>
					</div>
				</div>
							
			</div>
		</form>
	</div>
</body>
</html>