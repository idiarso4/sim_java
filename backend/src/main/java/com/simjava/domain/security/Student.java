package com.simjava.domain.security;

import com.simjava.domain.BaseEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
@Table(name = "students")
public class Student extends BaseEntity {
    
    @Column(nullable = false, unique = true)
    private String nis;
    
    @Column(name = "nama_lengkap", nullable = false)
    private String namaLengkap;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    private String telp;
    
    @Column(name = "jenis_kelamin", nullable = false)
    private char jenisKelamin;
    
    @Column(nullable = false)
    private String agama;
    
    @Column(name = "class_room_id", nullable = false)
    private Long classRoomId;
    
    @Column(name = "user_id", nullable = false)
    private Long userId;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;
}
