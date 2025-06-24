package com.simjava.service;

import com.simjava.dto.UserRequest;
import com.simjava.dto.UserResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface UserService {
    UserResponse createUser(UserRequest request);
    UserResponse getUserById(Long id);
    UserResponse getUserByEmail(String email);
    Page<UserResponse> getAllUsers(Pageable pageable, String search, String userType);
    UserResponse updateUser(Long id, UserRequest request);
    void deleteUser(Long id);
    UserResponse changePassword(Long id, String currentPassword, String newPassword);
} 