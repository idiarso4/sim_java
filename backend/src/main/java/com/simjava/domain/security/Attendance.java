package com.simjava.domain.security;

import com.simjava.domain.BaseEntity;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Builder;

@Data
@Builder
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "attendances")
public class Attendance extends BaseEntity {
    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(nullable = false)
    private java.time.LocalDate date;

    @Column(nullable = false)
    private String status; // hadir, izin, sakit, alpa

    @Column(nullable = false)
    private String timeIn;

    private String timeOut;

    private String notes;

    @Column(nullable = false)
    private String location;

    @Column(nullable = false)
    private String type; // regular, prayer, etc.
}
