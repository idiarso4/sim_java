package com.simjava.controller;

import com.simjava.dto.ApiResponse;
import com.simjava.dto.TeacherRequest;
import com.simjava.dto.TeacherResponse;
import com.simjava.service.TeacherService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/teachers")
@RequiredArgsConstructor
public class TeacherController {

    private final TeacherService teacherService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TeacherResponse>> createTeacher(@Valid @RequestBody TeacherRequest request) {
        TeacherResponse createdTeacher = teacherService.createTeacher(request);
        return new ResponseEntity<>(ApiResponse.success("Teacher created successfully", createdTeacher), HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<ApiResponse<Page<TeacherResponse>>> getAllTeachers(
            @PageableDefault(size = 10, sort = "namaLengkap") Pageable pageable,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String status) {
        Page<TeacherResponse> teachers = teacherService.getAllTeachers(pageable, search, status);
        return ResponseEntity.ok(ApiResponse.success(teachers));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TeacherResponse>> getTeacherById(@PathVariable Long id) {
        TeacherResponse teacher = teacherService.getTeacherById(id);
        return ResponseEntity.ok(ApiResponse.success(teacher));
    }

    @GetMapping("/nip/{nip}")
    public ResponseEntity<ApiResponse<TeacherResponse>> getTeacherByNip(@PathVariable String nip) {
        TeacherResponse teacher = teacherService.getTeacherByNip(nip);
        return ResponseEntity.ok(ApiResponse.success(teacher));
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<ApiResponse<TeacherResponse>> getTeacherByEmail(@PathVariable String email) {
        TeacherResponse teacher = teacherService.getTeacherByEmail(email);
        return ResponseEntity.ok(ApiResponse.success(teacher));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TeacherResponse>> updateTeacher(@PathVariable Long id, @Valid @RequestBody TeacherRequest request) {
        TeacherResponse updatedTeacher = teacherService.updateTeacher(id, request);
        return ResponseEntity.ok(ApiResponse.success("Teacher updated successfully", updatedTeacher));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> deleteTeacher(@PathVariable Long id) {
        teacherService.deleteTeacher(id);
        return ResponseEntity.ok(ApiResponse.success("Teacher deleted successfully", null));
    }
} 