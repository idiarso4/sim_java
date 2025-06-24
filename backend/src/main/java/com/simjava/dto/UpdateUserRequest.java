package com.simjava.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UpdateUserRequest {
    
    private String displayName;
    
    @Email(message = "Email must be valid")
    private String email;
    
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;
    
    private String phoneNumber;
    
    private String photoUrl;
    
    private Boolean disabled;
    
    private Boolean emailVerified;
} 