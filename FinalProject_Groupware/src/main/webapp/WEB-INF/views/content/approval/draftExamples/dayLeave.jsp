<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

   
<head>

<!-- SweetAlert2 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.0/dist/sweetalert2.min.css">

<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.0/dist/sweetalert2.min.js"></script>

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
</head>

<script type="text/javascript">
$(document).ready(function(){

	$("input:radio[id='amDay']").prop("checked", true);
	
	// ==== 오늘날짜 이후부터 선택하도록 한다 ==== //
	// 오늘 날짜 구하기
    const today = new Date();
	
 	// 오늘 날짜에 1일 추가
    today.setDate(today.getDate() + 1);
 	
    // 오늘 날짜를 구하기
    const todayDate = today.toISOString().slice(0, 10);  // 2025-02-26T00:00:00.000Z 에서 날짜만 가져오기
    
    // 날짜 최소값 설정
    $("input[name='allDay_leave_start']").attr('min', todayDate);
    $("input[name='allDay_leave_end']").attr('min', todayDate);
    $("input[name='halfDay_leave_end']").attr('min', todayDate);
    
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
	
	
	<%-- 연차 구분 클릭 이벤트 --%>
	$("input:radio[name='dayLeaveType']").on('click',function(e){
		
		const dayLeaveType = ($("input:radio[name='dayLeaveType']:checked").val());
		
		if(dayLeaveType == "연차") {
			$("div#halfDay").css({"display":"none"});
			$("div#allDay").css({"display":"block"});	
		}
		else if (dayLeaveType == "오전반차" || dayLeaveType == "오후반차") {
			$("div#halfDay").css({"display":"block"});
			$("div#allDay").css({"display":"none"});
		}
		
	});// end of $("input:radio").on('click',function(e){})-------------------------
	
	
	
	<%-- 연차시작일 변경 시 연차종료일 초기화 --%>
	$("input[name='allDay_leave_start']").on("change", function(){
		$("input[name='allDay_leave_end']").val("");
	});// end of $("input[name='allDay_leave_start']").on("click", function(){})-------------------
	
	
	<%-- 연차일수 계산 이벤트 --%>
	$("input[name='allDay_leave_end']").on("change", function(){

		const yeoncha = ${requestScope.paraMap.member_yeoncha}; // 잔여연차

		const day_leave_start = $("input[name='allDay_leave_start']").val();	// 연차시작일
		const day_leave_end = $("input[name='allDay_leave_end']").val();		// 연차종료일
		
		/// 문자열을 Date 객체로 변환
		const start_date = new Date(day_leave_start + "T00:00:00");  // 연차 시작일
		const end_date = new Date(day_leave_end + "T00:00:00");      // 연차 종료일
		
		// 오늘 날짜
		const today = new Date();
		
		// 두 날짜 간의 차이를 밀리초로 계산 및 일로 변환
		let day_leave_cnt = ((end_date.getTime() - start_date.getTime()) / (1000 * 60 * 60 * 24)) + 1 ;

		if(day_leave_cnt < 1) {
			// 시작날짜가 종료날짜 이후인 경우
			$("input[name='allDay_leave_start']").val("");
			$("input[name='allDay_leave_end']").val("");
			
			Swal.fire({
                title: '잘못된 날짜를 입력했습니다',
                text: "다시 시도해주세요",
                icon: 'error'
            });
			
		}
		else if (yeoncha < day_leave_cnt) {
			// 잔여연차보다 많은 일수를 지정한 경우
			$("input[name='allDay_leave_start']").val("");
			$("input[name='allDay_leave_end']").val("");
			
			Swal.fire({
			    title: '연차 일수를 초과하였습니다',
			    text: '신청 기간: ' + day_leave_cnt + ' / 잔여 연차: ' + yeoncha,
			    icon: 'error'
			});

		}
		else {
			
			$("span#day_leave_cnt").html(day_leave_cnt);
		}
		
	});// end of $("input[name='allDay_leave_start']").on("click", function(){})-------------------
	
	
	
	
});



/////////////////////////////////
// >>>> **** 함수 정의 **** <<<< //
////////////////////////////////

//===== 휴가사유 글자수를 세주는 함수 ===== //
function charCount(text, limit) {
    // 텍스트의 줄바꿈을 포함하여 글자 수 계산
    var text_value = text.value;
    
    // 줄바꿈을 2글자씩으로 처리하기 위해, 줄바꿈 문자 개수만큼 1을 더해줌
    var char_count = text_value.length + (text_value.match(/\n/g) || []).length;

    if (char_count > limit) {
       // 글자 수가 제한을 초과한 경우
        document.getElementById("char_count").innerHTML = "글자 수가 " + limit + "자를 초과했습니다. 현재 글자 수: " + char_count;

    } else {
        // 글자 수가 제한을 초과하지 않은 경우
        document.getElementById("char_count").innerHTML = char_count + " / " + limit;
    }
}// end of function charCount(text, length){}---------------------------

</script>


<%-- ===================================================================== --%>
<body>
	<div class="draftContainer" style="height: 650px; overflow: auto;">
		<input type="hidden" id="draftMode" value="insert" /> 
		<h2 id="draftSubject" style="text-align: center;">휴가신청서</h2>

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
			<div>
				<div class="draftInfo">구분</div>
				<div>
					<input type="radio" id="allDay" name="dayLeaveType" value="연차"/>
					<label for="allDay">연차</label>
					
					<input type="radio" id="amDay" name="dayLeaveType" style="margin-left: 1%;" value="오전반차"/>
					<label for="amDay">오전반차</label>
					
					<input type="radio" id="pmDay" name="dayLeaveType" style="margin-left: 1%;" value="오후반차"/>
					<label for="pmDay">오후반차</label>
				</div>
			</div>
			
			<div class="input_margin">
				<div>
					<div class="draftInfo" style="display: inline-block;">휴가사유</div>
					<span id="char_count" class="form-text text-muted" style="display: inline-block; float: right;">0 / 2000</span>
				</div>
				<textarea class="form-control" name="day_leave_reason" style="width: 100%; height: 150px;" onkeyup="charCount(this,2000)"></textarea>
			</div>
			
			<div id="halfDay" class="input_margin" style="padding: 10px 0;">
				<div class="draftInfo">신청기간</div>
				<input type="date" name="halfDay_leave_end" class="form-control" style="width: 150px; display: inline-block;"/> 
				<div style="display: inline-block;">총 0.5일 (잔여연차: ${requestScope.paraMap.member_yeoncha}일)</div>
			</div>
			
			<div id="allDay" class="input_margin" style="padding: 10px 0; display: none;">
				<div class="draftInfo">신청기간</div>
				<input type="date" name="allDay_leave_start" class="form-control" style="width: 150px; display: inline-block;"/> 부터
				<input type="date" name="allDay_leave_end" class="form-control" style="width: 150px; display: inline-block; margin-left: 10px;"/> 까지
				<div style="display: inline-block;">총 <span id="day_leave_cnt"></span>일 (잔여연차: ${requestScope.paraMap.member_yeoncha}일)</div>
			</div>
			
			<div class="input_margin">
				<div class="draftInfo">참고</div>
				<div style="font-size: 10pt; border: solid 1px gray; border-radius: 3px; padding: 0.5%;">
					1. 연차의 사용은 근로기준법에 따라 전년도에 발생한 개인별 잔여 연차에 한하여 사용함을 원칙으로 한다. <br>
					&nbsp;&nbsp;&nbsp;(단, 최초 입사시에는 근로 기준법에 따라 발생 예정된 연차를 차용하여 월 1회 사용 할 수 있다.)<br>
					2. 경조사 휴가는 행사일을 증명할 수 있는 가족 관계 증명서 또는 등본, 청첩장 등 제출<br>
					3. 공가(예비군/민방위)는 사전에 통지서를, 사후에 참석증을 반드시 제출
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
		</form>
	</div>
</body>	
</html>