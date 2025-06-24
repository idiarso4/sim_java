package com.simjava.service;

import com.simjava.domain.security.Attendance;
import com.simjava.domain.security.Student;
import com.simjava.dto.AttendanceRequest;
import com.simjava.dto.AttendanceResponse;
import com.simjava.exception.ResourceNotFoundException;
import com.simjava.repository.AttendanceRepository;
import com.simjava.repository.StudentRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class AttendanceService {

    private final AttendanceRepository attendanceRepository;
    private final StudentRepository studentRepository;

    public AttendanceResponse createAttendance(AttendanceRequest request) {
        Student student = studentRepository.findById(request.getStudentId())
                .orElseThrow(() -> new ResourceNotFoundException("Student not found"));

        Attendance attendance = Attendance.builder()
                .student(student)
                .date(request.getDate())
                .status(request.getStatus())
                .timeIn(request.getTimeIn())
                .timeOut(request.getTimeOut())
                .notes(request.getNotes())
                .location(request.getLocation())
                .type(request.getType())
                .build();

        Attendance savedAttendance = attendanceRepository.save(attendance);
        return mapToResponse(savedAttendance);
    }

    public AttendanceResponse getAttendanceById(Long id) {
        Attendance attendance = attendanceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Attendance not found"));
        return mapToResponse(attendance);
    }

    public List<AttendanceResponse> getAttendancesByStudent(Long studentId) {
        return attendanceRepository.findByStudentId(studentId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public List<AttendanceResponse> getAttendancesByDateRange(
            Long studentId,
            LocalDate startDate,
            LocalDate endDate) {
        return attendanceRepository.findByStudentIdAndDateBetween(studentId, startDate, endDate)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public List<AttendanceResponse> getAttendancesByStatus(LocalDate date, String status) {
        return attendanceRepository.findByDateAndStatus(date, status)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    private AttendanceResponse mapToResponse(Attendance attendance) {
        return AttendanceResponse.builder()
                .id(attendance.getId())
                .studentId(attendance.getStudent().getId())
                .date(attendance.getDate())
                .status(attendance.getStatus())
                .timeIn(attendance.getTimeIn())
                .timeOut(attendance.getTimeOut())
                .notes(attendance.getNotes())
                .location(attendance.getLocation())
                .type(attendance.getType())
                .build();
    }
}
