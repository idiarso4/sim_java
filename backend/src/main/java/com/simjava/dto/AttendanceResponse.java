package com.simjava.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AttendanceResponse {
    private Long id;
    private Long studentId;
    private LocalDate date;
    private String status;
    private String timeIn;
    private String timeOut;
    private String notes;
    private String location;
    private String type;
}
