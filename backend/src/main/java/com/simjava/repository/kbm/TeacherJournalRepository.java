package com.simjava.repository.kbm;

import com.simjava.domain.kbm.TeacherJournal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TeacherJournalRepository extends JpaRepository<TeacherJournal, Long> {
}