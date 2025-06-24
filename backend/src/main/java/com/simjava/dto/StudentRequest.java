package com.simjava.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StudentRequest {
    @NotBlank(message = "Username is required")
    private String username;

    @NotBlank(message = "NIS is required")
    private String nis;

    @NotBlank(message = "NISN is required")
    private String nisn;

    @NotBlank(message = "Gender is required")
    private String gender;

    @NotBlank(message = "Birth place is required")
    private String birthPlace;

    @NotNull(message = "Birth date is required")
    private LocalDate birthDate;

    @NotBlank(message = "Address is required")
    private String address;

    @NotBlank(message = "Religion is required")
    private String religion;

    @NotBlank(message = "Class room is required")
    private String classRoom;

    @NotBlank(message = "School year is required")
    private String schoolYear;

    @NotBlank(message = "Status is required")
    private String status;

    @NotBlank(message = "Name is required")
    private String namaLengkap;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    private String telp;

    @NotBlank(message = "Gender is required")
    @Pattern(regexp = "[LP]", message = "Gender must be 'L' for male or 'P' for female")
    private String jenisKelamin;

    @NotBlank(message = "Religion is required")
    private String agama;

    @NotNull(message = "Class room ID is required")
    private Long classRoomId;

    private Long userId;
}
