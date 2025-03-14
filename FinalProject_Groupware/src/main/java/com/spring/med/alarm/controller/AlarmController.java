package com.spring.med.alarm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.approval.service.ApprovalService;
import com.spring.med.index.service.IndexService;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/alarm")
public class AlarmController {

	@Autowired
	private IndexService service;
	
	@Autowired
	private ApprovalService approvalService;

//	알람 가져오기
	@GetMapping(value = "alarm")
	@ResponseBody
	public String alarm(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		ManagementVO_ga loginuser = (ManagementVO_ga) session.getAttribute("loginuser");
		if (loginuser != null) {
		String member_userid = loginuser.getMember_userid();
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("member_userid", member_userid);

		int alarm_totalCount = 0;
		alarm_totalCount = service.get_alarm_totalCount(paraMap);

		List<Map<String, String>> get_alarm_view = service.get_alarm_view(member_userid);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("alarm_totalCount", alarm_totalCount);
		jsonObj.put("get_alarm_view", get_alarm_view);
	
		return jsonObj.toString();
	}return "";}
	
//	알람 업데이트
	@PostMapping(value = "alarm_is_read_1")
	@ResponseBody
	public String alarm_is_read_1(HttpServletRequest request, HttpServletResponse response, @RequestParam("") int alarm_no) {
		
//		System.out.println(alarm_no);
		
		int n =  service.alarm_is_read_1(alarm_no);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		return jsonObj.toString();
	}
	
   // ==== 결재문서함에서 문서 클릭 후 해당 문서 내용을 불러오기 ==== //
   @PostMapping("approvalPendingListDetail_tbl_alarm")
   public ModelAndView approvalPendingListDetail_tbl_alarm(ModelAndView mav, HttpServletRequest request, @RequestParam String draft_no) {

      // >>> 작성자(로그인된 유저) 정보 전달 <<< //
      HttpSession session = request.getSession();
      ManagementVO_ga loginuser = (ManagementVO_ga)session.getAttribute("loginuser");
      String member_userid = loginuser.getMember_userid();
      
      Map<String,String> map = new HashMap<>();
      map.put("member_userid", member_userid);
      map.put("draft_no", draft_no);
      
      HashMap<String, String> approvalvo = approvalService.approvalPendingListDetail(map);
      mav.addObject("approvalvo", approvalvo);
      mav.setViewName("/content/approval/approvalDraft");
      
      return mav;
   }
	
	

}
