package com.simjava.dto.kbm;

import lombok.Data;

import java.time.LocalDate;

@Data
public class TeacherJournalResponse {

    private Long id;
    private Long teacherId;
    private String teacherName;
    private Long teachingActivityId;
    private LocalDate date;
    private String content;
    private String attachmentUrl;
}