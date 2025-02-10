<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simplebar@latest/dist/simplebar.min.css">
<script src="https://cdn.jsdelivr.net/npm/simplebar@latest/dist/simplebar.min.js"></script>

<%
String ctxPath = request.getContextPath();
//     /myspring
%>

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />
  
  
<script type="text/javascript">
   document.getElementById("toggleBtn").addEventListener("click", function() {
      let sidebar = document.getElementById("sidebar");
      let content = document.getElementById("mycontent");

      sidebar.classList.toggle("hidden");
      content.classList.toggle("full");
   });

   $(document).ready(function() {
      $(".menu-toggle").click(function(e) {
         e.preventDefault(); // 기본 링크 동작 방지
         $(this).next(".submenu").slideToggle(); // 해당 하위 메뉴 열고 닫기
      });
   });
</script>

<div data-simplebar id="sidebar" class="sidebar">
   <div class="profile">
      <div>프로필 사진</div>
      <div>[이름  /직급-부서]</div>
      
      <div>
      <a href="<%=ctxPath%>/mypage/mypage">마이페이지</a> 
      </div>
      
      <div>
      <a href="<%=ctxPath%>/member/logout">로그아웃</a>
      </div>
      
   </div>



   <ul>
      <li><a href="#" class="menu-toggle">진료</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">대기환자</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">진료정보입력</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">처방전 및 수납</a>
         </div></li>

      <li><a href="#" class="menu-toggle">원무</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">환자조회</a>
             <a class="dropdown-item" href="<%=ctxPath%>">예약</a>
             <a class="dropdown-item" href="<%=ctxPath%>">입원실현황</a> 
             <a class="dropdown-item" href="<%=ctxPath%>">수납</a>
         </div></li>

      <li><a href="/attendance" class="menu-toggle">근태관리</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">휴가관리</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">출장관리</a>
             <a class="dropdown-item" href="<%=ctxPath%>/attendance/commute">근태조회</a>
         </div></li>

      <li><a href="#" class="menu-toggle">전자결재</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">기안문작성</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재상신함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">임시저장함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재문서함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">참조문서함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재양식관리</a>
         </div></li>

      <li><a href="#" class="menu-toggle">메일</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">메일쓰기</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">받은메일함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">보낸메일함</a>
             <a class="dropdown-item" href="<%=ctxPath%>">휴지통</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">메일보관함</a>
         </div></li>

      <li><a href="<%=ctxPath%>/notice/notice">공지사항</a></li>
      <li><a href="<%=ctxPath%>/organizational/organizational">조직도</a></li>

      <li><a href="<%=ctxPath%>/schedule/shareschedule" class="menu-toggle">일정관리</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/schedule/shareschedule">공유일정</a>
            <a class="dropdown-item" href="<%=ctxPath%>/schedule/oneschedule">개인일정</a>
         </div></li>

      <li><a href="<%=ctxPath%>/community/board" class="menu-toggle">커뮤니티</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/community/board">자유게시판</a>
            <a class="dropdown-item" href="<%=ctxPath%>/community/myboard">내가 작성한 글 목록</a>
            <a class="dropdown-item" href="<%=ctxPath%>/community/bookmark">즐겨찾기</a>
         </div></li>

      <li><a href="<%=ctxPath%>/memo/memo" class="menu-toggle">메모</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/memo/memo">메모장</a>
            <a class="dropdown-item" href="<%=ctxPath%>/memo/importantmemo">중요메모</a>
            <a class="dropdown-item" href="<%=ctxPath%>/memo/trash">휴지통</a>
         </div></li>

      <li><a href="<%=ctxPath%>/management/ManagementList" class="menu-toggle">인사관리</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/management/ManagementList">사원목록</a>
            <a class="dropdown-item" href="<%=ctxPath%>/management/ManagementFrom">사원등록</a>
         </div></li>
   </ul>
</div>
