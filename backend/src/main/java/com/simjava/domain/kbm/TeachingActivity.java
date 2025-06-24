package com.simjava.domain.kbm;

import com.simjava.domain.BaseEntity;
import com.simjava.domain.security.User;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "teaching_activities")
public class TeachingActivity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "guru_id", nullable = false)
    private User guru;

    @Column(name = "mata_pelajaran", nullable = false)
    private String mataPelajaran;

    @Column(nullable = false)
    private LocalDate tanggal;

    @Column(name = "jam_mulai", nullable = false)
    private LocalTime jamMulai;

    @Column(name = "jam_selesai", nullable = false)
    private LocalTime jamSelesai;

    @Lob
    private String materi;

    @Column(name = "class_room_id", nullable = false)
    private Long classRoomId;
}