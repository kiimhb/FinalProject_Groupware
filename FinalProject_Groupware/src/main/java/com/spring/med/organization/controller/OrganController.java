package com.spring.med.organization.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.med.organization.domain.OrganVO;
import com.spring.med.organization.service.OrganService;

//**** 조직도 컨트롤러 **** //

@Controller
@RequestMapping(value="/organization/*")
public class OrganController {
	
	@Autowired
	private OrganService organService;
	
	
	// ==== 조직도 페이지 요청 ==== //
	@GetMapping("orgChart")
	public ModelAndView writeDraftForm(ModelAndView mav) {
		mav.setViewName("/content/organization/orgChart");
		
		return mav;
	}
	
	
	// ==== 조직도 배열을 만들기 위해 전체 데이터 불러오기 ==== //
	@GetMapping("selectAllOrg")
	@ResponseBody
	public List<OrganVO> selectAllOrg() {
		List<OrganVO> allOrgList = organService.selectAllOrg();
		return allOrgList;
	}

	
	// ==== 조직도 상위 부서 불러오기 ==== //
	@GetMapping("getparentDeptList")
	@ResponseBody
	public List<OrganVO> getparentDeptList() {
		List<OrganVO> parentDeptList = organService.getparentDeptList();
		return parentDeptList;
	}
	
	
	// ==== 조직도 하위 부서 불러오기 ==== //
	@GetMapping("getchildDeptList")
	@ResponseBody
	public List<OrganVO> getchildDeptList(@RequestParam String fk_parent_dept_no) {
		List<OrganVO> childDeptList = organService.getchildDeptList(fk_parent_dept_no);
		return childDeptList;
	}
	
	
	// ==== 조직도에서 클릭한 직원의 상세정보 불러오기 ==== //
	@PostMapping("selectOneMemberInfo")
	@ResponseBody
	public OrganVO selectOneMemberInfo(@RequestParam String member_userid) {
		
		OrganVO organMemInfo = organService.selectOneMemberInfo(member_userid);
		
		return organMemInfo;
	}
	
	
	// ==== 기안문 작성/수정에서 결재선 지정 버튼 클릭시 모달 내에 띄울 조직도 불러오기 ==== //
	@GetMapping("selectApprovalLine")
	public ModelAndView selectApprovalLine(ModelAndView mav) {
		mav.setViewName("/content/organization/selectApprovalLine");
		
		return mav;
	}
	
	
} 
