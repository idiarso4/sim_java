package com.simjava.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserResponse {
    private Long id;
    private String name;
    private String email;
    private String userType;
    private String role;
    private String status;
    private Long classRoomId;
    private String image;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
} 