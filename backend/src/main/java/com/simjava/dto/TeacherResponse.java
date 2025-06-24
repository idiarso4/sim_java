package com.simjava.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class TeacherResponse {
    private Long id;
    private String nip;
    private String namaLengkap;
    private String email;
    private String telp;
    private String jenisKelamin;
    private String tempatLahir;
    private LocalDate tanggalLahir;
    private String alamat;
    private String agama;
    private String pendidikanTerakhir;
    private String jurusan;
    private Integer tahunLulus;
    private String statusKepegawaian;
    private String status;
    private String foto;
    private UserResponse user;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
} 