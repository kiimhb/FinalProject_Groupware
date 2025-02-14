package com.spring.med.management.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.med.management.domain.Child_deptVO_ga;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.management.domain.Parent_deptVO_ga;

import jakarta.annotation.Resource;

// === Repository(DAO) 선언 === //
@Repository
public class ManagementDAO_imple implements ManagementDAO {
	
	@Resource
	private SqlSessionTemplate sqlmanag;

	//상위부서 조회
	@Override
	public List<Parent_deptVO_ga> parentDeptList() {
		List<Parent_deptVO_ga> from_parentDeptList = sqlmanag.selectList("management_ga.parentDeptList");
		return from_parentDeptList;
	}
	
	//하위부서 조회
	@Override
	public List<Child_deptVO_ga> childDeptJSON(Map<String, Object> paraMap) {
		List<Child_deptVO_ga> childDeptJSON = sqlmanag.selectList("management_ga.childDeptJSON", paraMap);
		return childDeptJSON;
	}

	//사원등록 폼
	@Override
	public int manag_form(ManagementVO_ga managementVO_ga) {
		int n = sqlmanag.insert("management_ga.manag_form", managementVO_ga);
		return n;
	}

}
