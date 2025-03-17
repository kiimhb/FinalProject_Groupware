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
		<h4 id="draftSubject" style="text-align: center;">근무 변경 신청서</h4>
		<div>
			<div class="draftInfo" style="display: inline-block;">제목 :</div>
			<input type="text" class="form-control" style="display: inline-block; width: 90%; margin-left: 1%;" readonly/>
		</div>
		
		<hr style="border:0; height:1px; background: #bbb; margin: 3% 0.5%;">
		
		<div class="input_margin">
			<div class="draftInfo">변경사유</div>
			<textarea class="form-control" style="width: 100%;" readonly></textarea>
		</div>
		
		<div class="input_margin" style="padding: 10px 0;">
			<div class="draftInfo">변경 요청 일자</div>
			<input type="date" class="form-control" style="width: 150px; display: inline-block;" readonly> 부터
			<input type="date" class="form-control" style="width: 150px; display: inline-block; margin-left: 10px;" readonly> 까지
			<div style="display: inline-block;">(총 0일)</div>
		</div>
		
		<div class="input_margin">
			<div class="draftInfo">참고</div>
			<div style="font-size: 8.5pt; border: solid 1px gray; border-radius: 3px; padding: 0.5%;">
				1. 근무변경은 원칙적으로 사전 승인된 경우에만 허용된다. <br>    
				&nbsp;(단, 불가피한 사유로 근무 변경이 필요한 경우, 사후 승인을 받아야 하며 사유서 및 관련 서류를 제출해야 한다.)<br>
				2. 긴급한 사유에 의한 근무변경 <br>    
				- 긴급한 사유로 근무 변경이 필요한 경우, 사전 승인을 받지 못한 경우라도 사후에 즉시 사유서를 제출하고 승인을 받아야 한다.<br> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이 경우에도 반드시 관련 서류(예: 법적 증빙 서류 등)를 제출해야 한다.<br>
				3. 근무변경에 따른 유의사항 <br>    
				- 근무 변경을 승인받은 후에는 변경된 근무 일정에 맞추어 작업을 수행해야 하며, 변동 사항이 생길 경우 즉시 관리자에게 보고해야 한다.<br>
			</div>
		</div>
				
	</div>
	
</body>
</html>