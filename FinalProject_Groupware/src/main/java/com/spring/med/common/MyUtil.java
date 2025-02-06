package com.spring.med.common;

import jakarta.servlet.http.HttpServletRequest;

public class MyUtil {
	
		// *** ? 다음의 데이터까지 포함한 현재 URL 주소를 알려주는 메소드를 생성 *** //
		public static String getCurrentURL(HttpServletRequest request) { 
	      
			String currentURL = request.getRequestURL().toString();	  // URL 주소만 얻어오기
			// System.out.println("currentURL => " + currentURL);
			// currentURL => http://localhost:9090/MyMVC/member/memberList.up 
	      
			String queryString = request.getQueryString();			  // ? 다음의 주소 다음 얻어오기
			// System.out.println("queryString => " + queryString);
			// queryString => searchType=name&searchWord=%EC%9C%A0&sizePerPage=5&currentShowPageNo=15
			//                searchType=name&searchWord=유&sizePerPage=5&currentShowPageNo=15
			// queryString => null (POST 방식일 경우)
	      
			if(queryString != null) { // GET 방식일 경우
				currentURL += "?"+queryString;
				// currentURL => http://localhost:9090/MyMVC/member/memberList.up?searchType=name&searchWord=%EC%9C%A0&sizePerPage=5&currentShowPageNo=15
			}
	      
			String ctxPath = request.getContextPath();
			//     /MyMVC
	      
			int beginIndex = currentURL.indexOf(ctxPath) + ctxPath.length(); 
			//     27      =           21                +       6
	      
			currentURL = currentURL.substring(beginIndex);
			//   System.out.println("currentURL => " + currentURL); 
			//   currentURL => /member/memberList.up?searchType=name&searchWord=%EC%9C%A0&sizePerPage=5&currentShowPageNo=15
	      
			return currentURL;
	      
		}// end of public static String getCurrentURL(HttpServletRequest request)-----------
}
