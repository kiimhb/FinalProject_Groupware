<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String ctxPath = request.getContextPath();
//     /myspring
%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/management/commuteList.css" />

<jsp:include page="../../header/header1.jsp" />

<script src="<%= ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/drilldown.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>


<script type="text/javascript">
//===검색기능 js===//
$(document).ready(function(){
	$("input:text[name='searchWord']").bind("keyup", function(e){
		 if(e.keyCode == 13){ // 엔터를 했을 경우
		  goSearch();
		 }
	});
	
	// 검색시 검색조건 및 검색어 값 유지시키기
	if(${not empty requestScope.paraMap}) {
	 $("select[name='searchType']").val("${requestScope.paraMap.searchType}");
	 $("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
	}
});// end of $("input[name='searchWord']").keyup(function(){})--------
	   
	   
$(document).on("click", "span.result", function(e){
	 const word = $(e.target).text();
	 $("input[name='searchWord']").val(word); 
	 $("div#displayList").hide();
	 goSearch();
});   

function goSearch() {
	 const frm = document.searchFrm;
	 frm.submit();
}// end of function goSearch()-----------------






$(document).ready(function () {
    $.ajax({
        url: "<%= ctxPath%>/management/management_chart",  
        dataType: "json",
        success: function (json) {
         // console.log(JSON.stringify(json));
         
        	  let deptnameArr = [];  // 상위 부서 배열
              let drilldownArr = {};  // 하위 부서 배열 

              $.each(json, function (index, item) {

                  if (item && item.parent_dept && item.parent_total && item.child_dept && item.percentage) {
                      deptnameArr.push({
                          name: item.parent_dept,  
                          y: parseFloat(item.parent_total),  
                          drilldown: item.parent_dept  
                      });

                      if (!drilldownArr[item.parent_dept]) {
                          drilldownArr[item.parent_dept] = {
                              name: item.parent_dept,
                              id: item.parent_dept,
                              data: []  // 하위 부서별 비율 저장
                          };
                      }
                      drilldownArr[item.parent_dept].data.push([item.child_dept, parseFloat(item.members)]);
                  } 
              });

              let drilldownData = [];
              for (let dept in drilldownArr) {
                  drilldownData.push(drilldownArr[dept]);
              }

              //console.log("Drilldown 데이터: ", JSON.stringify(drilldownData));

              Highcharts.chart('chart_container', {
            	    chart: {
            	        type: 'column'  
            	    },
            	    title: {
            	        text: '상위 부서별 직원 비율'
            	    },
            	    colors: ['#f68b1f','#006769', '#ffff7d', '#4c4d4f', '#b3d6d2', '#f334c6', '#509d9c',  '#857c7a',  '#8ac2bd'], 
            	    xAxis: {
            	        type: 'category',  
            	        labels: {
            	            rotation: 0 
            	        }
            	    },
            	    yAxis: {
            	        title: {
            	            text: '비율 (%)'
            	        }
            	    },
            	   
            	    series: [{
            	        name: '하위 부서',
            	        colorByPoint: true,
            	        data: deptnameArr   
            	    }],
            	    
            	    drilldown: {
            	        series: drilldownData  
            	    }
            	});
          },
          error: function (request, status, error) {
              alert("code: " + request.status + "\nmessage: " + request.responseText + "\nerror: " + error);
          }
      });
    
});  
    
$(document).ready(function () {    
    $.ajax({
        url: "<%= ctxPath%>/management/management_chart2",  
        dataType: "json",
        success: function (json) {
           // console.log(JSON.stringify(json));

            let categories = []; 
            let leaveCounts = []; 

            json.forEach(item => {
            	
                categories.push(item.child_dept);
                leaveCounts.push({
                    name: item.child_dept, // 부서명
                    y: parseFloat(item.child_leave_cnt) || 0 ,  // 연차 사용량
                    deptCount: parseInt(item.child_dept_count) || 0 // 부서 직원 수
                });
            });
            
            //console.log("연차 사용량 데이터:", leaveCounts);

            Highcharts.chart('chart_container2', {
                chart: {
                    type: 'pie'  // 원형 차트
                },
                title: {
                    text: '부서별 연차 사용량 비율'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b><br>연차 사용: <b>{point.y}일</b><br>부서 직원 수: <b>{point.deptCount}명</b>',
                },
                colors: [ '#fee4c6' ,'#ffff7d','#b3d6d2', '#f68b1f', '#4c4d4f',  '#f334c6',   '#006769',  '#8ac2bd' , '#857c7a' ,'#509d9c'],
                series: [{
                    name: '연차 사용량',
                    colorByPoint: true,
                    data: leaveCounts
                }]
            });
        },
        error: function (request, status, error) {
            alert("code: " + request.status + "\nmessage: " + request.responseText + "\nerror: " + error);
        }
    });

    
  });

</script>





<div id="sub_mycontent">

	<div class="manag_h3">
		<h3>인사관리 <근태집계내역 조회> </h3>
	</div>

	<div id="sub_chart">
	
	<div id="chart_container"></div>
	
	<div id="chart_container2"></div>
	
	</div>
	
	
	<div id="sub_commuteList">
	
	
		
		
			<form name="searchFrm">
				<select name="searchType" style="height: 26px;">
					<option value="userid">사번명</option>
					<option value="name">사원명</option>
				</select> <input type="text" name="searchWord" size="10" autocomplete="off" />
				<input type="text" style="display: none;" />
				<button type="button" class="searchFrm_btn" onclick="goSearch()" style="border: none; padding: 3px; width: 55px;">검색</button>
			</form>

		<div class="commuteList">
			<table class="commuteListTable">
				<thead>
					<tr>
						<th>순서</th>
						<th>사번</th>
						<th>성명</th>
						<th>하위부서명</th>
						<th>직급</th>
						
						<th>사고계</th>
						<th>기초계</th>
						
						<th>휴가</th>
						<th>기타</th>
						<th>계</th>
						
						<th>정상</th>
						<th>지각</th>
						<th>조퇴</th>
						<th>결근</th>
						<th>계</th>
					</tr>
				</thead>

				<tbody>
					<c:if test="${not empty requestScope.commuteList}">
						<c:forEach var="commuteListVO" items="${requestScope.commuteList}"
							varStatus="status">
							<tr>
								<td align="center" id="pageBar">${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (status.index) }</td>
								<td>${commuteListVO.member_userid}</td>
								<td>${commuteListVO.member_name}</td>
								<td>${commuteListVO.child_dept_name}</td>
								<td>${commuteListVO.member_position}</td>


								<td>${commuteListVO.day_leave_cnt}</td>
								<td>${commuteListVO.total_count}</td>
								

								<td>${commuteListVO.day_leave_cnt}</td>
								<td>0</td>
								<td>${commuteListVO.day_leave_cnt}</td>
								
								
								<td>${commuteListVO.click}</td>
								<td>${commuteListVO.late}</td>
								<td>${commuteListVO.leave}</td>
								<td>${commuteListVO.absent}</td>
								<td>${commuteListVO.total_count}</td>
							</tr>
						</c:forEach>
					</c:if>

					<c:if test="${empty requestScope.commuteList}">
						<tr>
							<td colspan="15">조회할 근태내역집계가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
		
		
			<div>
				<div align="center"
					style="border: solid 0px gray; width: 80%; margin: 20px auto;">${requestScope.pageBar}</div>
			</div>
		</div>

</div>


<jsp:include page="../../footer/footer1.jsp" />
