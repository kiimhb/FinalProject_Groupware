package com.spring.med.memoscheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.med.memo.service.MemoService;

@Component
public class TrashCleanerScheduler {

	@Autowired
    private MemoService service;

    // 매일 자정 30일 이상 지난 휴지통 메모 자동 삭제
    @Scheduled(cron = "0 30 0 * * *")
    public void autoDeleteOldMemos() {
        int deletedCount = service.deleteOldTrashMemos();
        System.out.println("자동 삭제된 오래된 메모 개수: " + deletedCount);
    }
}
