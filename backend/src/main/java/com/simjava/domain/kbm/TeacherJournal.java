package com.simjava.domain.kbm;

import com.simjava.domain.BaseEntity;
import com.simjava.domain.security.User;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "teacher_journals")
public class TeacherJournal extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id", nullable = false)
    private User teacher;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teaching_activity_id")
    private TeachingActivity teachingActivity;

    @Column(nullable = false)
    private LocalDate date;

    @Lob
    @Column(nullable = false)
    private String content;

    private String attachmentUrl;
}