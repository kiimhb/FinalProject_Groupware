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
	
	.table th {
		text-align: center;
    	border-top: 2px solid gray !important;
    	border-bottom: 2px solid gray !important;
  	}
  	
  	.table td {
    	border-bottom: 1px solid gray !important;
  	}
  
</style>

<body>
	<div class="draftContainer" style="height: 600px; overflow: auto;">
		<h4 id="draftSubject" style="text-align: center;">지출결의서</h4>
		<div>
			<div class="draftInfo" style="display: inline-block;">제목 :</div>
			<input type="text" class="form-control" style="display: inline-block; width: 90%; margin-left: 1%;" readonly/>
		</div>
		
		<hr style="border: solid 1px gray; margin: 3% 0.5%;">
		
		<div class="input_margin">
			<div class="draftInfo">지출사유</div>
			<textarea class="form-control" style="width: 100%;" readonly></textarea>
		</div>
		
		<div class="input_margin" style="padding: 10px 0;">
			<div class="draftInfo">지출내역</div>
				<table class="table">
					<thead>
						<tr>
							<th>지출일자</th>
							<th>내역</th>							
							<th>수량</th>							
							<th>금액</th>							
							<th>총 지출액</th>							
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="col-3"><input type="date" class="form-control" readonly></td>
							<td class="col-3"><input type="text" class="form-control" readonly></td>
							<td class="col-2"><input type="number" class="form-control" readonly></td>
							<td class="col-2"><input type="text" class="form-control" readonly></td>
							<td class="col-2"><input type="text" class="form-control" readonly></td>
						</tr>
					</tbody>
				</table>
		</div>
		
	</div>
	
</body>
</html>