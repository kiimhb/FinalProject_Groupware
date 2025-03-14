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
	background-color: #ddd
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

.header .title {
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
    gap: 15px;
    justify-content: center;
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

button.btn {
	background-color: #006769;
	color:white;
	
	.no-outline:focus {
    outline: none; /* 포커스 시 파란 테두리 제거 */
    box-shadow: none; /* 추가적인 파란색 그림자 제거 */
    }
	
</style>

<script type="text/javascript">
//메모 클릭 시 상세 정보 모달 띄우기
function openMemoDetail(memo_no, title, content, date) {
    console.log("선택된 메모 번호:", memo_no);

    // 모달에 데이터 채우기
    $("#memoDetailTitle").val(title);
    $("#memoDetailContent").val(content);
    $("#memoDetailDate").text(date);

    // memo_no를 hidden input에 저장
    $("#hiddenMemoId").val(memo_no);

    // 모달 표시
    $("#memoDetailModal").modal("show");
}

// 복원 버튼 클릭 시 AJAX 요청
$(document).on("click", "#restoreMemo", function () {
    const memo_no = $("#hiddenMemoId").val(); // hidden input에서 memo_no 가져오기

    console.log("복원할 메모 번호:", memo_no);

    if (!memo_no) {
        alert("메모 번호를 찾을 수 없습니다.");
        return;
    }

    if (confirm("이 메모를 복원하시겠습니까?")) {
        $.ajax({
            url: "<%= request.getContextPath() %>/memo/restoreMemo",
            type: "PUT",
            contentType: "application/json",
            data: JSON.stringify({ memo_no: memo_no }),
            success: function (response) {
                if (response.status === "success") {
                    alert("메모가 복원되었습니다.");
                    location.reload();	// 새로고침

                    // 복원된 메모를 휴지통 목록에서 제거
                    $(".memo-card[data-id='" + memo_no + "']").remove();

                    // 모달 닫기
                    $("#memoDetailModal").modal("hide");
                } else {
                    alert("복원 실패: " + response.message);
                }
            },
            error: function () {
                alert("복원 요청 실패");
            }
        });
    }
});
 
//  완전 삭제 버튼 클릭 시 AJAX 요청
$(document).on("click", "#memoDelete", function () {
    const memo_no = $("#hiddenMemoId").val(); // hidden input에서 memo_no 가져오기

    console.log("삭제할 메모 번호:", memo_no);

    if (!memo_no) {
        alert("메모 번호를 찾을 수 없습니다.");
        return;
    }

    if (confirm("이 메모를 완전히 삭제하시겠습니까? 삭제 후 복구할 수 없습니다.")) {
        $.ajax({
            url: "<%= request.getContextPath() %>/memo/deleteTrash",
            type: "DELETE",
            contentType: "application/json",
            data: JSON.stringify({ memo_no: memo_no }),
            success: function (response) {
                if (response.status === "success") {
                    alert("메모가 완전히 삭제되었습니다.");
                    location.reload();	// 새로고침
                    
                 	// 💡 삭제된 메모를 화면에서 즉시 제거
                    $(".memo-card[data-id='" + memo_no + "']").remove();

                    // 💡 목록 다시 불러오기 (삭제된 데이터 반영)
                    loadMemoList();

                    // 모달 닫기
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

</script>


<div class="header">
	<div class="title">
		<div>휴지통</div>
		<p style="display: block; margin-top: 5px; font-size: 14px; color: gray;">
			삭제된 메모는 30일간 보관되며 이후 영구적으로 삭제됩니다.</p>
	</div>
</div>


<div id="sub_mycontent">

	<!-- 메모 목록 (휴지통) -->
	<div id="trashList" class="memo-container">
		<c:forEach var="memo" items="${trash_list}" varStatus="status">
			<div class="card border-secondary mb-3 memo-card"
				onclick="openMemoDetail('${memo.memo_no}', '${memo.memo_title}', '${memo.memo_contents}', '${memo.memo_registerday}')">
				<div class="card-header">
					<span>${memo.memo_title}</span>
				</div>
				<div class="card-body text-dark">
					<p class="card-text">${memo.memo_contents}</p>
					<p class="card-text text-right">${memo.memo_registerday}</p>
				</div>
			</div>

			<!-- 5번째 요소마다 줄바꿈 -->
			<c:if test="${(status.index + 1) % 5 == 0}">
				<div class="row-break"></div>
			</c:if>
		</c:forEach>

		<c:if test="${empty trash_list}">
			<p class="text-center text-muted">휴지통이 비어 있습니다.</p>
		</c:if>
	</div>

</div>



	<!-- 메모 상세보기 모달 -->
	<div class="modal fade" id="memoDetailModal" tabindex="-1"
		role="dialog" aria-labelledby="memoDetailModalLabel"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-lg"
			role="document">
			<div class="modal-content">
				<div class="modal-header text-white"
					style="background-color: #6c757d;">
					<input type="text"
						class="form-control border-0 bg-transparent text-white font-weight-bold"
						id="memoDetailTitle" name="memo_title" readonly>
					<button type="button" class="close text-white" data-dismiss="modal">&times;</button>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label class="font-weight-bold">내용</label>
						<textarea class="form-control border-0 bg-light"
							id="memoDetailContent" name="memo_contents" rows="5" readonly></textarea>
					</div>
					<p class="text-muted text-right small font-italic"
						id="memoDetailDate"></p>
					<input type="hidden" id="hiddenMemoId">
					<!-- 숨겨진 input으로 memo_no 저장 -->
					<!-- 복원 버튼 클릭 시 hidden input에서 memo_no 가져와서 AJAX 요청함 -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn ml-2" id="restoreMemo" style="background-color: #006769">복원</button>
					<button type="button" class="btn ml-2" style="background-color: #509d9c;"
						id="memoDelete">완전 삭제</button>
				</div>
			</div>
		</div>
	</div>


	<jsp:include page="../../footer/footer1.jsp" />