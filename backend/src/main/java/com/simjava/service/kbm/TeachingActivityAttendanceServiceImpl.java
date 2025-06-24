package com.simjava.service.kbm;

import com.simjava.domain.kbm.TeachingActivity;
import com.simjava.domain.kbm.TeachingActivityAttendance;
import com.simjava.domain.security.Student;
import com.simjava.dto.kbm.TeachingActivityAttendanceRequest;
import com.simjava.dto.kbm.TeachingActivityAttendanceResponse;
import com.simjava.exception.ResourceNotFoundException;
import com.simjava.repository.StudentRepository;
import com.simjava.repository.kbm.TeachingActivityAttendanceRepository;
import com.simjava.repository.kbm.TeachingActivityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TeachingActivityAttendanceServiceImpl implements TeachingActivityAttendanceService {

    private final TeachingActivityAttendanceRepository attendanceRepository;
    private final TeachingActivityRepository teachingActivityRepository;
    private final StudentRepository studentRepository;

    @Override
    public TeachingActivityAttendanceResponse recordAttendance(TeachingActivityAttendanceRequest request) {
        TeachingActivity teachingActivity = teachingActivityRepository.findById(request.getTeachingActivityId())
                .orElseThrow(() -> new ResourceNotFoundException("TeachingActivity not found with id: " + request.getTeachingActivityId()));

        Student student = studentRepository.findById(request.getStudentId())
                .orElseThrow(() -> new ResourceNotFoundException("Student not found with id: " + request.getStudentId()));

        TeachingActivityAttendance attendance = new TeachingActivityAttendance();
        attendance.setTeachingActivity(teachingActivity);
        attendance.setStudent(student);
        attendance.setStatus(request.getStatus());
        attendance.setDescription(request.getDescription());

        TeachingActivityAttendance savedAttendance = attendanceRepository.save(attendance);
        return toResponse(savedAttendance);
    }

    private TeachingActivityAttendanceResponse toResponse(TeachingActivityAttendance attendance) {
        TeachingActivityAttendanceResponse response = new TeachingActivityAttendanceResponse();
        response.setId(attendance.getId());
        response.setTeachingActivityId(attendance.getTeachingActivity().getId());
        response.setStudentId(attendance.getStudent().getId());
        response.setStudentName(attendance.getStudent().getNamaLengkap());
        response.setStatus(attendance.getStatus());
        response.setDescription(attendance.getDescription());
        return response;
    }
}