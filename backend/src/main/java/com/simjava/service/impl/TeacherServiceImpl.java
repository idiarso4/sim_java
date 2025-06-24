package com.simjava.service.impl;

import com.simjava.domain.security.Teacher;
import com.simjava.domain.security.User;
import com.simjava.dto.TeacherRequest;
import com.simjava.dto.TeacherResponse;
import com.simjava.dto.UserResponse;
import com.simjava.exception.ResourceNotFoundException;
import com.simjava.repository.TeacherRepository;
import com.simjava.repository.UserRepository;
import com.simjava.service.TeacherService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TeacherServiceImpl implements TeacherService {

    private final TeacherRepository teacherRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public TeacherResponse createTeacher(TeacherRequest request) {
        // Check if NIP already exists
        if (teacherRepository.existsByNip(request.getNip())) {
            throw new IllegalArgumentException("NIP already exists: " + request.getNip());
        }
        
        // Check if email already exists
        if (teacherRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email already exists: " + request.getEmail());
        }
        
        // Get user if userId is provided
        User user = null;
        if (request.getUserId() != null) {
            user = userRepository.findById(request.getUserId())
                    .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + request.getUserId()));
        }
        
        Teacher teacher = Teacher.builder()
                .nip(request.getNip())
                .namaLengkap(request.getNamaLengkap())
                .email(request.getEmail())
                .telp(request.getTelp())
                .jenisKelamin(request.getJenisKelamin())
                .tempatLahir(request.getTempatLahir())
                .tanggalLahir(request.getTanggalLahir())
                .alamat(request.getAlamat())
                .agama(request.getAgama())
                .pendidikanTerakhir(request.getPendidikanTerakhir())
                .jurusan(request.getJurusan())
                .tahunLulus(request.getTahunLulus())
                .statusKepegawaian(request.getStatusKepegawaian())
                .status(request.getStatus())
                .foto(request.getFoto())
                .user(user)
                .build();
        
        Teacher savedTeacher = teacherRepository.save(teacher);
        return mapToTeacherResponse(savedTeacher);
    }

    @Override
    public TeacherResponse getTeacherById(Long id) {
        Teacher teacher = teacherRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with id: " + id));
        return mapToTeacherResponse(teacher);
    }

    @Override
    public TeacherResponse getTeacherByNip(String nip) {
        Teacher teacher = teacherRepository.findByNip(nip)
                .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with NIP: " + nip));
        return mapToTeacherResponse(teacher);
    }

    @Override
    public TeacherResponse getTeacherByEmail(String email) {
        Teacher teacher = teacherRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with email: " + email));
        return mapToTeacherResponse(teacher);
    }

    @Override
    public Page<TeacherResponse> getAllTeachers(Pageable pageable, String search, String status) {
        Page<Teacher> teachers;
        
        if (search != null && !search.isEmpty() && status != null && !status.isEmpty()) {
            teachers = teacherRepository.findByNamaLengkapContainingIgnoreCaseAndStatus(search, status, pageable);
        } else if (search != null && !search.isEmpty()) {
            teachers = teacherRepository.findByNamaLengkapContainingIgnoreCase(search, pageable);
        } else if (status != null && !status.isEmpty()) {
            teachers = teacherRepository.findByStatus(status, pageable);
        } else {
            teachers = teacherRepository.findAll(pageable);
        }
        
        return teachers.map(this::mapToTeacherResponse);
    }

    @Override
    @Transactional
    public TeacherResponse updateTeacher(Long id, TeacherRequest request) {
        Teacher teacher = teacherRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with id: " + id));
        
        // Check if NIP already exists for another teacher
        if (!teacher.getNip().equals(request.getNip()) && teacherRepository.existsByNip(request.getNip())) {
            throw new IllegalArgumentException("NIP already exists: " + request.getNip());
        }
        
        // Check if email already exists for another teacher
        if (!teacher.getEmail().equals(request.getEmail()) && teacherRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email already exists: " + request.getEmail());
        }
        
        // Update user if userId is changed
        User user = null;
        if (request.getUserId() != null) {
            user = userRepository.findById(request.getUserId())
                    .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + request.getUserId()));
            teacher.setUser(user);
        }
        
        teacher.setNip(request.getNip());
        teacher.setNamaLengkap(request.getNamaLengkap());
        teacher.setEmail(request.getEmail());
        teacher.setTelp(request.getTelp());
        teacher.setJenisKelamin(request.getJenisKelamin());
        teacher.setTempatLahir(request.getTempatLahir());
        teacher.setTanggalLahir(request.getTanggalLahir());
        teacher.setAlamat(request.getAlamat());
        teacher.setAgama(request.getAgama());
        teacher.setPendidikanTerakhir(request.getPendidikanTerakhir());
        teacher.setJurusan(request.getJurusan());
        teacher.setTahunLulus(request.getTahunLulus());
        teacher.setStatusKepegawaian(request.getStatusKepegawaian());
        teacher.setStatus(request.getStatus());
        teacher.setFoto(request.getFoto());
        
        Teacher updatedTeacher = teacherRepository.save(teacher);
        return mapToTeacherResponse(updatedTeacher);
    }

    @Override
    @Transactional
    public void deleteTeacher(Long id) {
        if (!teacherRepository.existsById(id)) {
            throw new ResourceNotFoundException("Teacher not found with id: " + id);
        }
        teacherRepository.deleteById(id);
    }
    
    private TeacherResponse mapToTeacherResponse(Teacher teacher) {
        TeacherResponse.TeacherResponseBuilder builder = TeacherResponse.builder()
                .id(teacher.getId())
                .nip(teacher.getNip())
                .namaLengkap(teacher.getNamaLengkap())
                .email(teacher.getEmail())
                .telp(teacher.getTelp())
                .jenisKelamin(teacher.getJenisKelamin())
                .tempatLahir(teacher.getTempatLahir())
                .tanggalLahir(teacher.getTanggalLahir())
                .alamat(teacher.getAlamat())
                .agama(teacher.getAgama())
                .pendidikanTerakhir(teacher.getPendidikanTerakhir())
                .jurusan(teacher.getJurusan())
                .tahunLulus(teacher.getTahunLulus())
                .statusKepegawaian(teacher.getStatusKepegawaian())
                .status(teacher.getStatus())
                .foto(teacher.getFoto())
                .createdAt(teacher.getCreatedAt())
                .updatedAt(teacher.getUpdatedAt());
        
        // Map user if exists
        if (teacher.getUser() != null) {
            UserResponse userResponse = UserResponse.builder()
                    .id(teacher.getUser().getId())
                    .name(teacher.getUser().getName())
                    .email(teacher.getUser().getEmail())
                    .userType(teacher.getUser().getUserType())
                    .role(teacher.getUser().getRole())
                    .status(teacher.getUser().getStatus())
                    .build();
            builder.user(userResponse);
        }
        
        return builder.build();
    }
} 