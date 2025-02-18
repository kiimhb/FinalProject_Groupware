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

<jsp:include page="../../../header/header1.jsp" /> 

<style type="text/css">
    
  th {background-color: #ddd}
  
  .subjectStyle {font-weight: bold;
                 color: navy;
                 cursor: pointer; }
                 
  a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
  
  div.button {text-align: right;}
    
</style>


<script type="text/javascript">
//즐겨찾기 토글 함수
function importantmemo(button) {
	  const icon = button.querySelector("i");
	  if (icon.classList.contains("fa-star-o")) {
	    // 비어 있는 별 -> 채워진 별
	    icon.classList.remove("fa-star-o");
	    icon.classList.add("fa-star");
	    icon.style.color = "gold";
	  } else {
	    // 채워진 별 -> 비어 있는 별
	    icon.classList.remove("fa-star");
	    icon.classList.add("fa-star-o");
	    icon.style.color = "gray";
	  }
}
</script>




<div style="display: flex;">
  <div style="margin: auto; padding-left: 3%;">

   <h2 style="margin-bottom: 30px; padding-top: 2%; font-weight: bold;">자유게시판</h2>

		<table style="width: 1200px" class="table">
			<thead>
				<tr>
					<th style="width: 70px; text-align: center;">글번호</th>
					<th style="width: 300px; text-align: center;">제목</th>
					<th style="width: 70px; text-align: center;">작성자</th>
					<th style="width: 150px; text-align: center;">작성일자</th>
					<th style="width: 60px; text-align: center;">조회수</th>
					<th style="width: 60px; text-align: center;">즐겨찾기</th>
				</tr>
			</thead>
			
			<tbody>
				<c:if test="${not empty requestScope.boardList}">
					<c:forEach var="boardvo" items="${requestScope.boardList}"
						varStatus="status">
						<td>${pvo.patient_no}</td>
						<td>${pvo.patient_visitdate}</td>
						<td>${pvo.child_dept_name}</td>
						<td>${pvo.patient_name}</td>
						<td>${pvo.patient_gender}</td>
						<td>${pvo.patient_jubun}</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty requestScope.boardList}">
					<tr>
						<td colspan="6" style="text-align: center">데이터가 없습니다.</td>
					</tr>
				</c:if>
				<!-- <tr>
					<td>1</td>
					<td>안녕하세요</td>
					<td>엄정화</td>
					<td>2025.02.10</td>
					<td>10</td>
					<td>즐겨찾기 버튼
						<button type="button" class="btn btn-link p-0 no-outline" onclick="importantmemo(this)" style="font-size: 1.5rem; color: gray; margin-right: 8px;">
							<i class="fa fa-star-o" aria-hidden="true"></i>
							비어있는 별
						</button></td>
				</tr>
				<tr>
					<td>2</td>
					<td>파이팅</td>
					<td>이순신</td>
					<td>2025.02.11</td>
					<td>5</td>
					<td>즐겨찾기 버튼
						<button type="button" class="btn btn-link p-0 no-outline" onclick="importantmemo(this)" style="font-size: 1.5rem; color: gray; margin-right: 8px;">
							<i class="fa fa-star-o" aria-hidden="true"></i>
							비어있는 별
						</button></td>
				</tr> -->
			</tbody>
			<div class="button">
				<button type="button" class="btn btn-outline-primary" onclick="javascript:location.href='<%= ctxPath %>/board/add'" style="margin-bottom: 10px;">글쓰기</button>
			</div>
			
		</table>
		
		<%-- 페이지바 === --%>
	    <div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	    	${requestScope.pageBar}
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
 
 

   
   
   <jsp:include page="../../../footer/footer1.jsp" />