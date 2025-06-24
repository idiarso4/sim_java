package com.simjava.repository;

import com.simjava.domain.security.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    List<Attendance> findByStudentId(Long studentId);
    List<Attendance> findByStudentIdAndDateBetween(Long studentId, java.time.LocalDate startDate, java.time.LocalDate endDate);
    List<Attendance> findByDateAndStatus(java.time.LocalDate date, String status);
}
