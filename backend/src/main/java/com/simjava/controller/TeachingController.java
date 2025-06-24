package com.simjava.controller;

import com.simjava.dto.kbm.*;
import com.simjava.service.kbm.TeacherJournalService;
import com.simjava.service.kbm.TeachingActivityAttendanceService;
import com.simjava.service.kbm.TeachingActivityService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/teaching")
@RequiredArgsConstructor
public class TeachingController {

    private final TeachingActivityService teachingActivityService;
    private final TeachingActivityAttendanceService attendanceService;
    private final TeacherJournalService teacherJournalService;

    // Teaching Activities Endpoints
    @PostMapping("/activities")
    public ResponseEntity<TeachingActivityResponse> createTeachingActivity(@Valid @RequestBody TeachingActivityRequest request) {
        return new ResponseEntity<>(teachingActivityService.createTeachingActivity(request), HttpStatus.CREATED);
    }

    @GetMapping("/activities")
    public Page<TeachingActivityResponse> getAllTeachingActivities(Pageable pageable) {
        return teachingActivityService.getAllTeachingActivities(pageable);
    }

    @GetMapping("/activities/{id}")
    public ResponseEntity<TeachingActivityResponse> getTeachingActivityById(@PathVariable Long id) {
        return ResponseEntity.ok(teachingActivityService.getTeachingActivityById(id));
    }

    @PutMapping("/activities/{id}")
    public ResponseEntity<TeachingActivityResponse> updateTeachingActivity(@PathVariable Long id, @Valid @RequestBody TeachingActivityRequest request) {
        return ResponseEntity.ok(teachingActivityService.updateTeachingActivity(id, request));
    }

    @DeleteMapping("/activities/{id}")
    public ResponseEntity<Void> deleteTeachingActivity(@PathVariable Long id) {
        teachingActivityService.deleteTeachingActivity(id);
        return ResponseEntity.noContent().build();
    }

    // Teaching Attendance Endpoint
    @PostMapping("/attendance")
    public ResponseEntity<TeachingActivityAttendanceResponse> recordAttendance(@Valid @RequestBody TeachingActivityAttendanceRequest request) {
        return new ResponseEntity<>(attendanceService.recordAttendance(request), HttpStatus.CREATED);
    }

    // Teacher Journal Endpoints
    @PostMapping("/journals")
    public ResponseEntity<TeacherJournalResponse> createTeacherJournal(@Valid @RequestBody TeacherJournalRequest request) {
        return new ResponseEntity<>(teacherJournalService.createJournal(request), HttpStatus.CREATED);
    }

    @GetMapping("/journals")
    public Page<TeacherJournalResponse> getTeacherJournals(@RequestParam Long teacherId, Pageable pageable) {
        return teacherJournalService.getJournalsByTeacher(teacherId, pageable);
    }
}