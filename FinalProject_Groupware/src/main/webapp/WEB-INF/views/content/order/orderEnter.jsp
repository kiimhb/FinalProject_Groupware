<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
    //     /med-groupware
%>

<%
	String firstPatient_no = request.getParameter("firstPatient_no");
%>


<jsp:include page="../../header/header1.jsp" />



<link href='<%=ctxPath %>/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/index/index.css" />
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>


<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath%>/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath%>/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">


const orderYN = confirm("진료 정보 입력을 위해 오더를 생성하시겠습니까?")

if(orderYN == false){
	goWaiting();
}
else{
	
}


$(document).ready(function(){
	
	
	
	

	var calendarEl = document.getElementById('calendar'); //
	
	var calendar = new FullCalendar.Calendar(calendarEl, {
		
		initialView: 'dayGridMonth',
        locale: 'ko',
        selectable: true,
	    editable: false,
	    headerToolbar: {
	    	start: 'title', // will normally be on the left. if RTL, will be on the right
	    	center: '',
	    	end: 'today prev,next'
	    },
	    dayMaxEventRows: true, // for all non-TimeGrid views
	    views: {
	      timeGrid: {
	        dayMaxEventRows: 3 // adjust to 6 only for timeGridWeek/timeGridDay
	      }
	    },
     	dateClick: function(info) {
      	 	// alert('클릭한 Date: ' + info.dateStr); // 클릭한 Date: 2021-11-20
      	    $(".fc-day").css('background','none'); // 현재 날짜 배경색 없애기
      	    info.dayEl.style.backgroundColor = '#b1b8cd'; // 클릭한 날짜의 배경색 지정하기
      	    $("form > input[name=chooseDate]").val(info.dateStr);
      	    
      	  }
	});
	/* 캘린더 띄움 끝 */
	
	calendar.render();  // 풀캘린더 보여주기
	
	
	
	
	/*
	document.getElementById("readyToSymptomDetail").addEventListener("click", function() {
	    this.value = "";
	});
	*/
	
	
	$("div#orderHowLongHosp").hide()
	$("div#orderSurgDetail").hide();
	
	$("button#goSurgeryOrder").click(function(){
		$("div#orderHowLongHosp").hide()
		$("div#orderSurgDetail").show();
		
	})
	
	$("button#goHospOrder").click(function(){
	
		$("div#orderSurgDetail").hide();
		$("div#orderHowLongHosp").show();
	})
	
	
	
	
	
	$("button#hospConfirm").click(function(){
		
	
		const hospYN = confirm("원무과에 입원 일정을 요청하시겠습니까? ")
		
		const order_howlonghosp = $("input#howLongHosp").val();
		const hospPrice = 20000*order_howlonghosp
		
		
		if(hospYN == true){
			$.ajax({
				   url:"<%= ctxPath%>/order/requestHosp",
				   type:"post",
				   data:{"orderNo":$("input#hiddenOrderNo").val()
					   	,"hiddenPatientNo":$("input#hiddenPatientNo").val()
					   	,"order_howlonghosp":order_howlonghosp
					   	,"hospPrice":hospPrice},
				   dataType:"json",
				   success:function(json){
					   alert("요청 완료되었습니다.");
					   
						v_html = ``;
						
						v_html +=`<td>입원 \${order_howlonghosp} 일</td>
									<td class="price">\${hospPrice} 원</td>`;
									
						$("tr#hosp").html(v_html);
						$("#confirmButton1").text("요청완료");
						
						
					   
				   },
				   error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				   }
			
			})
		}
		else{
			
		}
		
	})
	
			
	   
		<%-- 수술 확정하기--%>		
		$(document).on("click", "button#surgeryConfirm", function(){
			
			const surgeryType_name = $("select#selectSurgery").val();
			const surgery_description = $("input#surgeryExplain").val();
			const orderNo = $("input#hiddenOrderNo").val();
			const hiddenPatientNo = $("input#hiddenPatientNo").val();
			
			
			const select = document.getElementById("selectSurgery");
		    const selectedOption = select.options[select.selectedIndex];
			const surgeryType_no = selectedOption.getAttribute("data-no");
			
			//console.log(surgeryType_no);
			
			
			if(surgeryType_name != "" && surgery_description != ""){							
			
			$.ajax({
				  url:"<%= ctxPath%>/order/surgeryConfirm",
				  data:{"surgeryType_name":surgeryType_name
					   ,"surgery_description":surgery_description
					   ,"orderNo":orderNo
					   ,"hiddenPatientNo":hiddenPatientNo},
				  type:"post",
				  dataType:"json",
				  success:function(json){
					  console.log(JSON.stringify(json));
					  
	
					  $.ajax({
						  url:"<%= ctxPath%>/order/callSurgeryPrice",
						  data:{"surgeryType_no":surgeryType_no
							   ,"orderNo":orderNo},
						  type:"post",
						  dataType:"json",
						  success:function(response){
							  
						  console.log(response);
							  
							  let v_html = ``;
							  
							  v_html += `<td>\${response.surgeryType_name}</td>
							  			<td class="price">\${response.surgeryType_Price}원</td>`;
							  
							$("tr#surgeryName").html(v_html);
							 
							alert("요청 완료되었습니다.");
							$("#confirmButton").text("요청완료");
							  			
						  },
						  error: function(request, status, error){
						      alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						  }					  
					  					  
					  
					  }) // end of ajax
					  
					  
				  },
				  error: function(request, status, error){
				      alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				  }
			});			
			}
			else{
				
				if(surgeryType_name == ""){
					alert("수술 종류를 선택해주세요 !")
				}
				if(surgery_description == ""){
					alert("수술 설명을 입력해주세요 !")
				}
			}
			
		});
	

	
	
	<%--// === 질병 검색시 자동 완성하기 1 === // --%>
	   $("div#deseaseList").hide();	   
	   $("input[name='searchDesease']").keyup(function(){
		  
		   const wordLength = $(this).val().trim().length;
		   // 검색어에서 공백을 제거한 길이를 알아온다.
		   
		   if(wordLength == 0) {
			   $("div#deseaseList").hide();
			   // 검색어가 공백이거나 검색어 입력후 백스페이스키를 눌러서 검색어를 모두 지우면 검색된 내용이 안 나오도록 해야 한다. 
		   }		   
		   else {
			   
			   if( $("input[name='searchDeseaseType']").val() == "searchDeseaseType") {
					
				   $.ajax({
					   url:"<%= ctxPath%>/order/deseaseSearchShow",
					   type:"get",
					   data:{"searchDeseaseType":$("input[name='searchDeseaseType']").val()
						    ,"searchDesease":$("input[name='searchDesease']").val()},
					   dataType:"json",
					   success:function(json){
						   <%-- === #93. 검색어 입력시 자동글 완성하기 7 === --%>
						   if(json.length > 0){
							   
							   let v_html = ``;
							   
							   $.each(json, function(index, item){
								   const word = item.word;
								   
							       const idx = word.toLowerCase().indexOf($("input[name='searchDesease']").val().toLowerCase());
							   
							       const len = $("input[name='searchDesease']").val().length; 
							       
							       const result = word.substring(0, idx) + "<span style='font-weight:bold;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len); 
							       
								   v_html += `<span style='cursor:pointer;' id='deseaseResult';>\${result}</span><br>`;
								   
							   }); // end of $.each(json, function(index, item){})-----------
							   
							   const input_width = $("input[name='searchDesease']").css("width"); // 검색어 input 태그 width 값 알아오기  
							   
							   $("div#deseaseList").css({"width":input_width}); // 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
							   
							   $("div#deseaseList").html(v_html).show();

						   }
					   },
					   error: function(request, status, error){
						   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					   }    
				   });
				   
			   }
		   }
	   });// end of $("input[name='searchWord']").keyup(function(){})--------
	   
	   
	   <%-- === #94. 검색어 입력시 자동글 완성하기 8 === --%>
	   $(document).on("click", "span#deseaseResult", function(e){
		   const word = $(e.target).text();
		   $("input[name='searchDesease']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다.
		   $("div#deseaseList").hide();
	   });	
	

	   <%-- 질병 검색후 클릭해서 질병 보여주기--%>
		$("button[name='addDesease']").click(function(){
			//$("div#deseaseList").hide();								
			
			if($("input[name='searchDesease']").val() !=""){
				
				$.ajax({
					
					url:"<%= ctxPath%>/order/addDesease",
					data:{"desease_name":$("input[name='searchDesease']").val()},
					dataType:"json",
					success:function(json){
						console.log(JSON.stringify(json));										
																						
						const desease_name = $("input[name='searchDesease']").val();
						
						let v_html=``;
						
						v_html += `	
									<div style="margin-left:6.6%;"><i class="fa-solid fa-syringe"></i>&nbsp;&nbsp;\${desease_name}</div>
									<input id="desease_name" type="hidden" value="\${desease_name}" />									
								  `;			
									
						$("div#pickedDesease").html(v_html);
						
						$("input[name='searchDesease']").val("");
						
					},
					error: function(request, status, error){
						   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			}
			else{
				alert("질병 명을 입력해주세요 !")
			}
			
			
			
		}) // end of $("button[name='addMedicine']").click(function(){
		
		
	
		$(document).on("click", ".fa-xmark", function() {
		    $(this).parent().remove(); // 부모 div(.deseaseCollection) 삭제
		});				
		
		// 질병 확정버튼 눌러서 보내기
		$(document).on("click", "button#submitDesease", function(){
							
		    const inputDeseaseName = $("input#desease_name").val();
			 
		    if (inputDeseaseName != null){
		    
			    	$.ajax({
						
						url:"<%= ctxPath%>/order/orderDesease",
						data:{"desease_name":inputDeseaseName
							 ,"orderNo":$("input#hiddenOrderNo").val()
							 ,"hiddenPatientNo":$("input#hiddenPatientNo").val()},
						type:"post",
						dataType:"json",
						success:function(json){
							console.log(JSON.stringify(json));
							alert("병명이 전송되었습니다.")
														
						},
						error: function(request, status, error){
							   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						}
					});
			    	
			  } // end of if 
			  else{
				  alert("질병 명을 입력해 주세요 !")
			  }
			    
			    
		}); // end of $(".deseaseCollection").each(function() {
		

		
	
	   <%--// === 약 검색어 입력시 약 자동 완성하기 2 === // --%>
	   $("div#medicineList").hide();
	   
	   $("input[name='searchMedicine']").keyup(function(){
		   
		  
		   const wordLength = $(this).val().trim().length;
		   // 검색어에서 공백을 제거한 길이를 알아온다.
		   
		   if(wordLength == 0) {
			   $("div#medicineList").hide();
			   // 검색어가 공백이거나 검색어 입력후 백스페이스키를 눌러서 검색어를 모두 지우면 검색된 내용이 안 나오도록 해야 한다. 
		   }
		   else {

			   if( $("input[name='searchMedicineType']").val() == "searchMedicineType") {
					
				   $.ajax({
					   url:"<%= ctxPath%>/order/medicineSearchShow",
					   type:"get",
					   data:{"searchMedicineType":$("input[name='searchMedicineType']").val()
						    ,"searchMedicine":$("input[name='searchMedicine']").val()},
					   dataType:"json",
					   
					   success:function(json){
						   <%-- === #93. 검색어 입력시 자동글 완성하기 7 === --%>
						   if(json.length > 0){
							   
							   let v_html = ``;
							   
							   $.each(json, function(index, item){
								   const word = item.word;
								   
							       const idx = word.toLowerCase().indexOf($("input[name='searchMedicine']").val().toLowerCase());
							   
							       const len = $("input[name='searchMedicine']").val().length; 
							       
							       const result = word.substring(0, idx) + "<span style='font-weight:bold;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len); 
							       
								   v_html += `<span style='cursor:pointer;' id='medicineResult'>\${result}</span><br>`;
								   
							   }); // end of $.each(json, function(index, item){})-----------
							   
							   const input_width = $("input[name='searchMedicine']").css("width"); // 검색어 input 태그 width 값 알아오기  
							   
							   $("div#medicineList").css({"width":input_width}); // 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
							   
							   $("div#medicineList").html(v_html).show();
						   }
					   },
					   error: function(request, status, error){
						   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					   }    
				   });
				   
			   }
		   }
	   });// end of $("input[name='searchWord']").keyup(function(){})--------
	
	
	
	   <%--// === 약 검색어 입력시 약 자동 완성하기 2 === // --%>
	   $(document).on("click", "span#medicineResult", function(e){
		   const word = $(e.target).text();
		   $("input[name='searchMedicine']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다.
		   $("div#medicineList").hide();
		   <%-- goSearch(); --%>
	   });
	
		
	   let medicine_count = 0
	   <%-- 약 검색후 클릭해서 약이름이랑 약처방 보여주기--%>
		$("button[name='addMedicine']").click(function(){
			$("div#medicineList").hide();
			if($("input[name='searchmedicine']").val() !=""){			
				$.ajax({
					
					url:"<%= ctxPath%>/order/addMedicine",
					data:{"medicineName":$("input[name='searchMedicine']").val()},
					dataType:"json",
					success:function(json){
						console.log(JSON.stringify(json));	
												
						
						const medicineNo = `oneMedicine_\${medicine_count}`
						medicine_count ++;
						
						
						v_html = `
								  <div id="\${medicineNo}" class="medicineCollection">
									  <span style="width: 300px; display: inline-block;">\${json.medicineName}</span>								
									  <button type="button" name="man" id="btnmorning_\${medicineNo}" class="btn btn-light ml-1 btnmorning">아침</button>
									  <input type="hidden" name="man" id="morning_\${medicineNo}" value="0"/>
									  <button type="button" name="man" id="btnafternoon_\${medicineNo}" class="btn btn-light ml-1 btnafternoon">점심</button>
									  <input type="hidden" name="man" id="afternoon_\${medicineNo}" value="0"/>
									  <button style="margin-right:150px;" type="button" name="man" id="btnnight_\${medicineNo}" class="btn btn-light ml-1 btnnight">저녁</button>
									  <input type="hidden" name="man" id="night_\${medicineNo}" value="0"/>
									  
									  
									  <label for="before_\${medicineNo}">식전</label>
									  <input type="radio" name="beforeafter_\${medicineNo}" value="1" id="before_\${medicineNo}" />
									  <label for="after_\${medicineNo}" >식후</label>
									  <input type="radio" name="beforeafter_\${medicineNo}" value="0" id="after_\${medicineNo}" style="margin-right:150px;" />
									  
									  <input type="number" name="medicinePerday" id="inputPerday_\${medicineNo}"/>
									  <button id="save_\${medicineNo}" type="button" style="background-color:#b3d6d2"class="saveMedicineData" data-id="\${medicineNo}">저장</button>&nbsp;&nbsp;
									  <i style='cursor:pointer;' id='\${medicineNo}' class="fa-solid fa-xmark deleteMedicineData"></i>
								  </div>

								`;
						
								
						$("div#pickedMedicine").append(v_html);
						
						let selectedMedicineId = $("#save_" + medicineNo).attr("id");
					    console.log("selectedMedicineId:", selectedMedicineId);
						
						
					},
					error: function(request, status, error){
						   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			}
		}) // end of $("button[name='addMedicine']").click(function(){
		
		
		$(document).on("click", ".btnmorning, .btnafternoon, .btnnight", function () {
		    /*
			let parentDiv = $(this).closest(".medicineCollection");
		    let buttonType = $(this).attr("id").split("_")[0];
		    let medicineId = parentDiv.attr("id");

		    let hiddenInput = parentDiv.find(`#${buttonType}_${medicineId}`);  // 수정된 부분

		    let currentValue = parseInt(hiddenInput.val()) || 0;  // NaN 처리
		    let newValue = currentValue === 0 ? 1 : 0;
		    hiddenInput.val(newValue);
		    */
			
			let parentDiv = $(this).closest(".medicineCollection"); 
		    let buttonType = $(this).attr("id").split("_")[0]; 
		    let hiddenInput = parentDiv.find(`#\${buttonType.replace("btn", "")}_\${parentDiv.attr("id")}`);

		    let currentValue = parseInt(hiddenInput.val());
		    let newValue = currentValue === 0 ? 1 : 0;
		    hiddenInput.val(newValue);

		    $(this).css("background-color", "#b3d6d2");
		    //$(this).toggleClass("btn-primary btn-success"); //
		});
		
		$(document).on("change", "input[type=radio]", function () {
		    let parentDiv = $(this).closest(".medicineCollection"); 
		    let selectedValue = parentDiv.find("input[type=radio]:checked").val();
		   // console.log(`약 (\${parentDiv.attr("id")}) 선택된 식사 전/후: \${selectedValue}`);
		});
		
		let medicineList = [];
		
		$(document).on("click", ".saveMedicineData", function () {
		    let parentDiv = $(this).closest(".medicineCollection");
		    let medicineId = parentDiv.attr("id"); 

		    let prescribe_name = parentDiv.find("span").text();
		    let prescribe_morning = parentDiv.find(`#morning_\${medicineId}`).val();
		    let prescribe_afternoon = parentDiv.find(`#afternoon_\${medicineId}`).val();
		    let prescribe_night = parentDiv.find(`#night_\${medicineId}`).val();
		    let prescribe_beforeafter = parentDiv.find(`input[name="beforeafter_\${medicineId}"]:checked`).val();
		    let prescribe_perday = parentDiv.find(`#inputPerday_\${medicineId}`).val();
		    let fk_order_no = $("input#hiddenOrderNo").val();

		    let medicineData = {
		    	medicineId, 		    
		    	prescribe_name,
		    	prescribe_morning,
		    	prescribe_afternoon,
		    	prescribe_night,
		        prescribe_beforeafter,
		        prescribe_perday,
		        fk_order_no,
		    };
		    
		    let existingIndex = medicineList.findIndex(m => m.medicineId === medicineId);
		    if (existingIndex > -1) {
		        medicineList[existingIndex] = medicineData;
		    } else {
		        medicineList.push(medicineData);
		    }
			
		    
		    
		    
		    $(this).text("저장완료"); 
		    
		    
		    
		    console.log("현재 저장된 전체 데이터:", medicineList);
		    		    		    		    		    
		});
			
		$(document).on("click", ".deleteMedicineData", function () {
		    let medicineId = $(this).attr("id"); 
		    let parentDiv = $(this).closest(".medicineCollection");

		    medicineList = medicineList.filter(m => m.medicineId !== medicineId);

		    parentDiv.remove();

		    console.log("삭제 후 남은 데이터:", medicineList);
		});
		

		// 약 확정 버튼 눌러서 데이터 insert하기
		$(document).on("click", "button#medicineSubmit", function(){
			
			console.log(JSON.stringify(medicineList));
			const orderNo = $("input#hiddenOrderNo").val();
			
			const medicineSubmitYN = confirm("오더에 약을 추가하시겠습니까?")
			
			if(medicineSubmitYN == true){								
			
				$.ajax({
					
					url:"<%= ctxPath%>/order/medicineSubmit",
					data:JSON.stringify(medicineList),
					contentType: "application/json; charset=utf-8",
					type:"post",
					dataType:"json",
					success:function(prescribeJson){
				
						
						$.ajax({
							
							url:"<%= ctxPath%>/order/callMedicinePrice",
							data:JSON.stringify(medicineList),
							contentType: "application/json; charset=utf-8",
							type:"post",
							dataType:"json",
							success:function(priceJson){
								
								console.log("prescribeJson:", prescribeJson);
								console.log("priceJson:", priceJson);
								
							let result = prescribeJson.map(prescribeItem => {
						    // 🔥 공백 제거 & 대소문자 통일 (소문자로 변환)
						    let prescribeName = prescribeItem.prescribe_name.trim().toLowerCase();
						    
						    let priceItem = priceJson.find(price => price.medicine_name.trim().toLowerCase() === prescribeName);
						
						    if (priceItem) {
						        return {
						            medicine_name: priceItem.medicine_name,
						            medicine_price: priceItem.medicine_price,
						            prescribe_perday: prescribeItem.prescribe_perday,
						            totalPrice: parseInt(prescribeItem.prescribe_perday) * parseInt(priceItem.medicine_price)
						        };
						    }
						    return null;
						}).filter(item => item !== null);
								
								console.log("result잘나와라젭알", result);
								
								$.ajax({
									
									url:"<%= ctxPath%>/order/medicinePriceSubmit",
									contentType: "application/json",
									data:JSON.stringify({ "result": result, "orderNo": orderNo }),									
									type:"post",
									success:function(response){
										
										alert("처방 전송 완료");
										
									},error: function(request, status, error){
										   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
									}
								});

								v_html = ``;
								
								$.each(result, function(index, item){
									
									

									
									v_html += `<tr>
							                    <td>\${item.medicine_name}</td>
							                    <td class="price">\${item.medicine_price}원</td>
							                  </tr>`;
											
								});
								
								$("tr#medicine").after(v_html); 
								
								
							},
							error: function(request, status, error){
								   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
							}
							
						});
						
						
						
						
						
						
					},
					error: function(request, status, error){
						   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			}
			else{
				
			}
				
		});
			
			
		

			
		

<%-- 
		약 다 누르고 확정버튼 누르기
		$(document).on("click", "button#medicineSubmit", function(){
			
			const prescribe_name = $("input#searchMedicineId").val();
			
			const beforeafter = $("input[name='beforeafter']:checked").val();
			
			const perDay = $("input#inputPerday").val();
			
			const morning = $("input#morning").val();
			const afternoon = $("input#afternoon").val();
			const night = $("input#night").val();
			
			$.ajax({
				
				url:"<%= ctxPath%>/order/medicineSubmit",
				data:{"prescribe_perday":perDay,
					  "prescribe_beforeafter":beforeafter,
					  "prescribe_morning":morning,
					  "prescribe_afternoon":afternoon,
					  "prescribe_night":night,
					  "prescribe_name":prescribe_name,
					  "orderNo":$("input#hiddenOrderNo").val()},
				type:"post",
				contentType: "application/json; charset=utf-8",
				dataType:"json",
				success:function(json){
					console.log(JSON.stringify(json));
					$("div#oneMedicine").hide();
					$("input#searchMedicineId").text("");
					
				},
				error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});

			
		}) // end of $(document).on("click", "input#medicineSubmit", function(){
		--%>

}); // end of 페이지로드



function clickOrderList(){
	
	alert(${requestScope.clickpatient.patient_no});
	
	$.ajax({
		  url:"<%= ctxPath%>/order/clickOrderRecord",
		  data:{"clickPatient_no":"${requestScope.clickpatient.patient_no}"},
		  dataType:"json",
		  success:function(json){
			  console.log(JSON.stringify(json));
		  },
		  error: function(request, status, error){
		      alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		  }
	});
	
	
}


function goWaiting(){
	window.location.href = "<%= ctxPath%>/patient/patientWaiting";
}


function sumPrice(){
	
	let total = 0; // total 변수 초기화
	
	$("td.price").each(function() {
        // "원" 제거하고 값만 가져오기
        let price = parseInt($(this).text().replace("원", "").trim());
        
        // 총합에 더하기
        total += price;
        
        console.log(total);
              
    });
		
	let sumTotal = total+5000;
	
	let v_html = ``;
	
	v_html += `<td>총 수납금액</td>
				<td>\${sumTotal} 원</td><input type="hidden" id="sumTotal" value="sumTotal" />`;
				
	$("tr#sumPriceResult").html(v_html)
	
}


function orderFinalConfirm(){
	
	const detailSymptom = $("textarea#readyToSymptomDetail").val()
	const orderNo = $("input#hiddenOrderNo").val();
	const hiddenPatientNo = $("input#hiddenPatientNo").val();
	console.log("디테이이일 : ", detailSymptom)
	
	if(confirm("정말 오더를 확정하시겠습니까?")){
	
		$.ajax({
				
			url:"<%= ctxPath%>/order/sendOrderConfirm",
			data:{"order_symptom_detail":detailSymptom
				  ,"orderNo":orderNo
				  ,"hiddenPatientNo":hiddenPatientNo},
			type:"post",	  
			dataType:"json",
			success:function(json){
			 console.log(JSON.stringify(json));
			 
			 	alert("오더가 확정되었습니다 !!")
			 	
			 	window.location.href = "<%= ctxPath%>/patient/patientWaiting";
				
			},
			error: function(request, status, error){
			    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		
		
		});
	}
	else{
		return
	}
	
	
};



</script>

<style type="text/css">

/* ========== full calendar css 시작 ========== */


a, a:hover, .fc-daygrid {
    color: #000;
    text-decoration: none;
    background-color: transparent;
    cursor: pointer;
} 

.fc-sat { color: #0000FF; }    /* 토요일 */
.fc-sun { color: #FF0000; }    /* 일요일 */



/* 주말 날짜 색 */
.fc-day-sun a {
  color: red;
  text-decoration: none;
}
.fc-day-sat a {
  color: blue;
  text-decoration: none;
}


.fc-button {
	font-size: 10pt !important;
	background-color: #4c4d4f !important;
	border: none !important; 
}

/* ========== full calendar css 끝 ========== */

ul{
	list-style: none;
}

button.btn_normal{
	background-color: #990000;
	border: none;
	color: white;
	width: 50px;
	height: 30px;
	font-size: 12pt;
	padding: 3px 0px;
	border-radius: 10%;
}

button.btn_edit{
	border: none;
	background-color: #fff;
}


#modalContainer {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContent {
  position: absolute;
  background-color: #ffffff;
  width: 900px;
  height: 450px;
  padding: 20px;
  border-radius: 20px;
}

#modalContainer.hidden {
  display: none;
}
#modalContainer {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContainer.hidden {
  display: none;
}


#modalContainer2 {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContent2 {
  position: absolute;
  background-color: #ffffff;
  width: 900px;
  height: 430px;
  padding: 20px;
  border-radius: 20px;
}

#modalContainer2.hidden {
  display: none;
}
#modalContainer2 {
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.5);
}

#modalContainer2.hidden {
  display: none;
}

/* 상단 타이틀 */
.header > div.title {
   border-left: 5px solid #006769;   
   padding-left: 1%;
   font-size: 20px;
   margin-bottom: 1%;
   color: #4c4d4f;
   font-weight: bold;
}


/* input 태그 */
input {
   /* background: #f0f0f0;  */
     color: #006769;
     border: none;
     border-bottom: 1px solid #999999; 
}

input:placeholder {
     color: rgba(255, 255, 255, 1);
     font-weight: 100;
}

input:focus {
     color: #006769;
     outline: none;
     border-bottom: 1.3px solid #006769; 
     transition: .8s all ease;
}

input:focus::placeholder {
     opacity: 0;
}



</style>


<div id="sub_mycontent">
<div class="header" style="margin: 0% 5%;">
	<div class="title" style="font-size:15pt;">진료정보 입력</div>
</div>

<div style="margin: 0% 5%;">	
	<span>${sessionScope.loginuser.member_name}&nbsp;님&nbsp;&nbsp;${sessionScope.loginuser.child_dept_name}&nbsp;&nbsp;${sessionScope.loginuser.member_position}</span>
	<span>
		<c:if test="${requestScope.orderCreate == 0 }">
			오더 생성되지 않음
		</c:if>
		<c:if test="${requestScope.orderCreate == 1 }">
			오더번호 : ${requestScope.newOrderNo }
		</c:if>
	</span>
</div>


	<div id="patient_info" style="margin: 1% 5%;">
		<table id="patient_info" class="table text-center table-bordered" style="margin:0.1%;"> <%-- width: 69.5%; position:fixed --%>
			<thead class="bg-light">
				<tr>
					<th >성함</th>
					<th >성별</th>
					<th >나이(만)</th>
					<th >내역</th>				
				</tr>
			</thead>
			<c:if test="${not empty requestScope.clickPatient}">
				<tbody style="">
					<tr>
						<td >${clickPatient.patient_name}</td>
						<td >${clickPatient.patient_gender}</td>
						<td >${clickPatient.age}세</td>
						<td >${clickPatient.jin}</td>						
					</tr>					
				</tbody>				
			</c:if>			
		</table>
	</div>
	
	
	
<form id="orderEnterFrm">
<div id="container" style="width:100%;" >	
	<div id="enterContainer" style="margin:0% 5%; border-radius:5px; border:solid 1px gray; height:700px; overflow-y:scroll;">		
			<div style="display:flex; justify-content:center; border:solid 0px gray;">
				<div style="border:solid 0px purple; margin:auto; width:33%; text-align:center">
					<span>진료내역</span>
				</div>
				<div style="border:solid 0px purple; margin:auto; width:33%; text-align:center">
					<span>증상</span>
				</div>
				<div style="border:solid 0px purple; margin:auto; width:33%; text-align:center">
					<span>캘린더</span>
				</div>
			</div>
			
			<div style="display:inline-block; width:100%;">
				<div style="margin: 0% 0.17%; float:left; border-radius:5px; border:solid 1px gray; width:33%; height:450px; overflow:auto;">					
					<c:if test="${not empty requestScope.orderList}">
						<c:forEach var="orderList" items="${requestScope.orderList}">
							<li style="list-style-type: none; margin: 5% 0%;">										
							<a href="#" class="menu-toggle"> 
								<span style="margin:5% 3% ;">${orderList.patient_name}</span> 
								<span>${orderList.order_createTime}&nbsp;&nbsp;${orderList.timediff}&nbsp;&nbsp;${orderList.child_dept_name}</span> <i class="fa-solid fa-chevron-down"></i>
							</a>
						         <div class="submenu">
						         	<a class="dropdown-item" href="">${orderList.order_symptom_detail}</a>
						            <a class="dropdown-item" href="">${orderList.order_desease_name}</a> 						            
						            <c:if test="${not empty orderList.order_surgeryType_name}">
						            	<a class="dropdown-item" href="">${orderList.order_surgeryType_name}</a>
						            </c:if>
						            <c:if test="${orderList.order_ishosp eq 1}">
						            	<a class="dropdown-item" href="">${orderList.order_howlonghosp}일 입원</a>
						            </c:if>
						         </div>
					         </li>
				         </c:forEach>
			         </c:if>
				</div>
				
				<div style="margin: 0% 0.17%; float:left; width:33%; height:385px;">
					<textarea id="readyToSymptomDetail" style="border-radius:5px; width: 100%; height:385px; padding:4% 4%; resize:none;">${clickPatient.patient_symptom}</textarea>	
				</div>
				
				<div style="margin: 0% 0.16%; border-radius:5px;border:solid 1px gray; float:right; width:33%; height:385px;">
					<div id="calendar" style=""></div>
					
					<div id="orderSurgDetail"style="margin: 5% 0%; border: solid 0px black; width:100%;">	
						<div style="display:flex;">					
							<select id="selectSurgery" style="height:30px; width: 80%; margin-bottom:0.5%;">
									<option value="">수술 종류</option>
								<c:forEach items="${requestScope.surgeryList}" var="surgeryList">						
									<option value="${surgeryList.surgeryType_name}" data-no="${surgeryList.surgeryType_no}">${surgeryList.surgeryType_name}&nbsp;&nbsp; <span style="color:red;">[수술번호 : ${surgeryList.surgeryType_no}]</span></option>
								</c:forEach>								
							</select>
							<button class="" id="surgeryConfirm" type="button" style="border:solid 0px black; border-radius:5px; width:20%; height: 30px; background-color: #b3d6d2; color:black;" > <!-- 수술전송버튼 -->
								<span id="confirmButton" style="margin-bottom:0.5%;">전송</span>
							</button>	
						</div>
						<div>											
							<input id="surgeryExplain"style="width:100%;"type="text" placeholder="수술 설명"/>
						</div>
					</div>
					
					<div id="orderHowLongHosp"style="margin: 6.2% 0%; border-radius:5px; border: solid 0px black; width:100%;">
						<div style=" margin: 5% 0 0 1%; height:25px;">
							입원 일수를 입력해 주세요
						</div>	
						<div style="display: flex">				
							<input type="number" id="howLongHosp"/>
							<button id="hospConfirm" type="button" style="border:solid 0px black; background-color:#b3d6d2; color:black; border-radius:5px; width:20%;" ><span id="confirmButton1">전송</span></button>	
						</div>
					</div>						
				</div>
				<div style="float:left; margin:0.4% 0% 0.1% 0.1% ; width:33%;">
					<div style="margin-bottom:0.2%;">
						<button type="button" style="border:solid 0px black; background-color: #b3d6d2; color:black; border-radius:5px; height: 30px; width:100%;" id="goSurgeryOrder">수술 지시</button>
					</div>
					<div>
						<button type="button" style="border:solid 0px black; background-color: #b3d6d2; color:black; border-radius:5px; height: 30px; width:100%;" id="goHospOrder">입원 지시</button>				
					</div>
				</div>
			</div>
			
			<div id="orderNpay" style=" border:solid 0px red; position:relative;">
			
				<div id="orderSearch" style="margin:1% 1%;">
					<span>질병 검색</span><input type="hidden" value="searchDeseaseType" name="searchDeseaseType"/>
					<input type="text" style="width: 585px; border: none; border-bottom: 1px solid black;"  name="searchDesease" id="searchDeseaseId" size="50" autocomplete="off" ></input>
					<input type="hidden" id="hiddenDeseaseName"/>
					<button type="button" class="" name="addDesease" style="background-color:#b3d6d2; color:black; width:50px; border:solid 0px black; border-radius:10px;"><i class="fa-solid fa-check"></i></button>&nbsp;&nbsp;&nbsp;<button type="button" id="submitDesease" style="border:solid 0px black; background-color:#b3d6d2; color:black; width:50px; border-radius:10px;">전송</button>
					<%--// === 질병 검색시 자동 완성하기 1 === // --%>	
					<div id="deseaseList" style="background-color:white; border:solid 1px gray; margin-left:5.5%; border-top:0px; height:100px;  position:absolute; z-index: 3; overflow:auto;"><!--  -->
					</div>
				</div>
			    								
				<div id="pickedDesease" style=""></div>
							
				
				<div id="medicineSearch" style="margin:1% 1%;">
					<span>약 검색</span><input type="hidden" value="searchMedicineType" name="searchMedicineType"/>
					<input type="text" style="width: 600px; border: none; border-bottom: 1px solid black;" name="searchMedicine" id="searchMedicineId" size="50" autocomplete="off" /> 
					<input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>
					<button type="button" class="" name="addMedicine" style="background-color:#b3d6d2; color:black; width:50px; border:solid 0px black; border-radius:10px;"><i class="fa-solid fa-check"></i></button>&nbsp;&nbsp;&nbsp;<button type="button" style="background-color:#b3d6d2; color:black; width:50px; border:solid 0px black; border-radius:10px;" id="medicineSubmit">전송</button>
					
					<%--// === 약 검색어 입력시 약 자동 완성하기 1 === // --%>					
				    <div id="medicineList" style="background-color:white; border:solid 1px gray; margin-left:4.35%; border-top:0px; height:100px;  overflow:auto;">
					</div>										
				</div>
					<div id="pickedMedicine" style=" border-radius:5px; border:solid 1px gray; height:170px; margin:0% 0.1%; position:relative; z-index:2; padding: 0.9% 0.9%; overflow:auto;"></div>
				
				
				<div id="pay" style="margin:1% 0.1%; border-radius:5px; border:solid 1px gray;">
				
					<span style="margin:1% 1%;">수납 내역</span>
					<button style="border:solid 0px black; background-color: #b3d6d2; color:black; border-radius:5px; float:right"type="button" onclick="sumPrice()">총 수납비용 보기</button>

					
					<table style="text-align:center; width:100%; border:solid 0px green;" >
						<tr>
							<td style="">기본진료</td>
							<td style="">5000원</td>
						</tr>
						
						<tr id="surgeryName">

						</tr>
						
						<tr id="hosp">

						</tr>
						<tr id="medicine">

						</tr>
						<tr id="sumPriceResult">

						</tr>																					
					
					</table>
					
										
				</div>
			</div>	
			
			<button style="border:solid 0px black; background-color: #b3d6d2; color:black; border-radius:5px; float:right" type="button" onclick="orderFinalConfirm()">오더 확정</button>
	</div> <%-- end of orderEnter --%>
	
</div>
</form>
 </div>



<!-- 숨겨진 인풋 -->
<input id="hiddenOrderNo"type="hidden" value="${requestScope.newOrderNo }"/>
<input id="hiddenPatientNo" type="hidden" value="${requestScope.clickPatient.patient_no}"/>




<!-- 수술지시 모달  모달 보류 @@@@@@@@@@@@@@@@@@
<div id="modalContainer" class="hidden" >
	<div id="modalContent">
	  <div style="border-radius:10px; font-size:15pt; text-align:center; margin: 1% 5%; background-color:#b3d6d2;"><span>수술 지시</span></div>
		<div style="">
			<form name="registerFrm">	
				<div style="margin:1% 5%;">						
						<div class="row justify-content-around mt-3">						
							<input type="button" class="btn btn-outline-success btn-lg col-2" value="원무과 제출" onclick="submitNcheck()" } />
							<input type="button" class="btn btn-outline-danger btn-lg col-2" value="작성 취소" id="regSurgeryModalClose" />												
						</div>		
				</div>		
			</form>		
		</div>	
	</div>
</div>
 -->
<!-- 입원지시 모달 
<div id="modalContainer2" class="hidden" >
	<div id="modalContent2">
	  <div style="border-radius:10px; font-size:15pt; text-align:center; margin: 1% 5%; background-color:#b3d6d2;"><span>입원지시</span></div>
		<div style="">
			<form name="registerFrm">	
				<div style="margin:1% 5%;">
						
						<div class="row justify-content-around mt-3">						
							<input type="button" class="btn btn-outline-success btn-lg col-3" value="원무과 제출" onclick="submitNcheck()" } />
							<input type="button" class="btn btn-outline-danger btn-lg col-3" value="작성 취소" id="regHospModalClose" />												
						</div>		
				</div>		
			</form>		
		</div>	
	</div>
</div>
-->














<jsp:include page="../../footer/footer1.jsp" /> 