package com.simjava.controller;

import com.simjava.dto.AttendanceRequest;
import com.simjava.dto.AttendanceResponse;
import com.simjava.service.AttendanceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/attendance")
@RequiredArgsConstructor
public class AttendanceController {

    private final AttendanceService attendanceService;

    @PostMapping
    public ResponseEntity<AttendanceResponse> createAttendance(@Valid @RequestBody AttendanceRequest request) {
        AttendanceResponse response = attendanceService.createAttendance(request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<AttendanceResponse> getAttendanceById(@PathVariable Long id) {
        AttendanceResponse response = attendanceService.getAttendanceById(id);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<AttendanceResponse>> getAttendancesByStudent(@PathVariable Long studentId) {
        List<AttendanceResponse> responses = attendanceService.getAttendancesByStudent(studentId);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/date-range")
    public ResponseEntity<List<AttendanceResponse>> getAttendancesByDateRange(
            @RequestParam Long studentId,
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate) {
        List<AttendanceResponse> responses = attendanceService.getAttendancesByDateRange(studentId, startDate, endDate);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/status")
    public ResponseEntity<List<AttendanceResponse>> getAttendancesByStatus(
            @RequestParam LocalDate date,
            @RequestParam String status) {
        List<AttendanceResponse> responses = attendanceService.getAttendancesByStatus(date, status);
        return ResponseEntity.ok(responses);
    }
}
