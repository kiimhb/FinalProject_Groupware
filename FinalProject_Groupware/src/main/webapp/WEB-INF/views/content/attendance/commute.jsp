<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%
String ctxPath = request.getContextPath();
//     /myspring
%>
<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/attendance/commute.css" />
<jsp:include page="../../header/header1.jsp" />

<div class="subContent">

       <div class="manag_h3">
		 <h3>근태관리 <근태현황> </h3>
	   </div>
		
        <div class="search-bar">
            <label>조회기간:</label>
            <input type="date" id="start-date"> ~ <input type="date" id="end-date">
            <label>근태항목:</label>
            <select>
                <option value="전체">전체</option>
            </select>
            <label>근태구분:</label>
            <select>
                <option value="전체">전체</option>
            </select>
            <button>검색</button>
            
             <button type="button">엑셀 저장</button>
        </div>
        <table>
            <thead>
                <tr>
                    <th rowspan="2">부문</th>
                    <th rowspan="2">부서</th>
                    <th rowspan="2">직급</th>
                    <th rowspan="2">이름</th>
                    <th rowspan="2">기초계</th>
                    <th rowspan="2">사고계</th>
                    <th colspan="4">사고내역</th>
                    <th colspan="5">기초항목</th>
                </tr>
                <tr>
                    <th>휴가</th>
                    <th>출장</th>
                    <th>기타</th>
                    <th>계</th>
                    
                    <th>정상</th>
                    <th>지각</th>
                    <th>결근</th>
                    <th>조퇴</th>
                    <th>계</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>간호부</td>
                    <td>평간호사</td>
                    <td>홍길동</td>
                    <td>26</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                </tr>
            </tbody>
        </table>
       
</div>
<jsp:include page="../../footer/footer1.jsp" />  