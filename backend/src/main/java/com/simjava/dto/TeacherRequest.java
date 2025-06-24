package com.simjava.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeacherRequest {
    
    @NotBlank(message = "NIP is required")
    private String nip;
    
    @NotBlank(message = "Nama lengkap is required")
    private String namaLengkap;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Email must be valid")
    private String email;
    
    private String telp;
    
    @NotBlank(message = "Jenis kelamin is required")
    @Pattern(regexp = "^(L|P)$", message = "Jenis kelamin must be either 'L' or 'P'")
    private String jenisKelamin;
    
    private String tempatLahir;
    
    private LocalDate tanggalLahir;
    
    private String alamat;
    
    private String agama;
    
    private String pendidikanTerakhir;
    
    private String jurusan;
    
    private Integer tahunLulus;
    
    private String statusKepegawaian;
    
    @NotBlank(message = "Status is required")
    @Pattern(regexp = "^(aktif|nonaktif)$", message = "Status must be either 'aktif' or 'nonaktif'")
    private String status;
    
    private String foto;
    
    private Long userId;
} 