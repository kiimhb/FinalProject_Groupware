<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

   
<head>
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
		font-size: 14pt;
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
		font-size: 13pt !important;
		font-weight: bold !important;
		padding-bottom: 4%;
	}
	
	.table_title {
		font-weight: bold;
		text-align: center;
		background-color: #eee;
	}
	
	.topTables {
		font-size: 10pt;
		margin-bottom: 5%;
	}
	
	.table_approval tr td,
	.table-bordered tr td{
		text-align: center;
	} #table_approval > tbody > tr:nth-child(3) > td:nth-child(2)
	
	
</style>
</head>

<script type="text/javascript">
$(document).ready(function(){
	
	
	
	
	
	
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
			
			let html = `<div style="display: flex;"><span style="padding-left: 2%;"><i class="fa-solid fa-paperclip"></i>&nbsp;\${file.name}</span><span id="fileSize" style="margin-left: auto; padding-right: 4%;">\${file.size}KB</span><i id="fileDel" class="fa-regular fa-rectangle-xmark" style="margin: auto 1%;">&nbsp;</i></div>`;
			
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
			
			let html = `<div style="display: flex;"><span style="padding-left: 2%;"><i class="fa-solid fa-paperclip"></i>&nbsp;\${file.name}</span><span id="fileSize" style="margin-left: auto; padding-right: 4%;">\${file.size}KB</span><i id="fileDel" class="fa-regular fa-rectangle-xmark" style="margin: auto 1%;">&nbsp;</i></div>`;
			
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
	<div class="draftContainer" style="height: 600px; overflow: auto;">
		<h2 id="draftSubject" style="text-align: center;">휴가신청서</h2>
		
		<form action="">
			<div class="topTables" style="display: flex;">
				<div style="border: solid 0px blue; flex: 2; vertical-align: top;">
					<div class="table_header" style="padding-bottom: 4%">문서정보</div>
					<table class="table-bordered" style="width: 80%;">
						<tr>
							<td class="table_title">기안자</td>
							<td>이순신</td>
						</tr>
						<tr>
							<td class="table_title">소속</td>
							<td>간호부</td>
						</tr>
						<tr>
							<td class="table_title">기안일</td>
							<td>2025/02/10</td>
						</tr>
						<tr>
							<td class="table_title">문서번호</td>
							<td>20250210-001</td>
						</tr>
					</table>
				</div>
				
				<div style="border: solid 0px green; flex: 3;">
					<div style="border: solid 0px orange; float: right; width: 85%;">
						<div class="table_header">결재선</div>
						<table class="table-bordered table_approval" class="table-bordered" style=" float: right; width: 100%;">	
							<tr>
								<td class="table_title">순서</td>
								<td>1</td>
								<td>2</td>
								<td>3</td>	
							</tr>
							<tr>
								<td class="table_title">소속</td>	
								<td>의사</td>
								<td>의사</td>
								<td>의사</td>
							</tr>
							<tr>
								<td class="table_title">부서</td>
								<td>순환기내과</td>
								<td>순환기내과</td>
								<td>순환기내과</td>
							</tr>
							<tr>
								<td class="table_title">성명</td>		
								<td>강감찬</td>
								<td>강감찬</td>
								<td>강감찬</td>
							</tr>
							<tr>
								<td class="table_title">결재상태</td>
								<td><div style="border: solid 1px gray; width: 70%; height: 80px; margin: auto;"></div></td>
								<td><div style="border: solid 1px gray; width: 70%; height: 80px; margin: auto;"></div></td>
								<td><div style="border: solid 1px gray; width: 70%; height: 80px; margin: auto;"></div></td>
							</tr>
						</table>
					</div>
					
					<div style="border: solid 0px orange; float: right; width: 80%; margin-top: 8%;">
						<div class="table_header">참조자</div>
						<table class="table-bordered" style="width: 100%;">
							<tr>
								<td class="table_title">소속</td>
								<td class="table_title">직급</td>
								<td class="table_title">성명</td>
								
							</tr>
							<tr>
								<td>간호부</td>
								<td>간호사</td>
								<td>엄정화</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			
			<hr style="border: solid 1px gray; margin: 3% 0.5%;">
			
			<div>
				<div class="draftInfo" style="display: inline-block;">제목 :</div>
				<input type="text" class="form-control" style="display: inline-block; width: 90%; margin-left: 1%;"/>
			</div>
			
			<hr style="border:0; height:1px; background: #bbb; margin: 3% 0.5%;">
			<div>
				<div class="draftInfo">구분</div>
				<div>
					<input type="radio" id="allDay" name="dayLeaveType"/>
					<label for="allDay">연차</label>
					
					<input type="radio" id="amDay" name="dayLeaveType" style="margin-left: 1%;" />
					<label for="amDay">오전반차</label>
					
					<input type="radio" id="pmDay" name="dayLeaveType" style="margin-left: 1%;"/>
					<label for="pmDay">오후반차</label>
				</div>
			</div>
			
			<div class="input_margin">
				<div>
					<div class="draftInfo" style="display: inline-block;">휴가사유</div>
					<span id="char_count" class="form-text text-muted" style="display: inline-block; float: right;">0 / 2000</span>
				</div>
				<textarea class="form-control" style="width: 100%;" onkeyup="charCount(this,2000)"></textarea>
			</div>
			
			<div class="input_margin" style="padding: 10px 0;">
				<div class="draftInfo">신청기간</div>
				<input type="date" class="form-control" style="width: 150px; display: inline-block;"/> 부터
				<input type="date" class="form-control" style="width: 150px; display: inline-block; margin-left: 10px;"/> 까지
				<div style="display: inline-block;">(총 0일)</div>
			</div>
			
			<div class="input_margin">
				<div class="draftInfo">참고</div>
				<div style="font-size: 9pt; border: solid 1px gray; border-radius: 3px; padding: 0.5%;">
					1. 연차의 사용은 근로기준법에 따라 전년도에 발생한 개인별 잔여 연차에 한하여 사용함을 원칙으로 한다. 단, 최초 입사시에는 근로 기준법에 따라 발생 예정된 연차를 차용하여 월 1회 사용 할 수 있다.<br>
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
	
	        
			</form>
	</div>
</body>	
</html>