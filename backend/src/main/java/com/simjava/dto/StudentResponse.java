package com.simjava.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudentResponse {
    private Long id;
    private String nis;
    private String namaLengkap;
    private String email;
    private String telp;
    private char jenisKelamin;
    private String agama;
    private Long classRoomId;
    private Long userId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
