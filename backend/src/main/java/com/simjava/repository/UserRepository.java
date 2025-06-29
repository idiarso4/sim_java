package com.simjava.repository;

import com.simjava.domain.security.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);

    Page<User> findByNameContainingIgnoreCase(String name, Pageable pageable);

    Page<User> findByUserType(String userType, Pageable pageable);

    Page<User> findByNameContainingIgnoreCaseAndUserType(String name, String userType, Pageable pageable);
}
