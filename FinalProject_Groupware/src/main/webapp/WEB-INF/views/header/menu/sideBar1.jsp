<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
   
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simplebar/dist/simplebar.min.css">
<script src="https://cdn.jsdelivr.net/npm/simplebar/dist/simplebar.min.js"></script>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
String ctxPath = request.getContextPath();
//     /med-groupware
%>
<%-- 아이콘 --%>
<script src="https://kit.fontawesome.com/1e8b6a814a.js" crossorigin="anonymous"></script>
<%-- 직접 만든 CSS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />
  
<script type="text/javascript">
$(document).ready(function() {
    $("#toggleBtn").click(function(e) {
        e.preventDefault();
        $("#sidebar").toggleClass("hidden");
        $(".profile").toggleClass("hidden");
        $("#mycontent").toggleClass("full");
    });

    $("a.menu-toggle").click(function(e) {
        e.preventDefault();
        $(this).next("div.submenu").slideToggle();
    });
});


</script>
   <div data-simplebar id="sidebar" class="sidebar">
   
   <button type="button" id="toggleBtn">☰</button>
 <c:if test="${not empty sessionScope.loginuser}">  
   <div class="profile">
      <div>프로필 사진</div>
      <div>[${sessionScope.loginuser.member_name} /${sessionScope.loginuser.child_dept_name}-${sessionScope.loginuser.member_position}]</div>
      
      <div>
      <a href="<%=ctxPath%>/mypage/mypage">마이페이지</a> 
      </div>
      
      <div>
      <a href="<%=ctxPath%>/management/logout">로그아웃</a>
      </div>
   </div>
 </c:if>
   <ul>
      <li><a class="sideBarCSS" href="<%=ctxPath%>"><i class="fa-solid fa-house-chimney sideBarICSS"></i> <span>홈화면</span></a>
      
      <li><a class="sideBarCSS" href="<%=ctxPath%>/management/login"> <span>로그인</span></a></li>
   
      <li><a class="sideBarCSS" href="<%=ctxPath%>/commuteRecord"><i class="fa-solid fa-clipboard-user sideBarICSS"></i> <span>출퇴근 관리</span></a></li>
   
      <li>
      <a href="#" class="menu-toggle sideBarCSS"> 
      <i class="fa-solid fa-suitcase-medical sideBarICSS"></i> <span>진료</span> <i class="fa-solid fa-chevron-down "></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/patient/patientReg">환자등록</a>
            <a class="dropdown-item" href="<%=ctxPath%>/patient/patientWaiting">대기환자</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/order/orderEnter">진료정보입력</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/order/orderNpay">처방전 및 수납</a>
         </div></li>

      <li>
      <a href="#" class="menu-toggle sideBarCSS">
      <i class="fa-solid fa-file-signature sideBarICSS"></i>  <span>원무</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/patient/list">환자조회</a>
             <a class="dropdown-item" href="<%=ctxPath%>/register/list">예약</a>
             <a class="dropdown-item" href="<%=ctxPath%>">입원실현황</a> 
             <a class="dropdown-item" href="<%=ctxPath%>/pay/wait">수납</a>
         </div></li>
         
         <li><a class="sideBarCSS" href="<%=ctxPath%>"><i class="fa-solid fa-users-gear sideBarICSS"></i> <span>근무교대 관리</span> </a></li>

      <li><a href="#" class="menu-toggle sideBarCSS"> 
      <i class="fa-solid fa-user-clock sideBarICSS"></i> <span>근태관리</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">휴가관리</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">출장관리</a>
            <a class="dropdown-item" href="<%=ctxPath%>/attendance/commute">근태조회</a>
            <a class="dropdown-item" href="<%=ctxPath%>/attendance">근무교대조회</a>
         </div></li>

      <li><a href="#" class="menu-toggle sideBarCSS">
      <i class="fa-solid fa-square-poll-horizontal sideBarICSS"></i>  <span>전자결재</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/approval/write">기안문작성</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/approval/approvalRequestList">결재상신함</a>
            <a class="dropdown-item" href="<%=ctxPath%>/approval/approvalTemporaryList">임시저장함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/approval/approvalPendingList"">결재문서함</a>
            <a class="dropdown-item" href="<%=ctxPath%>/approval/referenceApprovals">참조문서함</a> 
            <a class="dropdown-item" href="<%=ctxPath%>">결재양식관리</a>
         </div></li>

      <li><a href="#" class="menu-toggle sideBarCSS">
      <i class="fa-solid fa-envelope sideBarICSS"></i> <span>메일</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/mail/mailWrite">메일쓰기</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/mail/mailReceive">받은메일함</a>
            <a class="dropdown-item" href="<%=ctxPath%>/mail/mailSend">보낸메일함</a>
            <a class="dropdown-item" href="<%=ctxPath%>/mail/mailTrash">휴지통</a> 
            <a class="dropdown-item" href="<%=ctxPath%>/mail/mailStorage">메일보관함</a>

         </div></li>

      <li><a class="sideBarCSS" href="<%=ctxPath%>/notice/list"><i class="fa-solid fa-bullhorn sideBarICSS"></i> <span>공지사항</span></a>  </li>
      <li><a class="sideBarCSS" href="<%=ctxPath%>/organization/orgChart"><i class="fa-solid fa-sitemap sideBarICSS"></i> <span>조직도</span></a>

      <li><a class="sideBarCSS" href="<%=ctxPath%>/schedule/scheduleManagement" > <i class="fa-solid fa-calendar-days sideBarICSS"></i>  <span>일정관리</span> </a> </li>

      <li><a href="#" class="menu-toggle sideBarCSS">
      <i class="fa-solid fa-feather sideBarICSS"></i> <span>커뮤니티</span><i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/board/list">자유게시판</a>
            <a class="dropdown-item" href="<%=ctxPath%>/community/myboard">내가 작성한 글 목록</a>
            <a class="dropdown-item" href="<%=ctxPath%>/community/bookmark">즐겨찾기</a>
         </div></li>

      <li><a href="#" class="menu-toggle sideBarCSS">
      <i class="fa-solid fa-marker sideBarICSS"></i> <span>메모</span><i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/memo/memowrite">메모장</a>
            <a class="dropdown-item" href="<%=ctxPath%>/memo/importantmemo">중요메모</a>
            <a class="dropdown-item" href="<%=ctxPath%>/memo/trash">휴지통</a>
         </div></li>

      <li><a href="#" class="menu-toggle sideBarCSS">
      <i class="fa-solid fa-address-card sideBarICSS"></i> <span>인사관리</span> <i class="fa-solid fa-chevron-down"></i></a>
         <div class="submenu">
            <a class="dropdown-item" href="<%=ctxPath%>/management/">근태내역집계</a>
            <a class="dropdown-item" href="<%=ctxPath%>/management/ManagementList">사원목록</a>
            <a class="dropdown-item" href="<%=ctxPath%>/management/ManagementForm">사원등록</a>
         </div></li>
   </ul>
   
</div>
