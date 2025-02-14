<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<meta name="viewport" content="width=device-width, initial-scale=1">
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

.subjectStyle {font-weight: bold;
               color: navy;
               cursor: pointer; }
               
a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */

div.card {font-weight: bold;}

.no-outline:focus {
    outline: none; /* 포커스 시 파란 테두리 제거 */
    box-shadow: none; /* 추가적인 파란색 그림자 제거 */
  }

    
</style>


<script type="text/javascript">
function saveMemo() {
    const title = document.getElementById('memoTitle').value;
    const content = document.getElementById('memoContent').value;

    if (title.trim() === '' || content.trim() === '') {
      alert('제목과 내용을 입력해주세요.');
      return;
    }

    // 여기에서 제목과 내용을 저장하는 로직을 추가하세요 (예: AJAX 요청).
    // console.log('저장된 메모:', { title, content });

    // 모달 닫기
    $('#memoModal').modal('hide');

    // 입력 필드 초기화
    document.getElementById('memoForm').reset();
  }
  
//즐겨찾기 토글 함수
function importantmemo(button) {
	  const icon = button.querySelector("i");
	  if (icon.classList.contains("fa-star-o")) {
	    // 비어 있는 별 -> 채워진 별로 변경
	    icon.classList.remove("fa-star-o");
	    icon.classList.add("fa-star");
	    icon.style.color = "gold"; // 채워진 별의 색상 변경
	  } else {
	    // 채워진 별 -> 비어 있는 별로 변경
	    icon.classList.remove("fa-star");
	    icon.classList.add("fa-star-o");
	    icon.style.color = "gray"; // 비어있을 때 기본 색상
	  }
}
</script>




<div style="display: flex;">
	<div style="margin: auto; padding-left: 3%;">

		<h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">메모장</h2>

		<table style="width: 1200px" class="table">
			<tbody>
				<div class="card border-info mb-3" style="max-width: 18rem;">
					<div class="card-header d-flex align-items-center">
						<!-- 즐겨찾기 버튼 -->
						<button type="button" class="btn btn-link p-0 no-outline" onclick="importantmemo(this)" style="font-size: 1.5rem; color: gray; margin-right: 8px;">
							<i class="fa fa-star-o" aria-hidden="true"></i>
							<!-- 비어있는 별 , 채워진 별 : fa-star -->
						</button>
						<span>가족여행 일정짜기</span>
					</div>
					<div class="card-body text-dark">
						<p class="card-text">어디로 가지</p>
						<p class="card-text" style="text-align: right;">2025.02.12</p>
					</div>
				</div>
			</tbody>
		</table>

		<!-- 모달 -->
		<div class="modal fade" id="memoModal" tabindex="-1" role="dialog" aria-labelledby="memoModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<!-- 모달 헤더 -->
					<div class="modal-header">
						<h5 class="modal-title" id="memoModalLabel">메모 작성</h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<!-- 모달 바디 -->
					<div class="modal-body">
						<form id="memoForm">
							<div class="form-group">
								<label for="memoTitle">제목</label> <input type="text"
									class="form-control" id="memoTitle" placeholder="제목을 입력하세요">
							</div>
							<div class="form-group">
								<label for="memoContent">내용</label>
								<textarea class="form-control" id="memoContent" rows="4"
									placeholder="내용을 입력하세요"></textarea>
							</div>
						</form>
					</div>
					<!-- 모달 푸터 -->
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">닫기</button>
						<button type="button" class="btn btn-primary" onclick="saveMemo()">저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<%-- === #82. 글검색 폼 추가하기 : 글제목, 글내용, 글제목+글내용, 글쓴이로 검색을 하도록 한다. --%>
    <form name="searchFrm" style="margin-top: 20px; text-align: center;">
      <select name="searchType" style="height: 26px;">
         <option value="subject">글제목</option>
         <option value="content">글내용</option>
         <option value="subject_content">글제목+글내용</option>
         <option value="name">글쓴이</option>
      </select>
      <input type="text" name="searchWord" size="28" autocomplete="off" /> 
      <input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>  
      <button type="button" class="btn btn-outline-primary" onclick="goSearch()" id="btnWrite">검색</button> 
   </form>   

  </div>
 </div>  
 
 

   
   
   <jsp:include page="../../footer/footer1.jsp" />