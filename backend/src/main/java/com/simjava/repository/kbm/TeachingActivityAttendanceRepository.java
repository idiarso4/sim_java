package com.simjava.repository.kbm;

import com.simjava.domain.kbm.TeachingActivityAttendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TeachingActivityAttendanceRepository extends JpaRepository<TeachingActivityAttendance, Long> {
}