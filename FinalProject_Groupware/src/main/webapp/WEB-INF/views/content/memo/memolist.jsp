<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../header/header1.jsp" />

<style type="text/css">
th {
	background-color: #ecf2f1
}

.subjectStyle {
	font-weight: bold;
	color: navy;
	cursor: pointer;
}

a {
	text-decoration: none !important;
} /* 페이지바의 a 태그에 밑줄 없애기 */
div.card {
	font-weight: bold;
}

.no-outline:focus {
	outline: none; /* 포커스 시 파란 테두리 제거 */
	box-shadow: none; /* 추가적인 파란색 그림자 제거 */
}

div.header {
/* border:1px solid red; */
	width:93.5%;
	margin:0 auto;
	border-bottom: 1px solid #ccc;
	display: flex;
	justify-content: space-between;
}

div.header .title {
    border-left: 5px solid #006769;  /* 바 두께 증가 */
    padding-left: 1.5%;  /* 왼쪽 여백 조정 */
    font-size: 28px;  /* h2 크기와 유사하게 증가 */
    margin-top: 2%;
    margin-bottom: 2%;
    color: #4c4d4f;
    font-weight: bold;
}

button#writeBtn {
	position: relative;
	top:38px;
	left:-20px;
}

.memo-container {
    display: flex;
    flex-wrap: wrap;
    gap: 15px; /* 카드 간격 */
    justify-content: center; /* 가운데 정렬 */
}

.memo-card {
    width: 18%; /* 5개씩 배치 */
    min-width: 200px; /* 최소 너비 */
    background: white;
    padding: 15px;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);

    
    /* 카드 높이 고정 */
    min-height: 220px; /* 최소 높이 */
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.memo-card .card-header span {
    display: inline-block;
    max-width: 85%; /* 버튼을 제외한 최대 너비 */
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    vertical-align: middle;
}

.memo-card .card-text {
    display: -webkit-box;
    -webkit-line-clamp: 2; /* 줄 개수 제한 (2줄까지 표시) */
    -webkit-box-orient: vertical;
    overflow: hidden;
}


.memo-card .card-body {
    flex-grow: 1; /* 내용이 부족해도 카드 크기 일정 유지 */
}

.row-break {
    flex-basis: 100%; /* 줄바꿈 역할 */
    height: 0;
}


button.btn {
	background-color: #006769;
	color:white;
	
	.no-outline:focus {
    outline: none; /* 포커스 시 파란 테두리 제거 */
    box-shadow: none; /* 추가적인 파란색 그림자 제거 */
    }
	


</style>


<script type="text/javascript">

$(document).ready(function(){  
    // 모달이 열릴 때 aria-hidden="false" 설정
    $("#memoDetailModal").on('show.bs.modal', function () {
    	$(this).removeAttr('inert'); // 모달이 열릴 때 포커스 가능하도록 변경
    });

    // 모달이 닫힐 때 aria-hidden="true" 추가 + 초기화
    $("#memoDetailModal").on('hidden.bs.modal', function () {
    	$(this).attr('inert', ''); // 모달이 닫힐 때 다시 비활성화s
        
        // 초기화 (readonly 및 버튼 상태 원래대로)
        $("#memoDetailTitle, #memoDetailContent").prop("readonly", true);
        $("#memoSave").text("수정").attr("id", "memoEdit");
    });

    // 메모 클릭 시 상세 모달 열기
    $(".memo-card").on("click", function () {
        const memo_no = $(this).data("id");
        const memo_title = $(this).find(".card-header span").text();
        const memo_contents = $(this).find(".card-text").eq(0).text();
        const date = $(this).find(".card-text").eq(1).text();

 //       console.log("클릭한 메모 정보:", { memo_no, memo_title, memo_contents });
        
        // 모달창에 값 설정
        $("#memoDetailTitle").val(memo_title).prop("readonly", true);
        $("#memoDetailContent").val(memo_contents).prop("readonly", true);
        $("#memoDetailDate").text(date);
        $("#memoDetailNo").val(memo_no); // hidden input에 메모 ID 저장

        // 삭제, 수정 버튼에 메모 번호 저장
        $("#memoDelete").data("id", memo_no);
        $("#memoEdit").data("id", memo_no);

        // 모달 열기
        $("#memoDetailModal").modal("show");
    });

    // 수정 버튼 클릭 시 readonly 해제
    $(document).on("click", "#memoEdit", function () {
        $("#memoDetailTitle").prop("readonly", false);
        $("#memoDetailContent").prop("readonly", false);

        // "수정" 버튼을 "저장" 버튼으로 변경
        $(this).text("저장").attr("id", "memoSave");
    });
    
    

 	// 저장 버튼 클릭 (제목 또는 내용이 반드시 있어야 함)
    $(document).on("click", "#memoSave", function () {
        const memo_no = $("#memoDetailNo").val();
        const memo_title = $("#memoDetailTitle").val().trim();
        const memo_contents = $("#memoDetailContent").val().trim();
        
//        console.log("입력된 제목:", memo_title);
//        console.log("입력된 내용:", memo_contents);

        // 유효성 검사: 제목과 내용이 둘 다 비어 있으면 저장 불가
        if (!memo_title && !memo_contents) {  
            alert("제목 또는 내용을 입력하세요.");
            $("#memoDetailTitle").focus();
            return;
        }

        $.ajax({
            url: "<%= ctxPath%>/memo/memoupdate",
            type: "PUT",
            contentType: "application/json",
            dataType: "json",
            data: JSON.stringify({ 
                memo_no: memo_no, 
                memo_title: memo_title, 
                memo_contents: memo_contents 
            }),
            success: function(updatedMemo) {  // 수정된 데이터 받아오기
                if(updatedMemo) { 
                    alert("메모가 수정되었습니다.");
                    location.reload();	// 새로고침

                    const memoCard = $(".memo-card[data-id='" + updatedMemo.memo_no + "']");
                    memoCard.find(".card-header span").text(updatedMemo.memo_title);
                    memoCard.find(".card-text").eq(0).text(updatedMemo.memo_contents);
                    
                    // 서버에서 받은 최신 날짜 적용
                    memoCard.find(".card-text").eq(1).text(updatedMemo.memo_registerday);

                    // 수정된 메모를 맨 위로 이동
                    memoCard.parent().prepend(memoCard);

                    $("#memoDetailModal").modal("hide");
                } else {
                    alert("수정 실패");
                }
            },
            error: function(xhr) {
                alert("서버 오류: " + xhr.status + " - " + xhr.statusText);
            }
        });

    });	
 	

    
 // 삭제버튼 클릭
    $("#memoDelete").on("click", function () {
        if(confirm("정말 삭제하시겠습니까?")) {
            const memo_no = $("#memoDetailNo").val(); // hidden input에서 ID 가져오기

            $.ajax({
                url: "<%= ctxPath%>/memo/trash", // 기존 `memodelete` 대신 `trash`로 변경
                type: "DELETE",
                contentType: "application/json",
                data: JSON.stringify({ memo_no: memo_no }),
                success: function(response) {
                    if (response.status === "success") {
                        alert(response.message); // ✅ "메모가 휴지통으로 이동되었습니다." 출력

                        // 삭제된 메모를 `memolist`에서 제거
                        $(".memo-card[data-id='" + memo_no + "']").remove();

                        // 모달 닫기
                        $("#memoDetailModal").modal("hide");
                    } else {
                        alert("삭제 실패: " + response.message);
                    }
                },
                error: function() {
                    alert("삭제 요청 실패");
                }
            });
        }
    });


    // 모달이 열릴 때 fk_member_userid 값 넘겨주기 (input 태그 hidden 처리)
    $("div#memoModal").on('show.bs.modal', function(e){
        const button = $(e.relatedTarget);
        const fk_member_userid = button.data("id");

        const modal = $(this);
        modal.find("input[name='fk_member_userid']").val(fk_member_userid);
    });

    // 모달창에서 메모 저장 버튼 클릭 시 폼 전송
    $("#memoWrite").on("click", function () {
        if(confirm("메모를 저장하시겠습니까?")) {
            // 폼(form)을 전송(submit)
            const frm = document.memoFrm;
            const memo_title = $("#memo_title").val().trim();
            const memo_contents = $("#memo_contents").val().trim();
            
            
         	//유효성 검사: 제목과 내용이 둘 다 비어 있으면 저장 불가
            if (!memo_title && !memo_contents) {
                alert("제목 또는 내용을 입력하세요.");
                $("#memo_title").focus();
                return;
            }

            // 제목이 비어 있으면 기본 제목 설정
            if(frm.memo_title.value.trim() === "") {
                frm.memo_title.value = "제목 없음";  
            }
            
         	// 내용이 비어 있으면 기본값 설정
            if (frm.memo_contents.value.trim() === "") {
                frm.memo_contents.value = "내용 없음";  
            }

            frm.method = "post";
            frm.action = "<%= ctxPath%>/memo/memowrite";
            frm.submit();
        }
        else {
            alert("메모 작성이 취소되었습니다.");
        }
    });

}); 





//중요 메모(즐겨찾기) 추가/삭제 함수

function importantMemo(memo_no, button) {
	event.stopPropagation(); // 
	
    let icon = $(button).find("i"); // 클릭한 버튼 내 아이콘 찾기
    let isBookmarked = icon.hasClass("fa-star"); // 현재 즐겨찾기 여부 확인

    $.ajax({
        url: "<%= ctxPath%>/memo/memoMark",
        type: "POST",
        data: { "memo_no": memo_no },
        success: function (response) {
            if (response.success) {
                if (!isBookmarked) {
                    icon.removeClass("fa-star-o").addClass("fa-star").css("color", "#f68b1f"); // 즐겨찾기 추가
                } else {
                    icon.removeClass("fa-star").addClass("fa-star-o").css("color", "gray"); // 즐겨찾기 삭제
                }

                // 동일한 메모의 즐겨찾기 상태 변경 (다른 페이지에도 적용)
                $(".btnstar[data-memo-no='" + memo_no + "'] i")
                    .removeClass(isBookmarked ? "fa-star" : "fa-star-o")
                    .addClass(isBookmarked ? "fa-star-o" : "fa-star")
                    .css("color", isBookmarked ? "gray" : "#f68b1f");
            }
        },
        error: function () {
            console.error("즐겨찾기 상태 업데이트 실패");
        }
    });
}





</script>


	<div class="header">
		<div class="title">메모장</div>
		<!-- 메모 쓰기 버튼 -->
		<div class="memowrite" style="margin-bottom: 20px;">
			<button type="button" id="writeBtn" class="btn ml-2" data-toggle="modal" data-target="#memoModal">메모 쓰기</button>
		</div>
	</div>

<div id="sub_mycontent">

	<form name="memoFrm" >
		<input type="hidden" id="memoDetailNo" name="fk_member_userid" value="${sessionScope.member_userid}" />

	<!-- 모달 -->
	<div class="modal fade" id="memoModal" tabindex="-1" role="dialog" aria-labelledby="memoModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
	        <div class="modal-content">
	            <!-- 모달 헤더 -->
	            <div class="modal-header text-white" style="background-color: #509d9c;">
	                <h5 class="modal-title" id="memoModalLabel">메모 작성</h5>
	                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
	            </div>
	            <!-- 모달 바디 -->
	            <div class="modal-body">
	                <form id="memoForm">
	                    <div class="form-group">
	                        <label for="memo_title" class="font-weight-bold" >제목</label>
	                        <input type="text" class="form-control" id="memo_title" name="memo_title" placeholder="제목을 입력하세요">
	                    </div>
	                    <div class="form-group">
	                        <label for="memo_contents" class="font-weight-bold">내용</label>
	                        <textarea class="form-control" id="memo_contents" name="memo_contents" rows="4" placeholder="내용을 입력하세요"></textarea>
	                    </div>
	                    
	                </form>
	            </div>
	            <!-- 모달 푸터 -->
	            <div class="modal-footer">
	                <button type="button" class="btn ml-2" style="background-color: #006769" data-dismiss="modal">닫기</button>
	                <button type="submit" class="btn ml-2" style="background-color: #509d9c;" id="memoWrite">저장</button>
	            </div>
	        </div>
	    </div>
	</div>

	</form>
	
	</div>

<div class="allMemo">	
	<!-- 메모 목록 보기 -->
	<div id="memoList" class="memo-container">
	    <c:forEach var="memo" items="${memo_list}" varStatus="status">
	        <div class="card border-info mb-3 memo-card" data-id="${memo.memo_no}">
	            <div class="card-header" style="background-color: #ecf2f1">
	                <span>${memo.memo_title}</span>
	                
	                <!-- 중요 메모(즐겨찾기) 버튼 -->
                <button type="button" class="btnstar btn-link p-0 no-outline" 
                    data-memo-no="${memo.memo_no}"
                    onclick="importantMemo('${memo.memo_no}', this)"
                    style="font-size: 1.5rem; color: gray; background-color: transparent; border: none; outline: none;">
                    <i class="fa ${memo.memo_importance == '1' ? 'fa-star' : 'fa-star-o'}" aria-hidden="true"></i>
                </button>
	            </div>
	            
	            <div class="card-body text-dark">
	                <p class="card-text">${memo.memo_contents}</p>
	                <p class="card-text text-right">${memo.memo_registerday}</p>
	            </div>
	        </div>
	
	        <!-- 5번째 요소마다 줄바꿈을 위한 새로운 행 추가 -->
	        <c:if test="${(status.index + 1) % 5 == 0}">
	            <div class="row-break"></div>
	        </c:if>
	    </c:forEach>
	</div>
</div>

<!-- 메모 상세보기 모달 -->
<div class="modal fade" id="memoDetailModal" tabindex="-1" role="dialog" aria-labelledby="memoDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <!-- 모달 헤더 -->
            <div class="modal-header text-white" style="background-color: #509d9c;">
                <input type="text" class="form-control border-0 bg-transparent text-white font-weight-bold" 
                       id="memoDetailTitle" name="memo_title" readonly>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <!-- 모달 바디 -->
            <div class="modal-body">
                <div class="form-group">
                    <label class="font-weight-bold">내용</label>
                    <textarea class="form-control border-0 bg-light" id="memoDetailContent" name="memo_contents" rows="5" readonly></textarea>
                </div>
                <p class="text-muted text-right small font-italic" id="memoDetailDate"></p>
            </div>
            <!-- 모달 푸터 -->
            <div class="modal-footer">
                <button type="button" class="btn ml-2" style="background-color: #006769" id="memoDelete">삭제</button>
                <button type="button" class="btn ml-2" style="background-color: #509d9c;" id="memoEdit">수정</button>
            </div>
        </div>
    </div>
</div>




<jsp:include page="../../footer/footer1.jsp" />