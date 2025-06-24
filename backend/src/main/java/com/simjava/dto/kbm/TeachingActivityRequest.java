package com.simjava.dto.kbm;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class TeachingActivityRequest {

    @NotNull(message = "Guru ID tidak boleh kosong")
    private Long guruId;

    @NotBlank(message = "Mata pelajaran tidak boleh kosong")
    private String mataPelajaran;

    @NotNull(message = "Tanggal tidak boleh kosong")
    @FutureOrPresent(message = "Tanggal tidak boleh di masa lalu")
    private LocalDate tanggal;

    @NotNull(message = "Jam mulai tidak boleh kosong")
    private LocalTime jamMulai;

    @NotNull(message = "Jam selesai tidak boleh kosong")
    private LocalTime jamSelesai;

    private String materi;

    @NotNull(message = "Classroom ID tidak boleh kosong")
    private Long classRoomId;
}