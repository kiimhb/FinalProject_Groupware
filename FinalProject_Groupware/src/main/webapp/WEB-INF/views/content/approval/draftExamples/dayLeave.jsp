<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<style>
	.draftContainer {
		border: solid 1px gray;
		border-radius: 3px;
		margin: 2%;
		padding: 1.5%;
	}
	
	#draftSubject {
		padding-top: 3%;
		padding-bottom: 3%;
		font-weight: bold;
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
</style>


<script type="text/javascript">
$(document).ready(function(){
	
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
		
		<div style="border: solid 1px red">
			<div style="border: solid 1px blue">
				<table class="table">
					<tr>
						<td colspan="2">문서정보</td>
					</tr>
					<tr>
						<td>기안자</td>
						<td>이순신</td>
					</tr>
					<tr>
						<td>소속</td>
						<td>간호부</td>
					</tr>
					<tr>
						<td>기안일</td>
						<td>2025/02/10</td>
					</tr>
					<tr>
						<td>문서번호</td>
						<td>20250210-001</td>
					</tr>
				</table>
			</div>
			<div>
				<table class="table">
					<tr>
						<td colspan="2">결재정보</td>
					</tr>
					<tr>
						<td>기자</td>
						<td>이순ㅇㄹㄴㄹㄴㅇㅇ신</td>
					</tr>
					<tr>
						<td>소속</td>
						<td>간호부</td>
					</tr>
					<tr>
						<td>기안일</td>
						<td>2025/02/10</td>
					</tr>
					<tr>
						<td>문서번호</td>
						<td>20250210-001</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div>
			<div class="draftInfo" style="display: inline-block;">제목 :</div>
			<input type="text" class="form-control" style="display: inline-block; width: 90%; margin-left: 1%;"/>
		</div>
		
		<hr style="border: solid 1px gray; margin: 3% 0.5%;">
			
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
			<input type="file"/>
		</div>
		
	</div>
	
</body>
</html>