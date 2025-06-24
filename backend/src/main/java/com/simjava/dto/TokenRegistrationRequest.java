package com.simjava.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TokenRegistrationRequest {
    
    @NotBlank(message = "FCM token is required")
    private String token;
    
    private String topic;
    
    private String userId;
    
    private String deviceInfo;
} 