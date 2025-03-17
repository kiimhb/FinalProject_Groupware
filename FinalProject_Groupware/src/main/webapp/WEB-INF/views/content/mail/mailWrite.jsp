<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../header/header1.jsp" /> 
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />

<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<%-- jsTree --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree-bootstrap-theme@1.0.1/dist/themes/proton/style.min.css" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<!-- SweetAlert2 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.0/dist/sweetalert2.min.css">

<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.0/dist/sweetalert2.min.js"></script>





<script type="text/javascript">
/*
const organModalOpen = document.getElementById('organModalOpen');
//const organModalClose = document.getElementById('organModalClose');
const orgnaModal = document.getElementById('modalContainer');

organModalOpen.addEventListener('click', () => {
	orgnaModal.classList.remove('hidden');
});

organModalClose.addEventListener('click', () => {
	organModal.classList.add('hidden');
});
*/


document.addEventListener("DOMContentLoaded", () => {
	
const organModalOpen = document.getElementById('organModalOpen');
const organModalClose = document.getElementById('organModalClose');
const organModal = document.getElementById('modalContainer');


organModalOpen.addEventListener('click', () => {
    organModal.classList.remove('hidden');
});
organModalClose.addEventListener('click', () => {
	organModal.classList.add('hidden');
});     
        
        

});


$(document).ready(function(){  
	
	
	<%-- 조직도에서 넘어온 경우 받는 사람 member_userid 자동기입 --%>
	const from_orgUserId = "${requestScope.member_userid}";

	if(from_orgUserId != "" && from_orgUserId != undefined) {
		$("input[name='mail_received_userid']").val(from_orgUserId);
	}
	
	/////////////////////////////////////////////////////////////////

	   	// ==== 스마트 에디터 구현 시작 ====
		//전역변수
	    var obj = [];
	    
	    //스마트에디터 프레임생성
	    nhn.husky.EZCreator.createInIFrame({
	        oAppRef: obj,
	        elPlaceHolder: "mail_sent_content",
	        sSkinURI: "<%= ctxPath%>/smarteditor/SmartEditor2Skin.html",
	        htParams : {
	            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseToolbar : true,            
	            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseVerticalResizer : true,    
	            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseModeChanger : true,
	        }
	    });

	  
	   
	  
	  $("button#btnWrite").click(function(){
		  
		  obj.getById["mail_sent_content"].exec("UPDATE_CONTENTS_FIELD", []);
		  // const fk_member_userid = $("input:hidden[name='fk_member_userid']").val()
		  
		  <%-- 메일 폼 전송하기--%>
		  const frm = document.addFrm;
	      frm.method = "post";
	      frm.action = "<%= ctxPath%>/mail/mailWrite";
	      frm.submit();

	      alert("메일 전송이 완료되었습니다 !")
	      
	      
		  
		  
	  });
	  
	  
	  
	  
	  
	  
	  <%-- =========================== 조직도 =============================--%>
	  
	  <%-- 채팅/메일 버튼 숨기기 --%> 
		$("div#memberBtns").hide();
		
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
		                // 노드 추가
		                childDeptNode.children.push({
		                    "text": row.member_name,
		                    "icon": 'fa-solid fa-user',  // 직원 이미지 아이콘 설정
		                    "data": { "member_userid": row.member_userid }
		                });
		            }

		        });
		
		        // 트리구조 배열 확인
		        // console.log(treeData);
		        
		        // 배열을 이용해 트리 구조 생성하기
		        jsTreeView(treeData);
				
				$('#tree').css('font-family', "'NEXON Lv1 Gothic OTF', sans-serif");
		    },
		    error: function() {
				swal('조직도 불러오기 실패!',"다시 시도해주세요",'error');
			}
		});
		
		
		<%-- 특정 사원 클릭 시 우측에 해당 사원의 정보 보여주기 --%>
		$("div#tree").on("select_node.jstree", function(e, data) {
			
			var memberData = data.node.data;	// 클릭한 사원의 "data" 객체
			
			if(memberData && memberData.member_userid) {
				// memberData가 null 이 아니고 해당 객체에 member_userid 가 있을 경우
				
				var member_userid = memberData.member_userid;
				//alert(member_userid);
				
				// 사원 정보 가져오기
				$.ajax({
					url: "<%= ctxPath%>/organization/selectOneMemberInfo",	
					type: "post",
					data: {member_userid: member_userid},
					success: function(json) {
						//console.log(json);
						//console.log(JSON.stringify(json));
						
						let html = `<div id="memberInfo">
										<h3><span style="color: #006769; font-weight: bold;">\${json.member_name}&nbsp;</span>님 정보<span id="info_member_userid" style="display: none;">\${member_userid}</span></h3>
										<table  id="memberInfotable" style="table-layout: fixed; width: 100%;">
											<tbody>
												<tr>
													<td rowspan="4" style="width:40%; text-align:center;"><img width="137" height="176" src="<%= ctxPath%>/resources/profile/\${json.member_pro_filename}" / ></td>
													<td style="width:50%;"><span style="font-weight: bold;">성명</span><span class="tableSpan">\${json.member_name}</span></td>
												</tr>
												<tr>
													<td style="width:50%;"><span style="font-weight: bold;">부문</span><span class="tableSpan">\${json.parent_dept_name}</span></td>
												</tr>
												<tr>
													<td style="width:50%;"><span style="font-weight: bold;">부서</span><span class="tableSpan">\${json.child_dept_name}</span></td>
												</tr>
												<tr>
													<td style="width:50%;"><span style="font-weight: bold;">직급</span><span class="tableSpan">\${json.member_position}</span></td>
												</tr>
												<tr>
													<td colspan="2"><span style="font-weight: bold;">핸드폰</span><span class="tableSpan">\${json.member_mobile}</span></td>
												</tr>
												<tr>
													<td colspan="2"><span style="font-weight: bold;">이메일</span><span class="tableSpan">\${json.member_email}</span></td>
												</tr>
												<tr>
													<td colspan="2"><span style="font-weight: bold;">입사일자</span><span class="tableSpanHriedate">\${json.member_start}</span></td>
												</tr>
											</tbody>
							            </table>
						            </div>`;
						            
						// html 태그를 보여주기
						$("div#memberInfo").html(html);
						
						$("div#memberInfoBorder").css({"border":"solid 1px gray"});
										
						
						// 채팅 및 메일 버튼 보이기
						$("div#memberBtns").show();
						
					},
					error: function() {
						swal('사원정보 불러오기 실패!',"다시 시도해주세요",'error');
					}
				});
				
			}
			
		});// end of $("div#tree").on("select_node.jstree", function(e, data) {})------------------
		
		
		
		<%-- 사원명 검색시 해당 노드만 펼쳐지는 이벤트 --%>
		$("input:text[name='member_name']").on("keyup", function(e){
			
			const member_name = $(e.target).val();
			$('#tree').jstree(true).search(member_name);
			
		});
		
		//////////////////////////////////////////////////////////////////////////
		
		<%-- 사원 정보에서 메일보내기 버튼 클릭 --%>
		$(document).on("click", "button[id='mailBtn']", function(e){
			
			const member_userid = $("span#info_member_userid").text();
			
			console.log("사원번호", member_userid)
			
			$("input[name='mail_received_userid']").val(member_userid);
			
			
			$('#modalContainer').addClass('hidden');
					 
		});

	  
	  
	  
	  
	  
	  
});// end of $(document).ready(function(){})-----------



<%-- 함수 --%>
<%-- 배열을 이용해 트리 구조 생성하기 --%>
function jsTreeView(jsonData) {
	$('#tree').jstree({
	    'plugins': ["wholerow", "search", "html"], // 플러그인 배열 합침
	    'core': {
	        'data': jsonData,
	        'state': {
	            'opened': true
	        },
	        'themes': {
	            'name': 'proton',
	            'responsive': true
	        }
	    },
	    "search": {
	        "case_sensitive": false,  // 대소문자 구분하지 않음
	        "show_only_matches": true,  // 일치하는 노드만 검색
	        "search_leaves_only": true  // 리프노드만 검색
	    }
	});
}



function modalClose(){
	
	
}



</script>


<style>
	div.orgContainer {
		border-radius: 5px !important;
		width: 95%;
		height: 860px;
		margin: auto;
		margin-top: 3%;
	}
	
	h2 {
		margin-left: 3%;
      	margin-top: 4%;
      	margin-bottom: 3%;
      	letter-spacing: 4px !important;
		border-left: 5px solid #006769;   
		padding-left: 1%;
		margin-bottom: 1%;
		color: #4c4d4f;
		font-weight: bold;
	}
	
	<%-- show/hide/검색 --%>
	div#orgTop {
		margin: 5% 5% 2% 5%;		
	}
	
	<%-- 검색창 --%>
	input#member_name {
	  width: 500px;
	  height: 40px;
	  font-size: 15px;
	  border: 0;
	  border-radius: 15px;
	  outline: none;
	  padding-left: 10px;
	  background-color: rgb(233, 233, 233);
	}

	<%-- 조직도 --%>
	#tree {
	    margin-top: 5%;
	    margin-left: 5%;
		font-size: 14pt;
	}
	
	.jstree li {
	  line-height: 1.5 !important; /* 원하는 line-height 값 */
	}
	
	<%-- employee-icon 클래스로 아이콘을 설정 --%>

	
	<%-- 사원정보 테이블 --%>
	div#memberInfo {
		width: 90%;
		margin: 10% auto 3% auto;
	}
	
	table {
	    width: 100%;
	    border-collapse: separate; /* 셀 간 경계를 분리하여 테두리와 border-radius가 적용되도록 */
	    border: none; /* 테이블 외부 테두리 제거 */
	}
	
	th, td {
	    border: 1px solid black; /* th와 td에만 테두리 적용 */
	    border-radius: 3px; /* 각 셀에 둥근 테두리 적용 */
	    padding: 10px; /* 셀 안의 여백 */
	}
	
	span.tableSpan {
		display: inline-block;
		margin-left: 30%;
	}
	
	span.tableSpanHriedate {
		display: inline-block;
		margin-left: 26%;
	}
	

	<%-- 채팅/메일 버튼 --%>
	div#memberBtns {
		display: flex;
		margin-right: 10%;
		margin-bottom: 5%;
		justify-content: right; /* 가로 중앙 정렬 */
	}
	<%-- 	
	button#chatBtn {
		margin-left: auto;
		margin-right: 3%;
		width: 13%;
	}
	
	button#mailBtn {
		width: 13%;
		height: 40px;
	} --%>



#modalContainer {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContent {
  position: absolute;
  background-color: #ffffff;
  width: 1200px;
  height: 800px;
  padding: 20px;
  border-radius: 20px;
}

#modalContainer.hidden {
  display: none;
}
#modalContainer {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContainer.hidden {
  display: none;
}




/* 상단 타이틀 */
.header > div.title {
   border-left: 5px solid #006769;   
   padding-left: 1%;
   font-size: 20px;
   margin-bottom: 1%;
   color: #4c4d4f;
   font-weight: bold;
}



.btnOrg{

background-color:#006769;
border-radius: 10px;
border: none;
width: 80px;
height:30px;
color:black;

}



.btn {

background-color:#b3d6d2;
border-radius: 10px;
border: none;
width: 80px;
height:35px;
color:black;

}

</style>







<div id="sub_mycontent">
<div class="header" style="font-size:15pt;margin: 1% 5%;">
	<div class="title">메일 쓰기</div>	
</div>

<div id="container" style="margin:0.1% 5%;">

<form name="addFrm" enctype="multipart/form-data">

   		<table style="width: 1332px" class="table table-bordered">
   		   		
			 <tr>
				<th style="width: 15%; background-color: #b3d6d2;">받는사람 <%-- 수신자 --%>
					<span style="float:right;"><input type="checkbox" name="mail_sent_important" value="1"/>&nbsp;중요</span>
				</th>
			    <td>
			       <input type="text" name="mail_received_userid">
			       <input type="hidden" name="sk_member_userid" value="${sessionScope.loginuser.member_userid }"/>
			       <button class="btnOrg" type="button" id="organModalOpen" style="background-color: #b3d6d2;">주소록</button>
			       <div style="float:right;">
			            <button type="button" class="btn  mr-3" id="btnWrite">보내기</button>
			            <button type="button" class="btn " onclick="javascript:history.back()">취소</button>  
			     </div>			       
			    </td>
   		     </tr>
   		     
   		     <tr>
   		        <th style="width: 15%; background-color: #b3d6d2;">제목</th>
   		        <td>
   		        	<input type="text" name="mail_title" size="100" maxlength="200" />
   		        </td>
   		     </tr>
   		      <%-- === #145. 파일첨부 타입 추가하기 === --%>
			 <tr>
			    <th style="width: 15%; background-color: #b3d6d2;">파일첨부</th>
			    <td>
			        <input type="file" name="attach" />
			    </td>
			 </tr>
   		     <tr>
				<th style="width: 15%; background-color: #b3d6d2;">내용</th> 
				<td>
				    <textarea style="width: 100%; height: 440px;" name="mail_sent_content" id="mail_sent_content"></textarea>
				</td>
			 </tr>
			 
			

   		</table>
   		
		

	</form>
	

</div>








<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@조직도@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -->


<div id="modalContainer" class="hidden" >
	<div id="modalContent">

		<div class="orgContainer">
			<h2>아삭병원 조직도</h2>
			
			<div style="display: flex; flex-wrap: wrap; margin: 2%;">
			
				<div style="border:solid 1px gray; border-radius: 3px; flex: 4.5; height: 650px; overflow: auto;">
					<div id="orgTop">
						<button type="button" id="btnShow" class="btn" style="background-color: #006769; color:white; margin-right: 1.5%;">Show</button>
						<button type="button" id="btnHide" class="btn" style="background-color: #857c7a; color:white; margin-right: 1.5%;">Hide</button>
						<button type="button" id="organModalClose" class="btn" style="background-color:#f68b1f; color:white;">Close</button>
						<span style="float: right;">
							<input name="member_name" id="member_name" type="text" style="width: 160px;" placeholder="사원명 입력" />
						</span>
					</div>
					<div id="tree"></div>
				</div>
				
				<div id="orgRight" style="border:solid 0px green; flex: 5.5; height: 600px;">
					<div id="memberInfoBorder" style="border: solid 0px gray; margin: 8%; border-radius: 3px;">
						<div id="memberInfo" ></div>
						<div id="memberBtns" style="float:center">
							<button type="button" id="mailBtn" class="btn" style="background-color: #4c4d4f; color:white;"><i class="fa-regular fa-envelope fa-xl"></i></button>
						</div>
					</div>
				</div>
			
			</div>
			
			<form name="goWriteMailFrm">
				<input type="hidden" name="member_userid" />
			</form>
			
		</div>
	</div>
</div>



</div>










<jsp:include page="../../footer/footer1.jsp" />