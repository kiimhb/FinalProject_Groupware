<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
	String ctxPath = request.getContextPath();
    //     /myspring
%>    
		<div id="sidebar" class="sidebar">
    <ul>
        <li>
            <a href="#" class="menu-toggle">진료</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">대기환자</a>
                <a class="dropdown-item" href="<%=ctxPath%>">진료정보입력</a>
                <a class="dropdown-item" href="<%=ctxPath%>">처방전 및 수납</a>
            </div>
        </li>

        <li>
            <a href="#" class="menu-toggle">원무</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">환자조회</a>
                <a class="dropdown-item" href="<%=ctxPath%>">예약</a>
                <a class="dropdown-item" href="<%=ctxPath%>">입원실현황</a>
                <a class="dropdown-item" href="<%=ctxPath%>">수납</a>
            </div>
        </li>

        <li>
            <a href="#" class="menu-toggle">근태관리</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">휴가관리</a>
                <a class="dropdown-item" href="<%=ctxPath%>">출장관리</a>
                <a class="dropdown-item" href="<%=ctxPath%>">근태조회</a>
            </div>
        </li>

        <li>
            <a href="#" class="menu-toggle">전자결재</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">기안문작성</a>
                <a class="dropdown-item" href="<%=ctxPath%>">결재상신함</a>
                <a class="dropdown-item" href="<%=ctxPath%>">임시저장함</a>
                <a class="dropdown-item" href="<%=ctxPath%>">결재문서함</a>
                <a class="dropdown-item" href="<%=ctxPath%>">참조문서함</a>
                <a class="dropdown-item" href="<%=ctxPath%>">결재양식관리</a>
            </div>
        </li>

        <li>
            <a href="#" class="menu-toggle">메일</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">메일쓰기</a>
                <a class="dropdown-item" href="<%=ctxPath%>">받은메일함</a>
                <a class="dropdown-item" href="<%=ctxPath%>">보낸메일함</a>
                <a class="dropdown-item" href="<%=ctxPath%>">휴지통</a>
                <a class="dropdown-item" href="<%=ctxPath%>">메일보관함</a>
            </div>
        </li>

        <li><a href="<%=ctxPath%>">주소록목록</a></li>
        <li><a href="<%=ctxPath%>">공지사항</a></li>
        <li><a href="<%=ctxPath%>">조직도</a></li>

        <li>
            <a href="#" class="menu-toggle">일정관리</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">전체일정</a>
                <a class="dropdown-item" href="<%=ctxPath%>">개인일정</a>
                <a class="dropdown-item" href="<%=ctxPath%>">부서일정</a>
            </div>
        </li>

        <li>
            <a href="#" class="menu-toggle">커뮤니티</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">자유게시판</a>
                <a class="dropdown-item" href="<%=ctxPath%>">내가 작성한 글 목록</a>
                <a class="dropdown-item" href="<%=ctxPath%>">즐겨찾기</a>
            </div>
        </li>

        <li>
            <a href="#" class="menu-toggle">메모</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">메모장</a>
                <a class="dropdown-item" href="<%=ctxPath%>">중요메모</a>
                <a class="dropdown-item" href="<%=ctxPath%>">휴지통</a>
                <a class="dropdown-item" href="<%=ctxPath%>">드라이브</a>
            </div>
        </li>

        <li>
            <a href="#" class="menu-toggle">인사관리</a>
            <div class="submenu">
                <a class="dropdown-item" href="<%=ctxPath%>">사원목록</a>
                <a class="dropdown-item" href="<%=ctxPath%>">사원등록</a>
            </div>
        </li>
    </ul>
</div>


<style>
    .sidebar {
        width: 250px;
        min-height: 100vh; /* 최소 높이를 화면 전체로 설정 */
        position: absolute; /* 고정되지 않고 페이지 흐름을 따름 */
        transition: width 0.3s;
    }

    .sidebar.hidden {
        width: 0;
        overflow: hidden;
    }

    .sidebar ul {
        list-style: none;
        padding: 0;
    }

    .sidebar li {
        padding: 10px;
    }


    .dropdown-item {
        padding-left: 20px;
        display: block;
    }
    
    .submenu {
        display: none; /* 처음에 숨김 */
    }
</style>

   <script>
    document.getElementById("toggleBtn").addEventListener("click", function () {
        let sidebar = document.getElementById("sidebar");
        let content = document.getElementById("mycontent");

        sidebar.classList.toggle("hidden");
        content.classList.toggle("full");
    });
    
    $(document).ready(function () {
        $(".menu-toggle").click(function (e) {
            e.preventDefault(); // 기본 링크 동작 방지
            $(this).next(".submenu").slideToggle(); // 해당 하위 메뉴 열고 닫기
        });
    });
</script>