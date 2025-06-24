package com.simjava.dto.kbm;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class TeachingActivityAttendanceRequest {

    @NotNull(message = "Teaching Activity ID tidak boleh kosong")
    private Long teachingActivityId;

    @NotNull(message = "Student ID tidak boleh kosong")
    private Long studentId;

    @NotBlank(message = "Status tidak boleh kosong")
    private String status;

    private String description;
}