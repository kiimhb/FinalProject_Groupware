package com.spring.med.management.model;

import java.util.List;
import java.util.Map;

import com.spring.med.management.domain.Child_deptVO_ga;
import com.spring.med.management.domain.ManagementVO_ga;
import com.spring.med.management.domain.Parent_deptVO_ga;

public interface ManagementDAO {

	//상위부서 조회
	List<Parent_deptVO_ga> parentDeptList();

	//하위부서 조회
	List<Child_deptVO_ga> childDeptJSON(Map<String, Object> paraMap);

	//사원등록 폼
	int manag_form(ManagementVO_ga managementVO_ga);

}
