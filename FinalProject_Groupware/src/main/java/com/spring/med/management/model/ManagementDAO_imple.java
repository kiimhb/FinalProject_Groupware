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
	
	//로그인 처리
	@Override
	public ManagementVO_ga getLoginMember(Map<String, String> paraMap) {

		ManagementVO_ga loginuser = sqlmanag.selectOne("management_ga.getLoginMember", paraMap);
		return loginuser;
		
	}

	//사원 전체조회
	@Override
	public List<ManagementVO_ga> Manag_List(Map<String, String> paraMap) {
		List<ManagementVO_ga> Manag_List = sqlmanag.selectList("management_ga.Manag_List", paraMap);
		return Manag_List;
	}
	
	// 총 사원수 구하기 --> 검색이 있을 때와 검색이 없을때 로 나뉜다.
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = sqlmanag.selectOne("management_ga.getTotalCount", paraMap);
		return totalCount;
	}

	// 검색어 입력시 자동글 완성하기
	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = sqlmanag.selectList("management_ga.wordSearchShow", paraMap);
		return wordList;
	}

	// 인사관리 사원수정 한명의 멤버 조회 
	@Override
	public ManagementVO_ga getView_member_one(Map<String, String> paraMap) {
		ManagementVO_ga member_one = sqlmanag.selectOne("management_ga.getView_member_one", paraMap);
		return member_one;
	}

	// 인사관리 사원퇴사
	@Override
	public int management_one_delete(String member_userid) {
		int n = sqlmanag.update("management_ga.management_one_delete", member_userid);
		return n;
	}

	// 인사관리 사원정보수정
	@Override
	public int Management_one_update(ManagementVO_ga managementVO_ga) {
		int n = sqlmanag.update("management_ga.Management_one_update", managementVO_ga);
		return n;
	}

	


}
