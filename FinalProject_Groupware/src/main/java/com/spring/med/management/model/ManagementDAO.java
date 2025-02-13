package com.spring.med.management.model;

import java.util.List;
import java.util.Map;

import com.spring.med.management.domain.Child_deptVO;
import com.spring.med.management.domain.Parent_deptVO;

public interface ManagementDAO {

	List<Parent_deptVO> parentDeptList();

	List<Child_deptVO> childDeptJSON(Map<String, Object> paraMap);

}
