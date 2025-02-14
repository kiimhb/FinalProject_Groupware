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
		<h4 id="draftSubject" style="text-align: center;">출장신청서</h4>
		<div>
			<div class="draftInfo" style="display: inline-block;">제목 :</div>
			<input type="text" class="form-control" style="display: inline-block; width: 90%; margin-left: 1%;" readonly/>
		</div>
		
		<hr style="border:0; height:1px; background: #bbb; margin: 3% 0.5%;">
		
		<div class="input_margin">
			<div class="draftInfo">출장목적(내용)</div>
			<textarea class="form-control" style="width: 100%;" readonly></textarea>
		</div>
		
		<div class="input_margin">
			<div class="draftInfo">출장지</div>
			<input type="text" class="form-control" style="width: 40%;" readonly />
		</div>
		
		<div class="input_margin" style="padding: 10px 0;">
			<div class="draftInfo">신청기간</div>
			<input type="date" class="form-control" style="width: 150px; display: inline-block;" readonly> 부터
			<input type="date" class="form-control" style="width: 150px; display: inline-block; margin-left: 10px;" readonly> 까지
			<div style="display: inline-block;">(총 0일)</div>
		</div>
		
	</div>
	
</body>
</html>