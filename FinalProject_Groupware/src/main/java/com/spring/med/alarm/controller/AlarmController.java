package com.spring.med.alarm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.med.index.service.IndexService;
import com.spring.med.management.domain.ManagementVO_ga;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "*/alarm")
public class AlarmController {

	@Autowired
	private IndexService service;

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

		//List<Map<String, String>> get_alarm_view = service.get_alarm_view(member_userid);

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("alarm_totalCount", alarm_totalCount);

		return jsonObj.toString();
	}return "";}

}
