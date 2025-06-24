package com.simjava.service.kbm;

import com.simjava.dto.kbm.TeachingActivityRequest;
import com.simjava.dto.kbm.TeachingActivityResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface TeachingActivityService {

    TeachingActivityResponse createTeachingActivity(TeachingActivityRequest request);

    Page<TeachingActivityResponse> getAllTeachingActivities(Pageable pageable);

    TeachingActivityResponse getTeachingActivityById(Long id);

    TeachingActivityResponse updateTeachingActivity(Long id, TeachingActivityRequest request);

    void deleteTeachingActivity(Long id);
}