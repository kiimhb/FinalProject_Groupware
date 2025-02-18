package com.spring.med.organization.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.organization.domain.OrganVO;
import com.spring.med.organization.model.OrganDAO;

@Service
public class OrganService_imple implements OrganService {

	@Autowired
	private OrganDAO mapper_organDAO;
	
	
	
	// ==== 조직도 배열을 만들기 위해 전체 데이터 불러오기 ==== //
	@Override
	public List<OrganVO> selectAllOrg() {
		List<OrganVO> allOrgList = mapper_organDAO.selectAllOrg();
		return allOrgList;
	}

	
	// ==== 조직도 상위 부서 불러오기 ==== //
	@Override
	public List<OrganVO> getparentDeptList() {
		List<OrganVO> parentDeptList = mapper_organDAO.getparentDeptList();
		return parentDeptList;
	}


	// ==== 조직도 하위 부서 불러오기 ==== //
	@Override
	public List<OrganVO> getchildDeptList(String fk_parent_dept_no) {
		List<OrganVO> childDeptList = mapper_organDAO.getchildDeptList(fk_parent_dept_no);
		return childDeptList;
	}


	// ==== 조직도에서 클릭한 직원의 상세정보 불러오기 ==== //
	@Override
	public OrganVO selectOneMemberInfo(String member_userid) {
		OrganVO organMemInfo = mapper_organDAO.selectOneMemberInfo(member_userid);
		return organMemInfo;
	}


}
