package com.simjava.dto.kbm;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class TeachingActivityResponse {

    private Long id;
    private Long guruId;
    private String guruName;
    private String mataPelajaran;
    private LocalDate tanggal;
    private LocalTime jamMulai;
    private LocalTime jamSelesai;
    private String materi;
    private Long classRoomId;
}