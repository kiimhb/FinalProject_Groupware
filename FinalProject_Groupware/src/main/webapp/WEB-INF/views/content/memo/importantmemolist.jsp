<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>



<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../../header/header1.jsp" /> 

<style type="text/css">
th {background-color: #ddd}

a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */

.memo-container {
    display: flex;
    flex-wrap: wrap;
    /* 자동으로 줄바꿈이 되는 이유 */
    gap: 15px; /* 카드 간 간격 */
    justify-content: center;
}

.memo-card {
	font-weight: bold;
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
	font-weight: bold;
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

div.header {
/* border:1px solid red; */
	width:93.5%;
	margin:0 auto;
	border-bottom: 1px solid #ccc;
	display: flex;
	justify-content: space-between;
    margin-bottom: 20px;  
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

.memo-container {
    display: flex;
    flex-wrap: wrap;
    gap: 15px; /* 카드 간격 */
    justify-content: center; /* 가운데 정렬 */
}

.memo-card {
    width: 18%;
    min-width: 200px;
    background: white;
    padding: 15px;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
    
    min-height: 220px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.memo-card .card-header span {
    display: inline-block;
    max-width: 85%;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    vertical-align: middle;
}

.memo-card .card-text {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.memo-card .card-body {
    flex-grow: 1;
}

.row-break {
    flex-basis: 100%;
    height: 0;
}

.no-outline:focus {
    outline: none;
    box-shadow: none;
}

.btnstar {
    background: none; /* 배경 없애기 */
    border: none; /* 테두리 없애기 */
    padding: 0; /* 내부 여백 제거 */
    outline: none !important; /* 포커스 시 네모 제거 */
    box-shadow: none !important; /* 클릭 시 테두리 그림자 제거 */
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
	
    // 모달이 열릴 때 초기화 및 aria-hidden="false" 설정
    $("#memoDetailModal").on('show.bs.modal', function () {
        $(this).removeAttr('inert'); // 모달이 열릴 때 포커스 가능하도록 변경
    });

    // 모달이 닫힐 때 초기화 및 aria-hidden="true" 추가
    $("#memoDetailModal").on('hidden.bs.modal', function () {
        $(this).attr('inert', ''); // 모달이 닫힐 때 다시 비활성화
        $("#memoDetailTitle, #memoDetailContent").prop("readonly", true);
        $("#memoSave").text("수정").attr("id", "memoEdit");
    });

    // 메모 클릭 시 상세 모달 열기 (중요메모, 일반메모 통합)
    $(".memo-card").on("click", function () {
    	
        const memo_no = $(this).data("id");
        
        const memo_title = $(this).find(".card-header span").text();
        const memo_contents = $(this).find(".card-text").eq(0).text();
        const date = $(this).find(".card-text").eq(1).text();

        $("#memoDetailTitle").val(memo_title).prop("readonly", true);
        $("#memoDetailContent").val(memo_contents).prop("readonly", true);
        $("#memoDetailDate").text(date);
        $("#memoDetailNo").val(memo_no); // hidden input에 메모 ID 저장

        // 삭제, 수정 버튼에 메모 번호 저장
        $("#memoDelete").data("id", memo_no);
        $("#memoEdit").data("id", memo_no);

        $("#memoDetailModal").modal("show");
    });

    // 수정 버튼 클릭 시 readonly 해제
    $(document).on("click", "#memoEdit", function () {
        $("#memoDetailTitle, #memoDetailContent").prop("readonly", false);
        $(this).text("저장").attr("id", "memoSave");
    });

    // 저장 버튼 클릭 (수정 기능)
    $(document).on("click", "#memoSave", function () {
        const memo_no = $("#memoDetailNo").val();
        const memo_title = $("#memoDetailTitle").val().trim();
        const memo_contents = $("#memoDetailContent").val().trim();

        if (!memo_no) {
            alert("메모 번호가 유효하지 않습니다.");
            return;
        }
        
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
            success: function(updatedMemo) {  
                if(updatedMemo) { 
                    alert("메모가 수정되었습니다.");
                    location.reload();	// 새로고침

                    const memoCard = $(".memo-card[data-id='" + updatedMemo.memo_no + "']");
                    memoCard.find(".card-header span").text(updatedMemo.memo_title);
                    memoCard.find(".card-text").eq(0).text(updatedMemo.memo_contents);
                    memoCard.find(".card-text").eq(1).text(updatedMemo.memo_registerday);

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

    
    
    
    // 중요 메모 삭제 버튼 클릭 (휴지통 이동)
   $("#memoDelete").on("click", function () {
    const memo_no = $(this).data("id");

    if (!memo_no) {
        alert("메모 번호가 유효하지 않습니다.");
        return;
    }

    if (confirm("정말 삭제하시겠습니까?")) {
        $.ajax({
            url: "<%= ctxPath%>/memo/trash", 
            type: "DELETE",
            contentType: "application/json",  
            data: JSON.stringify({ memo_no: memo_no }),  
            success: function (response) {
                console.log(response); 

                if (response.status === "success") {
                    alert(response.message);
                    $(".memo-card[data-id='" + memo_no + "']").remove();
                    $("#memoDetailModal").modal("hide");
                } else {
                    alert("삭제 실패: " + response.message);
                }
            },
            error: function () {
                alert("삭제 요청 실패");
            }
        });
    }
});

 
    // 중요메모(즐겨찾기) 추가/삭제
    $(".btnstar").on("click", function (e) {
    	event.stopPropagation(); // 클릭 이벤트 전파 방지(이벤트가 부모 요소로 전달(전파)되는 것을 막는 기능)
    	/*
    		stopPropagation();이 필요한 이유
    		=> 	 stopPropagation();이 없으면,
    			 .btnstar 버튼을 클릭할 때 부모 .memo-card에도 클릭 이벤트가 전달될 수 있음
    		  	 그러면 메모 카드를 클릭한 것처럼 동작해서 상세 모달이 열릴 가능성이 있음
    		  	 (즉, 단순히 즐겨찾기 버튼을 눌렀는데 메모 상세 보기 모달까지 같이 뜨는 문제가 발생)
    	*/
        
        const memo_no = $(this).data("memo-no");
        let icon = $(this).find("i");
        let isBookmarked = icon.hasClass("fas fa-star");   // 현재 즐겨찾기 상태 확인

        $.ajax({
            url: "<%= ctxPath%>/memo/memoMark",
            type: "POST",
            data: { "memo_no": memo_no },
            success: function(response) {
                if (response.success) {
                	let isNowBookmarked = response.isBookmark; // 최신 즐겨찾기 상태 반영

                    if (isBookmarked) {
                        icon.removeClass("fas fa-star").addClass("far fa-star").css("color", "gray");
                        $(".memo-card[data-id='" + memo_no + "']");
                    } else {
                        icon.removeClass("far fa-star").addClass("fas fa-star").css("color", "#f68b1f");
                    }
                }
            },
            error: function() {
                console.error("즐겨찾기 상태 업데이트 실패");
            }
        });
    });

});

</script>

<div id="sub_mycontent">

<div class="header">
    <div class="title">중요메모장</div>
</div>


<!-- 중요 메모 목록 -->
<div id="importantMemoList" class="memo-container">
    <c:forEach var="memo" items="${importantMemoList}" varStatus="status">
    <div class="card border-info mb-3 memo-card" data-id="${memo.memo_no}">

        <div class="card-header" style="background-color: #ecf2f1">
            <span>${memo.memo_title}</span>
            
            <!-- 중요 메모(즐겨찾기) 버튼 -->
            <button type="button" class="btnstar btn-link p-0 no-outline"
                data-memo-no="${memo.memo_no}"
                style="font-size: 1.5rem; color: #f68b1f;">
                <i class="fa fa-star" aria-hidden="true"></i>
            </button>
        </div>
        
        <div class="card-body text-dark">
            <p class="card-text">${memo.memo_contents}</p>
            <p class="card-text text-right">${memo.memo_registerday}</p>
        </div>
    </div>
</c:forEach>

		<c:if test="${empty importantMemoList}">
			<p class="text-center text-muted">중요메모가 없습니다.</p>
		</c:if>

</div>



<form name="memoFrm" >
	<input type="hidden" id="memoDetailNo" name="fk_member_userid" value="${sessionScope.member_userid}" />

<!-- 메모 상세보기 모달 -->
<div class="modal fade" id="memoDetailModal" tabindex="-1" role="dialog" aria-labelledby="memoDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header text-white" style="background-color: #509d9c;">
                <input type="text" class="form-control border-0 bg-transparent text-white font-weight-bold" 
                       id="memoDetailTitle" name="memo_title" readonly>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="font-weight-bold">내용</label>
                    <textarea class="form-control border-0 bg-light" id="memoDetailContent" name="memo_contents" rows="5" readonly></textarea>
                </div>
                <p class="text-muted text-right small font-italic" id="memoDetailDate"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn ml-2" style="background-color: #006769" id="memoDelete" data-id="${memo.memo_no}">삭제</button>
                <button type="button" class="btn ml-2" style="background-color: #509d9c;" id="memoEdit">수정</button>
            </div>
        </div>
    </div>
</div>

</form>

</div>

<jsp:include page="../../footer/footer1.jsp" />