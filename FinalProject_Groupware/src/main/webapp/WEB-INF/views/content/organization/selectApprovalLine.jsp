<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>


<!DOCTYPE html>
<html>

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />

<%-- alert 창 --%>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" >
  
<%-- jsTree --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree-bootstrap-theme@1.0.1/dist/themes/proton/style.min.css" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">


<style>
	div.orgContainer {
		border: solid 0px red;
		
		margin: auto;
		margin-top: 2%;
	}
	

	<%-- show/hide/검색 --%>
	div#orgTop {
		margin: 3% 3% 1% 3%;		
	}
	
	<%-- show/hide 버튼 --%>
	button {
		border-radius: 5px;
		font-size: 10pt;
	}
	
	<%-- 조직도 --%>
	#tree {
	    margin-top: 3%;
	    margin-left: 3%;
	}
	
	<%-- 검색창 --%>
	input#member_name {
	  width: 500px;
	  height: 32px;
	  font-size: 15px;
	  border: 0;
	  border-radius: 15px;
	  outline: none;
	  padding-left: 10px;
	  background-color: rgb(233, 233, 233);
	}
</style>



<script type="text/javascript">
$(document).ready(function(){

	<%-- show 버튼을 누르면 모든 노드를 펼치기 --%>
	$("button#btnShow").click(function() {
        $('#tree').jstree("open_all");
    });
	
	<%-- hide 버튼을 누르면 모든 노드를 접기 --%>
	$("button#btnHide").click(function() {
        $('#tree').jstree("close_all");
    });
	
	
	<%-- 상위부서, 하위부서, 직원을 조회하여 하나의 배열에 담기 --%>
	$.ajax({
	    url: '<%= ctxPath%>/organization/selectAllOrg',
	    type: 'GET',
	    success: function(response) {
	        var treeData = [];
	
	        response.forEach(function(row) {
	            // 각 상위 부서의 ID를 기준으로 트리 노드를 찾거나 새로 생성
	            var parentDeptNode = treeData.find(function(dept) {
	                return dept.text === row.parent_dept_name;
	            });
	
	            if (!parentDeptNode) {
	            	var iconType = "";
	            	if(row.parent_dept_name == "진료부") {
	            		iconType = "fa-solid fa-stethoscope";
	            	}
	            	else if(row.parent_dept_name == "간호부") {
	            		iconType = "fa-solid fa-syringe";
	            	}
					else if(row.parent_dept_name == "경영지원부") {
						iconType = "fa-solid fa-building";
	            	}
	                parentDeptNode = {
	                    "text": row.parent_dept_name,
	                    "icon": iconType,
	                    "children": []
	                };
	                treeData.push(parentDeptNode);
	            }
	
	            // 각 하위 부서에 대한 처리
	            var childDeptNode = parentDeptNode.children.find(function(subDept) {
	                return subDept.text === row.child_dept_name;
	            });
	
	            if (!childDeptNode) {
	                childDeptNode = {
	                    "text": row.child_dept_name,
	                    "children": []
	                };
	                parentDeptNode.children.push(childDeptNode);
	            }
	
	            // 직원 추가
	            if (row.member_name) {
	                childDeptNode.children.push({
	                    "text": row.member_name,
	                    "icon": 'fa-solid fa-user',
	                    "data": { "member_userid": row.member_userid }
	                });
	            }
	        });
	
	        // 트리구조 배열 확인
	        // console.log(treeData);
	        
	        // 배열을 이용해 트리 구조 생성하기
	        jsTreeView(treeData);
	    },
	    error: function() {
			swal('조직도 불러오기 실패!',"다시 시도해주세요",'warning');
		}
	});
	

	<%-- 사원명 검색시 해당 노드만 펼쳐지는 이벤트 --%>
	$("input:text[name='member_name']").on("keyup", function(e){
		
		const member_name = $(e.target).val();
		$('#tree').jstree(true).search(member_name);
		
	});
	
});// end of $(document).ready(function(){})-----------------------------------------



/////////////////////////////////
//>>>> **** 함수 정의 **** <<<< //
////////////////////////////////

<%-- 배열을 이용해 트리 구조 생성하기 --%>
function jsTreeView(jsonData) {
	$('#tree').jstree({
		'plugins': ["wholerow"],
		'core' : {
			'data' : jsonData,
			'state': {
				'opened' : true
			},
			'themes' : {
				'name' : 'proton',
				'responsive' : true
			}
		},
        'plugins' : ["search"],
        "search": {
        	"case_sensitive": false,	// 대소문자 구분하지 않음
        	"show_only_matches": true,	// 일치하는 노드만 검색
        	"search_leaves_only": true	// 리프노드만 검색
        }

	});
}


</script>

<%-- ===================================================================== --%>
<body>
<div class="orgContainer">

	<div style="display: flex; flex-wrap: wrap; margin: 2%;">
	
		<div style="border-radius: 3px; flex: 4.5; overflow: auto;">
			<div id="orgTop">
				<button type="button" id="btnShow">Show</button>
				<button type="button" id="btnHide">Hide</button>
				<span >
					<input id="member_name" name="member_name" type="text" style="width: 90px; margin-left: 3%; font-size: 10pt;" placeholder="사원명 입력" />
					<!-- <button type="button" id="btnSearch">검색</button> -->
				</span>
			</div>
			<div id="tree"></div>
		</div>
		
	</div>
	
</div>

</body>
</html>