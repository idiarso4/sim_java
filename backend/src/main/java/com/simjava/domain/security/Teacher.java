package com.simjava.domain.security;

import com.simjava.domain.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "teachers")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Teacher extends BaseEntity {

    @Column(name = "nip", unique = true)
    private String nip;

    @Column(name = "nama_lengkap")
    private String namaLengkap;

    @Column(name = "email")
    private String email;

    @Column(name = "telp")
    private String telp;

    @Column(name = "jenis_kelamin")
    private String jenisKelamin;

    @Column(name = "tempat_lahir")
    private String tempatLahir;

    @Column(name = "tanggal_lahir")
    private LocalDate tanggalLahir;

    @Column(name = "alamat")
    private String alamat;

    @Column(name = "agama")
    private String agama;

    @Column(name = "pendidikan_terakhir")
    private String pendidikanTerakhir;

    @Column(name = "jurusan")
    private String jurusan;

    @Column(name = "tahun_lulus")
    private Integer tahunLulus;

    @Column(name = "status_kepegawaian")
    private String statusKepegawaian;

    @Column(name = "status")
    private String status;

    @Column(name = "foto")
    private String foto;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;
} 