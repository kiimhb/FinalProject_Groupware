<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<<<<<<< HEAD
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simplebar@latest/dist/simplebar.min.css">
<script src="https://cdn.jsdelivr.net/npm/simplebar@latest/dist/simplebar.min.js"></script>
=======
   
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simplebar/dist/simplebar.min.css">
<script src="https://cdn.jsdelivr.net/npm/simplebar/dist/simplebar.min.js"></script>

>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git

<%
String ctxPath = request.getContextPath();
//     /myspring
%>

<%-- 직접 만든 CSS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />
<%-- 아이콘 --%>
<script src="https://kit.fontawesome.com/0c69fdf2c0.js" crossorigin="anonymous"></script>
  
<script type="text/javascript">
<<<<<<< HEAD
   document.getElementById("toggleBtn").addEventListener("click", function() {
      let sidebar = document.getElementById("sidebar");
      let content = document.getElementById("mycontent");
=======
$(document).ready(function() {
    // 사이드바 토글 버튼 클릭 시
    $("#toggleBtn").click(function(e) {
        e.preventDefault(); // 기본 링크 동작 방지
        $("#sidebar").toggleClass("hidden"); // 사이드바 숨기기/보이기 토글
        $("#mycontent").toggleClass("full"); // mycontent 영역의 margin-left 조정
    });
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git

<<<<<<< HEAD
      sidebar.classList.toggle("hidden");
      content.classList.toggle("full");
   });
=======
    // 서브 메뉴 열기/닫기
    $("a.menu-toggle").click(function(e) {
        e.preventDefault(); // 기본 링크 동작 방지
        $(this).next("div.submenu").slideToggle(); // 하위 메뉴 열기/닫기
    });
});
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git

<<<<<<< HEAD
   $(document).ready(function() {
      $(".menu-toggle").click(function(e) {
         e.preventDefault(); // 기본 링크 동작 방지
         $(this).next(".submenu").slideToggle(); // 해당 하위 메뉴 열고 닫기
      });
   });
=======
const toggleBtn = document.querySelector("button#toggleBtn");
toggleBtn.addEventListener("click", function(){
  const side = document.querySelector("div#sidebar");
  side.classList.toggle("hidden");
});

>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git
</script>
   <div data-simplebar id="sidebar" class="sidebar">
   
   <button type="button" id="toggleBtn">☰</button>
   
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

<<<<<<< HEAD
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
=======
   <ul>
      <li><a href="<%=ctxPath%>"><i class="fa-solid fa-house-chimney"></i> <span>홈화면</span></a>
   
      <li><a href="<%=ctxPath%>/commute"><i class="fa-solid fa-clipboard-user"></i> <span>출퇴근 관리</span></a></li>
   
      <li>
      <a href="#" class="menu-toggle"> 
      <i class="fa-solid fa-suitcase-medical"></i> <span>진료</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">대기환자</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">진료정보입력</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">처방전 및 수납</a>
         </div></li>
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git

      <li>
      <a href="#" class="menu-toggle">
      <i class="fa-solid fa-file-signature"></i>  <span>원무</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/patient">환자조회</a>
             <a class="dropdown-item" href="<%=ctxPath%>/register">예약</a>
             <a class="dropdown-item" href="<%=ctxPath%>">입원실현황</a> 
             <a class="dropdown-item" href="<%=ctxPath%>/pay">수납</a>
         </div></li>
         
         <li><a href="<%=ctxPath%>"><i class="fa-solid fa-users-gear"></i> <span>근무교대 관리</span> </a></li>

      <li><a href="/attendance" class="menu-toggle"> 
      <i class="fa-solid fa-user-clock"></i> <span>근태관리</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">휴가관리</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">출장관리</a>
            <a class="dropdown-item" href="<%=ctxPath%>/attendance/commute">근태조회</a>
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">근무교대조회</a>
         </div></li>

<<<<<<< HEAD
   <ul>
      <li><a href="#" class="menu-toggle">진료</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">대기환자</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">진료정보입력</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">처방전 및 수납</a>
=======
      <li><a href="#" class="menu-toggle">
      <i class="fa-solid fa-square-poll-horizontal"></i>  <span>전자결재</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/approval/write">기안문작성</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재상신함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">임시저장함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재문서함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">참조문서함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재양식관리</a>
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git
         </div></li>

<<<<<<< HEAD
      <li><a href="#" class="menu-toggle">원무</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">환자조회</a>
             <a class="dropdown-item" href="<%=ctxPath%>">예약</a>
             <a class="dropdown-item" href="<%=ctxPath%>">입원실현황</a> 
             <a class="dropdown-item" href="<%=ctxPath%>">수납</a>
=======
      <li><a href="#" class="menu-toggle">
      <i class="fa-solid fa-envelope"></i> <span>메일</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">메일쓰기</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">받은메일함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">보낸메일함</a>
             <a class="dropdown-item" href="<%=ctxPath%>">휴지통</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">메일보관함</a>
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git
         </div></li>

<<<<<<< HEAD
      <li><a href="/attendance" class="menu-toggle">근태관리</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">휴가관리</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">출장관리</a>
             <a class="dropdown-item" href="<%=ctxPath%>/attendance/commute">근태조회</a>
         </div></li>
=======
      <li><a href="<%=ctxPath%>/notice/notice"><i class="fa-solid fa-bullhorn"></i> <span>공지사항</span></a> </li>
      <li><a href="<%=ctxPath%>/organizational/organizational"><i class="fa-solid fa-sitemap"></i> <span>조직도</span></a>
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git

<<<<<<< HEAD
      <li><a href="#" class="menu-toggle">전자결재</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">기안문작성</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재상신함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">임시저장함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재문서함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">참조문서함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재양식관리</a>
         </div></li>
=======
      <li><a href="<%=ctxPath%>/schedule/shareschedule" class="menu-toggle">
       <i class="fa-solid fa-calendar-days"></i>  <span>일정관리</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/schedule/shareschedule"><span>공유일정</span></a>
            <a class="dropdown-item" href="<%=ctxPath%>/schedule/oneschedule"><span>개인일정</span></a>
         </div>
      </li>
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git

<<<<<<< HEAD
      <li><a href="#" class="menu-toggle">메일</a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>">메일쓰기</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">받은메일함</a>
            <a class="dropdown-item" href="<%=ctxPath%>">보낸메일함</a>
             <a class="dropdown-item" href="<%=ctxPath%>">휴지통</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">메일보관함</a>
=======
      <li><a href="<%=ctxPath%>/board/list" class="menu-toggle">
      <i class="fa-solid fa-feather"></i> <span>커뮤니티</span><i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/board/list">자유게시판</a>
            <a class="dropdown-item" href="<%=ctxPath%>/community/myboard">내가 작성한 글 목록</a>
            <a class="dropdown-item" href="<%=ctxPath%>/community/bookmark">즐겨찾기</a>
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git
         </div></li>

<<<<<<< HEAD
      <li><a href="<%=ctxPath%>/notice/notice">공지사항</a></li>
      <li><a href="<%=ctxPath%>/organizational/organizational">조직도</a></li>
=======
      <li><a href="<%=ctxPath%>/memo/memo" class="menu-toggle">
      <i class="fa-solid fa-marker"></i> <span>메모</span><i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/memo/memo">메모장</a>
            <a class="dropdown-item" href="<%=ctxPath%>/memo/importantmemo">중요메모</a>
            <a class="dropdown-item" href="<%=ctxPath%>/memo/trash">휴지통</a>
         </div></li>
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git

<<<<<<< HEAD
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
=======
      <li><a href="<%=ctxPath%>/management/ManagementList" class="menu-toggle">
      <i class="fa-solid fa-address-card"></i> <span>인사관리</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/management/">근태내역집계</a>
            <a class="dropdown-item" href="<%=ctxPath%>/management/ManagementList">사원목록</a>
            <a class="dropdown-item" href="<%=ctxPath%>/management/ManagementFrom">사원등록</a>
         </div></li>
   </ul>
   
>>>>>>> branch 'main' of https://github.com/kiimhb/FinalProject_Groupware.git
</div>
