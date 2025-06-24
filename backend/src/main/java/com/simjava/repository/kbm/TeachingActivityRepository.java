package com.simjava.repository.kbm;

import com.simjava.domain.kbm.TeachingActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TeachingActivityRepository extends JpaRepository<TeachingActivity, Long> {
}