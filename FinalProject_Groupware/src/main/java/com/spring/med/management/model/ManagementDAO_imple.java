package com.spring.med.management.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.med.management.domain.Child_deptVO;
import com.spring.med.management.domain.Parent_deptVO;

import jakarta.annotation.Resource;

// === Repository(DAO) 선언 === //
@Repository
public class ManagementDAO_imple implements ManagementDAO {
	
	@Resource
	private SqlSessionTemplate sqlsession;

	@Override
	public List<Parent_deptVO> parentDeptList() {
		List<Parent_deptVO> from_parentDeptList = sqlsession.selectList("management_ga.parentDeptList");
		return from_parentDeptList;
	}

	@Override
	public List<Child_deptVO> childDeptList() {
		List<Child_deptVO> from_childDeptList = sqlsession.selectList("management_ga.childDeptList");
		return from_childDeptList;
	}

}
