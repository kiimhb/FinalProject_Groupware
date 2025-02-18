package com.spring.med.organization.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.spring.med.organization.domain.OrganVO;

@Mapper	
public interface OrganDAO {

	// ==== 조직도 배열을 만들기 위해 전체 데이터 불러오기 ==== //
	List<OrganVO> selectAllOrg();
		
	// ==== 조직도 상위 부서 불러오기 ==== //
	List<OrganVO> getparentDeptList();

	// ==== 조직도 하위 부서 불러오기 ==== //
	List<OrganVO> getchildDeptList(String fk_parent_dept_no);
	
	// ==== 조직도에서 클릭한 직원의 상세정보 불러오기 ==== //
	OrganVO selectOneMemberInfo(String member_userid);

}
