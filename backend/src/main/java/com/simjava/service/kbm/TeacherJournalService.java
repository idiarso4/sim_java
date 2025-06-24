package com.simjava.service.kbm;

import com.simjava.dto.kbm.TeacherJournalRequest;
import com.simjava.dto.kbm.TeacherJournalResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface TeacherJournalService {

    TeacherJournalResponse createJournal(TeacherJournalRequest request);

    Page<TeacherJournalResponse> getJournalsByTeacher(Long teacherId, Pageable pageable);
}