package com.simjava.dto.kbm;

import lombok.Data;

@Data
public class TeachingActivityAttendanceResponse {

    private Long id;
    private Long teachingActivityId;
    private Long studentId;
    private String studentName;
    private String status;
    private String description;
}