package com.simjava.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserRequest {
    
    @NotBlank(message = "Name is required")
    private String name;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Email must be valid")
    private String email;
    
    private String password;
    
    @NotBlank(message = "User type is required")
    @Pattern(regexp = "^(admin|guru|siswa|staff)$", message = "User type must be one of: admin, guru, siswa, staff")
    private String userType;
    
    @NotBlank(message = "Role is required")
    private String role;
    
    @NotBlank(message = "Status is required")
    @Pattern(regexp = "^(aktif|nonaktif)$", message = "Status must be either 'aktif' or 'nonaktif'")
    private String status;
    
    private Long classRoomId;
} 