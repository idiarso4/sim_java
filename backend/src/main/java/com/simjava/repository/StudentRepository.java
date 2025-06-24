package com.simjava.repository;

import com.simjava.domain.security.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByNis(String nis);
    Optional<Student> findByEmail(String email);
    boolean existsByNis(String nis);
    boolean existsByEmail(String email);
}
