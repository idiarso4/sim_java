package com.simjava.service.kbm;

import com.simjava.domain.kbm.TeacherJournal;
import com.simjava.domain.kbm.TeachingActivity;
import com.simjava.domain.security.User;
import com.simjava.dto.kbm.TeacherJournalRequest;
import com.simjava.dto.kbm.TeacherJournalResponse;
import com.simjava.exception.ResourceNotFoundException;
import com.simjava.repository.UserRepository;
import com.simjava.repository.kbm.TeacherJournalRepository;
import com.simjava.repository.kbm.TeachingActivityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TeacherJournalServiceImpl implements TeacherJournalService {

    private final TeacherJournalRepository teacherJournalRepository;
    private final UserRepository userRepository;
    private final TeachingActivityRepository teachingActivityRepository;

    @Override
    public TeacherJournalResponse createJournal(TeacherJournalRequest request) {
        User teacher = userRepository.findById(request.getTeacherId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + request.getTeacherId()));

        TeachingActivity teachingActivity = null;
        if (request.getTeachingActivityId() != null) {
            teachingActivity = teachingActivityRepository.findById(request.getTeachingActivityId())
                    .orElseThrow(() -> new ResourceNotFoundException("TeachingActivity not found with id: " + request.getTeachingActivityId()));
        }

        TeacherJournal journal = new TeacherJournal();
        journal.setTeacher(teacher);
        journal.setTeachingActivity(teachingActivity);
        journal.setDate(request.getDate());
        journal.setContent(request.getContent());
        journal.setAttachmentUrl(request.getAttachmentUrl());

        TeacherJournal savedJournal = teacherJournalRepository.save(journal);
        return toResponse(savedJournal);
    }

    @Override
    public Page<TeacherJournalResponse> getJournalsByTeacher(Long teacherId, Pageable pageable) {
        if (!userRepository.existsById(teacherId)) {
            throw new ResourceNotFoundException("User not found with id: " + teacherId);
        }
        return teacherJournalRepository.findAll(pageable).map(this::toResponse);
    }

    private TeacherJournalResponse toResponse(TeacherJournal journal) {
        TeacherJournalResponse response = new TeacherJournalResponse();
        response.setId(journal.getId());
        response.setTeacherId(journal.getTeacher().getId());
        response.setTeacherName(journal.getTeacher().getName());
        if (journal.getTeachingActivity() != null) {
            response.setTeachingActivityId(journal.getTeachingActivity().getId());
        }
        response.setDate(journal.getDate());
        response.setContent(journal.getContent());
        response.setAttachmentUrl(journal.getAttachmentUrl());
        return response;
    }
}