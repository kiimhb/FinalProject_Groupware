<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.net.InetAddress" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simplebar/dist/simplebar.min.css">
<script src="https://cdn.jsdelivr.net/npm/simplebar/dist/simplebar.min.js"></script>
<%-- 
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> <!-- Spring security taglib을 사용 --> 
--%>

<%-- ===== header 페이지 만들기 ===== --%>
<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>    

<%
    // === (#웹채팅관련2) === 
    // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) ===
    
    InetAddress inet = InetAddress.getLocalHost();
     String serverIP = inet.getHostAddress();
     
    // System.out.println("serverIP : " + serverIP);
    // serverIP : 192.168.0.219
 
    // === 서버 포트번호 알아오기 === //
    int portnumber = request.getServerPort();
    // System.out.println("portnumber : " + portnumber);
    // portnumber : 9090
 
    String serverName = "http://"+serverIP+":"+portnumber;
    // System.out.println("serverName : " + serverName);
    // serverName : http://192.168.0.208:9090

%>

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />

<style type="text/css">
div.alarm_item{
   margin:3px;
   border-bottom: solid 1px #eee;
   font-size: 13px; 
   padding-top: 6px;
   padding-bottom: 6px;
   cursor: pointer;
}

span.alarm_category{
   font-size: 14px; 
   font-weight: bold;
}

span.alarm_at{
   display:inline-block;
   font-size: 11px;
   margin-left: 3px;
}

.alarm_item.read {
    background-color: #eee;
    color: gray;
}

span.alarm_count {
   position: absolute;
   display:inline-block;
    top: -3px;
    right: -2px;
    background: red;
    color: white;
    font-size: 12px;
    font-weight: bold;
    padding: 2px 8px;
    border-radius: 50%;
}
</style>
<%-- 
<%
   String ctxPath = request.getContextPath();
    //     /myspring    

    // === #221. (웹채팅관련3) === 
    // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) === 
    
 // InetAddress inet = InetAddress.getLocalHost();
 // String serverIP = inet.getHostAddress();
     
 // System.out.println("serverIP : " + serverIP);
 // serverIP : 192.168.0.219

 // String serverIP = "192.168.0.219";
    String serverIP = "43.203.242.79"; 
    // 자신의 EC2 퍼블릭 IPv4 주소임. // 아마존(AWS)에 배포를 하기 위한 것임. 
    // 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다. 
 
    // === 서버 포트번호 알아오기 === //
    int portnumber = request.getServerPort();
 // System.out.println("portnumber : " + portnumber);
 // portnumber : 9090
 
    String serverName = "http://"+serverIP+":"+portnumber;
 // System.out.println("serverName : " + serverName);
 // serverName : http://192.168.0.219:9090 

%>
--%>
<script type="text/javascript">
function toggleAlarm() {
     var AlarmBox = document.getElementById("Alarm_box");
     // 알림 박스가 보일 때는 숨기고, 숨겨져 있을 때는 보이게 하기
     if (AlarmBox.style.display === "block") {
        AlarmBox.style.display = "none";
     } else {
        AlarmBox.style.display = "block";
     }
   }
   
$.ajax({
      url:"<%= ctxPath%>/alarm/alarm",
      type: "get",
       dataType: "json",
       success:function(json){   
          
          let v_html = ``;
          if (json.get_alarm_view > 0) {
             v_html = `<div class="no_alarm">알림이 없습니다.</div>`;
           } else {
              
               json.get_alarm_view.forEach(function(item) {
                  
                  let notice_dept ='';
                 if (item.notice_dept == 0) {
                    notice_dept = '[전체]';
                  } else if (item.notice_dept == 1) {
                     notice_dept = '[진료부]';
                  } else if (item.notice_dept == 2) {
                     notice_dept = '[간호부]';
                  } else if (item.notice_dept == 3) {
                     notice_dept = '[경영지원부]';
                  } 
              
                  let readClass = item.alarm_is_read == 1 ? "read" : "";
                 v_html += `
                 <div class="alarm_item \${readClass}" >
                    <input type="hidden" value=\${item.alarm_no} id="alarm_no" />
                    <input type="hidden" value=\${item.alarm_category} id="alarm_category" />
                    <input type="hidden" value=\${item.alarm_is_read} id="alarm_is_read" />
                    <input type="hidden" value=\${item.alarm_cateno} id="alarm_cateno" />
                       <span class="alarm_category">[\${item.alarm_category}]</span>\${notice_dept}&nbsp;\${item.alarm_title}
                       <div class="alarm_at"> \${item.alarm_at}</div>
               </div>`;
               });
           }

           $("div.Alarm_main_box").html(v_html);
           
            // 알림 총 건수 출력
            let v_html2 = `읽지 않은 알림이 \${json.alarm_totalCount} 건 있습니다.`; 
            $("div.Alarm_sub_box").html(v_html2); 
            
            if (json.alarm_totalCount > 0) {
               $("span.alarm_count").text(json.alarm_totalCount).show();
            } else {
               $("span.alarm_count").hide();
            }
           
             
       },
       error: function (request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
       }
    });
    
$(document).ready(function () {
    $("div.alarm_item").on("click", function () {
       const alarm_item = $(this).find("div.alarm_item");
       const alarm_no = $(this).find("input#alarm_no").val();
       const alarm_category = $(this).find("input#alarm_category").val();
       const alarm_is_read = $(this).find("input#alarm_is_read").val();
       const alarm_cateno = $(this).find("input#alarm_cateno").val(); 
       

       if (alarm_is_read == 1) {
          alarm_link(alarm_category, alarm_cateno);
        }
       else if (alarm_is_read == 0) {
          $.ajax({
               url: "<%= ctxPath%>/alarm/alarm_is_read_1",
               type: "POST",
               data: { "alarm_no" : alarm_no },
               dataType: "json",
              success:function(json){   
                 //console.log(json);
                 
                     if(json.n == 1){
                       alarm_link(alarm_category, alarm_cateno);
                   }
               },
               error: function (xhr, status, error) {
                   alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error); 
             }
           });
       }
       
    });



   function alarm_link(alarm_category, alarm_cateno) {

       if (alarm_category == "결재") {
    	   const frm = document.detailTempFrm_2;
    	   $("input[name='draft_no']").val(alarm_cateno);
			frm.method = "post";
			frm.action = "<%= ctxPath%>/alarm/approvalPendingListDetail_tbl_alarm";
			frm.submit();
			

          
       } else if (alarm_category == "공지사항") {
           window.location.href = `<%= ctxPath%>/notice/detail/\${alarm_cateno}`;
       }
   }
});



</script>
	<form name="detailTempFrm_2">
		<input type="hidden" name="draft_no" />
	</form>

<%-- 상단 네비게이션 시작 --%>
   <nav class="navbar">
    
      <a class="navbar-brand" href="<%=ctxPath%>/index">
          <div class="logo-container">
              <img class="logo-img" src="<%=ctxPath%>/image/main_logo.png">
              <div class="logo-text">
                  <span class="main_logo">마포아삭병원</span>
                  <span class="main_logo2">Asak Medical Center</span>
              </div>
          </div>
      </a>
      
      <div class="navbar_menu">
      
         <button type="button"  class="dropdown-btn nav_button_css" onclick="toggleAlarm()">
            <i class="fa-solid fa-bell nav_i_css1"></i>
            <span class="alarm_count">${json.alarm_totalCount}</span>
         </button>

            <div id="Alarm_box" class="Alarm_box">
               <div data-simplebar class="Alarm_main_box"></div>
               <div class="Alarm_sub_box"></div>
            </div>
             

      <button type="button" class="nav_button_css" ><i class="fa-solid fa-message nav_i_css2" onclick="location.href='<%=ctxPath%>/chatting/chat'"></i></button>
      </div>
      
   </nav>
   
   