<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>

<jsp:include page="../../header/header1.jsp" />

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />

<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>

<style>
	div.orgContainer {
		border: solid 1px red;
		width: 95%;
		margin: auto;
		margin-top: 2%;
	}
	
	h2 {
		margin-left: 2%;
		margin-top: 1%;
		margin-bottom: 3%;
	}
</style>



<script type="text/javascript">
$(document).ready(function(){
	
	
	// ===== jsTree 데이터 구조 만들기 ===== //
	let json = new Array();
	json.push({
		{ "id" : "1", "parent" : "#", "ASAC" : "Simple root node" }
	});
	
	// ===== 상위 부서를 불러온다 ===== //
	$.ajax({
		url: "<%= ctxPath%>/organization/parentDept",
		dataType:"json",
		type:"get",
		success: function(result) {
			alert(result.stringify);
		},
		error: function() {
			swal('상위부서 불러오기 실패!',"다시 시도해주세요",'warning');
		}
	});// end of $.ajax({})--------------------------
	
});// end of $(document).ready(function(){})-----------------------------



/////////////////////////////////
//>>>> **** 함수 정의 **** <<<< //
////////////////////////////////

</script>

<%-- ===================================================================== --%>

<div class="orgContainer">
	<h2>조직도</h2>
	
	<div style="display: flex;">
		<div style="border:solid 1px red; flex: 4.5;">
			<button type="button" id="btnShow">Show</button>
			<button type="button" id="btnHide">Hide</button>
			<span style="float: right;">
				<input type="text"  />
				<button type="button" id="btnSearch" style="">검색</button>
			</span>
			<div id="orgChartZone"></div>
		</div>
		<div style="border:solid 1px green; flex: 5.5;">
			<div id="memberInfo">
				<div id="tree2">
				<input type="text" id="text"value="cherry">
			</div>
			<button type="button" onclick="fn_extends()" >Extends</button>
			<button type="button" onclick="fn_collapse()" >collapse</button>
				
			</div>
		</div>
	</div>
	
</div>
<script>
$(function () {
	
	var test = [
		{ "id" : "ajson1", "parent" : "#", "text" : "Simple root node" },
		{ "id" : "ajson2", "parent" : "#", "text" : "Root node 2" },
		{ "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },
		{ "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" },
	];
	
	$('#tree2').jstree({ 
		'core' : {
			'data' : test,
			'check_callback' : true
		},	
		'plugins' : ["wholerow","contextmenu","cookies"],
		'contextmenu' : {
			"items" : {
				"test" : { //사실상 "test"라는 이름은 변수에 가깝기 때문에 뭐든 상관없다 생각한다.
	        		"separator_before" : false,
					"separator_after" : true,
					"label" : "신규메뉴",
					"action" : function(obj){alert('메뉴테스트')}
				},
				"test1" : {
					"separator_before" : false,
					"separator_after" : true,
					"label" : "신규메뉴2",
					"action" : function(obj){alert('메뉴테스트2')}
				}
			}
		}
	});
  $('#tree2').bind("select_node.jstree",function(e,data) {
	  var level = data.node.parents.length;
	    var text  = data.node.text;
	    var id    = data.node.id;
      console.log(text+","+id+","+level);
  });
    
});

function fn_extends(){
	alert("fn_extends");
	$("#tree2").jstree("open_all");
}
function fn_collapse(){
	alert("fn_collapse");
	$("#tree2").jstree("close_all");
}
</script>
</head>
<body>

<jsp:include page="../../footer/footer1.jsp" />    