package com.spring.med.memo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.med.memo.domain.MemoVO;
import com.spring.med.memo.model.MemoDAO;

@Service
public class MemoService_imple implements MemoService  {

	@Autowired
    private MemoDAO dao;

    @Override
    public List<MemoVO> getMemoList() {
        return dao.selectAllMemo();
    }
}