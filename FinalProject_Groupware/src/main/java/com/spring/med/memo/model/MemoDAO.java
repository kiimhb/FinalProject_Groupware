package com.spring.med.memo.model;

import java.util.List;

import com.spring.med.memo.domain.MemoVO;

public interface MemoDAO {

	List<MemoVO> selectAllMemo();

}
