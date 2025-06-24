package com.simjava.service;

import com.simjava.dto.TeacherRequest;
import com.simjava.dto.TeacherResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface TeacherService {
    TeacherResponse createTeacher(TeacherRequest request);
    TeacherResponse getTeacherById(Long id);
    TeacherResponse getTeacherByNip(String nip);
    TeacherResponse getTeacherByEmail(String email);
    Page<TeacherResponse> getAllTeachers(Pageable pageable, String search, String status);
    TeacherResponse updateTeacher(Long id, TeacherRequest request);
    void deleteTeacher(Long id);
} 