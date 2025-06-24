package com.simjava.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AttendanceRequest {
    @NotNull(message = "Student ID is required")
    private Long studentId;

    @NotNull(message = "Date is required")
    private LocalDate date;

    @NotBlank(message = "Status is required")
    private String status;

    @NotBlank(message = "Time in is required")
    private String timeIn;

    private String timeOut;

    private String notes;

    @NotBlank(message = "Location is required")
    private String location;

    @NotBlank(message = "Type is required")
    private String type;
}
