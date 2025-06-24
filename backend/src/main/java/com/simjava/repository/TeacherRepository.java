package com.simjava.repository;

import com.simjava.domain.security.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TeacherRepository extends JpaRepository<Teacher, Long> {
    Optional<Teacher> findByNip(String nip);
    Optional<Teacher> findByEmail(String email);
    Optional<Teacher> findByUserId(Long userId);
    
    boolean existsByNip(String nip);
    boolean existsByEmail(String email);
    
    Page<Teacher> findByNamaLengkapContainingIgnoreCase(String name, Pageable pageable);
    Page<Teacher> findByStatus(String status, Pageable pageable);
    Page<Teacher> findByNamaLengkapContainingIgnoreCaseAndStatus(String name, String status, Pageable pageable);
} 