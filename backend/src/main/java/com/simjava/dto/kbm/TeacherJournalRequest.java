package com.simjava.dto.kbm;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class TeacherJournalRequest {

    @NotNull(message = "Teacher ID tidak boleh kosong")
    private Long teacherId;

    private Long teachingActivityId;

    @NotNull(message = "Tanggal tidak boleh kosong")
    private LocalDate date;

    @NotBlank(message = "Konten tidak boleh kosong")
    private String content;

    private String attachmentUrl;
}