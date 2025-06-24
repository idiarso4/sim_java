package com.simjava.service.kbm;

import com.simjava.dto.kbm.TeachingActivityAttendanceRequest;
import com.simjava.dto.kbm.TeachingActivityAttendanceResponse;

public interface TeachingActivityAttendanceService {

    TeachingActivityAttendanceResponse recordAttendance(TeachingActivityAttendanceRequest request);
}