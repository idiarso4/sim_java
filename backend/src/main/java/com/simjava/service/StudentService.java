package com.simjava.service;

import com.simjava.domain.security.Student;
import com.simjava.dto.StudentRequest;
import com.simjava.dto.StudentResponse;
import com.simjava.exception.ResourceNotFoundException;
import com.simjava.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StudentService {

    private final StudentRepository studentRepository;

    @Transactional(readOnly = true)
    public List<StudentResponse> getAllStudents() {
        return studentRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public StudentResponse createStudent(StudentRequest studentRequest) {
        Student student = Student.builder()
                .nis(studentRequest.getNis())
                .namaLengkap(studentRequest.getNamaLengkap())
                .email(studentRequest.getEmail())
                .telp(studentRequest.getTelp())
                .jenisKelamin(studentRequest.getJenisKelamin().charAt(0))
                .agama(studentRequest.getAgama())
                .classRoomId(studentRequest.getClassRoomId())
                .userId(studentRequest.getUserId())
                .build();
        
        Student savedStudent = studentRepository.save(student);
        return mapToResponse(savedStudent);
    }

    @Transactional(readOnly = true)
    public StudentResponse getStudentById(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
        
        return mapToResponse(student);
    }

    @Transactional(readOnly = true)
    public StudentResponse getStudentByNis(String nis) {
        Student student = studentRepository.findByNis(nis)
                .orElseThrow(() -> new ResourceNotFoundException("Student", "nis", nis));
        
        return mapToResponse(student);
    }

    @Transactional
    public StudentResponse updateStudent(Long id, StudentRequest studentRequest) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
        
        // Update fields
        student.setNis(studentRequest.getNis());
        student.setNamaLengkap(studentRequest.getNamaLengkap());
        student.setEmail(studentRequest.getEmail());
        student.setTelp(studentRequest.getTelp());
        student.setJenisKelamin(studentRequest.getJenisKelamin().charAt(0));
        student.setAgama(studentRequest.getAgama());
        student.setClassRoomId(studentRequest.getClassRoomId());
        student.setUserId(studentRequest.getUserId());
        
        Student updatedStudent = studentRepository.save(student);
        return mapToResponse(updatedStudent);
    }

    @Transactional
    public void deleteStudent(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
        
        studentRepository.delete(student);
    }

    private StudentResponse mapToResponse(Student student) {
        return StudentResponse.builder()
                .id(student.getId())
                .nis(student.getNis())
                .namaLengkap(student.getNamaLengkap())
                .email(student.getEmail())
                .telp(student.getTelp())
                .jenisKelamin(student.getJenisKelamin())
                .agama(student.getAgama())
                .classRoomId(student.getClassRoomId())
                .userId(student.getUserId())
                .createdAt(student.getCreatedAt())
                .updatedAt(student.getUpdatedAt())
                .build();
    }
}
