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
		padding-bottom: 7%;
		font-weight: bold;
	}
	
	.draftInfo {
		font-weight: bold;
		margin-bottom: 1%;
	}
	
	.input_margin {
		margin-top: 1.5%;
	}
</style>

<body>
	<div class="draftContainer" style="height: 600px; overflow: auto;">
		<h4 id="draftSubject" style="text-align: center;">휴가신청서</h4>
		<div>
			<div class="draftInfo" style="display: inline-block;">제목 :</div>
			<input type="text" class="form-control" style="display: inline-block; width: 90%; margin-left: 1%;" readonly/>
		</div>
		
		<hr style="border:0; height:1px; background: #bbb; margin: 3% 0.5%;">
			
		<div>
			<div class="draftInfo">구분</div>
			<div>
				<input type="radio" id="day" name="dayLeaveType"/>
				<label for="day">연차</label>
				
				<input type="radio" id="day_am" name="dayLeaveType" style="margin-left: 1%;" />
				<label for="day_am">오전반차</label>
				
				<input type="radio" id="da_pm" name="dayLeaveType" style="margin-left: 1%;"/>
				<label for="da_pm">오후반차</label>
			</div>
		</div>
		
		<div class="input_margin">
			<div class="draftInfo">휴가사유</div>
			<textarea class="form-control" style="width: 100%;" readonly></textarea>
		</div>
		
		<div class="input_margin" style="padding: 10px 0;">
			<div class="draftInfo">신청기간</div>
			<input type="date" class="form-control" style="width: 150px; display: inline-block;" readonly> 부터
			<input type="date" class="form-control" style="width: 150px; display: inline-block; margin-left: 10px;" readonly> 까지
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
		
	</div>
	
</body>
</html>