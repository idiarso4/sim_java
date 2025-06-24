package com.simjava.service.kbm;

import com.simjava.domain.kbm.TeachingActivity;
import com.simjava.domain.security.User;
import com.simjava.dto.kbm.TeachingActivityRequest;
import com.simjava.dto.kbm.TeachingActivityResponse;
import com.simjava.exception.ResourceNotFoundException;
import com.simjava.repository.UserRepository;
import com.simjava.repository.kbm.TeachingActivityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TeachingActivityServiceImpl implements TeachingActivityService {

    private final TeachingActivityRepository teachingActivityRepository;
    private final UserRepository userRepository;

    @Override
    public TeachingActivityResponse createTeachingActivity(TeachingActivityRequest request) {
        User guru = userRepository.findById(request.getGuruId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + request.getGuruId()));

        TeachingActivity teachingActivity = new TeachingActivity();
        teachingActivity.setGuru(guru);
        teachingActivity.setMataPelajaran(request.getMataPelajaran());
        teachingActivity.setTanggal(request.getTanggal());
        teachingActivity.setJamMulai(request.getJamMulai());
        teachingActivity.setJamSelesai(request.getJamSelesai());
        teachingActivity.setMateri(request.getMateri());
        teachingActivity.setClassRoomId(request.getClassRoomId());

        TeachingActivity savedActivity = teachingActivityRepository.save(teachingActivity);
        return toResponse(savedActivity);
    }

    @Override
    public Page<TeachingActivityResponse> getAllTeachingActivities(Pageable pageable) {
        return teachingActivityRepository.findAll(pageable).map(this::toResponse);
    }

    @Override
    public TeachingActivityResponse getTeachingActivityById(Long id) {
        TeachingActivity teachingActivity = teachingActivityRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("TeachingActivity not found with id: " + id));
        return toResponse(teachingActivity);
    }

    @Override
    public TeachingActivityResponse updateTeachingActivity(Long id, TeachingActivityRequest request) {
        TeachingActivity teachingActivity = teachingActivityRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("TeachingActivity not found with id: " + id));

        User guru = userRepository.findById(request.getGuruId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + request.getGuruId()));

        teachingActivity.setGuru(guru);
        teachingActivity.setMataPelajaran(request.getMataPelajaran());
        teachingActivity.setTanggal(request.getTanggal());
        teachingActivity.setJamMulai(request.getJamMulai());
        teachingActivity.setJamSelesai(request.getJamSelesai());
        teachingActivity.setMateri(request.getMateri());
        teachingActivity.setClassRoomId(request.getClassRoomId());

        TeachingActivity updatedActivity = teachingActivityRepository.save(teachingActivity);
        return toResponse(updatedActivity);
    }

    @Override
    public void deleteTeachingActivity(Long id) {
        if (!teachingActivityRepository.existsById(id)) {
            throw new ResourceNotFoundException("TeachingActivity not found with id: " + id);
        }
        teachingActivityRepository.deleteById(id);
    }

    private TeachingActivityResponse toResponse(TeachingActivity teachingActivity) {
        TeachingActivityResponse response = new TeachingActivityResponse();
        response.setId(teachingActivity.getId());
        response.setGuruId(teachingActivity.getGuru().getId());
        response.setGuruName(teachingActivity.getGuru().getName());
        response.setMataPelajaran(teachingActivity.getMataPelajaran());
        response.setTanggal(teachingActivity.getTanggal());
        response.setJamMulai(teachingActivity.getJamMulai());
        response.setJamSelesai(teachingActivity.getJamSelesai());
        response.setMateri(teachingActivity.getMateri());
        response.setClassRoomId(teachingActivity.getClassRoomId());
        return response;
    }
}