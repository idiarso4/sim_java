package com.simjava.domain.kbm;

import com.simjava.domain.BaseEntity;
import com.simjava.domain.security.Student;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "teaching_activity_attendances")
public class TeachingActivityAttendance extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teaching_activity_id", nullable = false)
    private TeachingActivity teachingActivity;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(nullable = false)
    private String status; // Hadir, Sakit, Izin, Alpha

    private String description;
}