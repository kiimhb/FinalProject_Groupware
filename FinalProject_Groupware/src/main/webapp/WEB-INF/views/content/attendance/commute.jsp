<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String ctxPath = request.getContextPath();
//     /myspring
%>

<jsp:include page="../../header/header1.jsp" />

    <title>근태 현황</title>
    
    <style>
      
        .search-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .search-bar input, .search-bar select, .search-bar button {
            padding: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table, th, td {
            border: 1px solid #ddd;
            text-align: center;
        }
        th, td {
            padding: 10px;
        }
        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
        <h2>근태 현황</h2>
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
                    <th colspan="6">사고내역</th>
                    <th colspan="5">기초항목</th>
                </tr>
                <tr>
                    <th>휴가</th>
                    <th>출장</th>
                    <th>외근</th>
                    <th>교육</th>
                    <th>기타</th>
                    <th>계</th>
                    
                    <th>정상</th>
                    <th>지각</th>
                    <th>결근</th>
                    <th>근태이상</th>
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
                    <td>0</td>
                    <td>0</td>
                </tr>
            </tbody>
        </table>
       
</body>
</html>

<jsp:include page="../../footer/footer1.jsp" />  