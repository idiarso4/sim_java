package com.simjava.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.Map;

@Data
public class SetCustomClaimsRequest {
    
    @NotNull(message = "Claims are required")
    private Map<String, Object> claims;
} 