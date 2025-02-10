<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="../../header/header1.jsp" />

        <div class="header">사원등록</div>
        <div class="profile-container">
            <div class="profile-box">프로필 사진</div>
            <input type="file" name="attach">프로필 사진 변경 
        </div>
        <form>
            <div class="form_manag">
                <label>이름 :</label>
                <input type="text">
            </div>
            <div class="form_manag">
                <label>부문 :</label>
                <input type="text">
            </div>
            <div class="form_manag">
                <label>부서 :</label>
                <input type="text">
            </div>
            <div class="form_manag">
                <label>이메일 :</label>
                <input type="email">
            </div>
            <div class="form_manag">
                <label>휴대폰 :</label>
                <input type="text">
            </div>
            <div class="form_manag">
                <label>생년월일 :</label>
                <input type="date">
            </div>
            <div class="form_manag">
                <label>입사일자 :</label>
                <input type="date">
            </div>
            <button class="submit-btn">사원 등록하기</button>
        </form>


<jsp:include page="../../footer/footer1.jsp" />    