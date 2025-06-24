package com.simjava.service.impl;

import com.simjava.domain.security.User;
import com.simjava.dto.UserRequest;
import com.simjava.dto.UserResponse;
import com.simjava.exception.ResourceNotFoundException;
import com.simjava.repository.UserRepository;
import com.simjava.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;



@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public UserResponse createUser(UserRequest request) {
        User user = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .userType(request.getUserType())
                .role(request.getRole())
                .status(request.getStatus())
                .classRoomId(request.getClassRoomId())
                .build();
        
        User savedUser = userRepository.save(user);
        return mapToUserResponse(savedUser);
    }

    @Override
    public UserResponse getUserById(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
        return mapToUserResponse(user);
    }

    @Override
    public UserResponse getUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + email));
        return mapToUserResponse(user);
    }

    @Override
    public Page<UserResponse> getAllUsers(Pageable pageable, String search, String userType) {
        Page<User> users;
        
        if (search != null && !search.isEmpty() && userType != null && !userType.isEmpty()) {
            users = userRepository.findByNameContainingIgnoreCaseAndUserType(search, userType, pageable);
        } else if (search != null && !search.isEmpty()) {
            users = userRepository.findByNameContainingIgnoreCase(search, pageable);
        } else if (userType != null && !userType.isEmpty()) {
            users = userRepository.findByUserType(userType, pageable);
        } else {
            users = userRepository.findAll(pageable);
        }
        
        return users.map(this::mapToUserResponse);
    }

    @Override
    @Transactional
    public UserResponse updateUser(Long id, UserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
        
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setUserType(request.getUserType());
        user.setRole(request.getRole());
        user.setStatus(request.getStatus());
        user.setClassRoomId(request.getClassRoomId());
        
        // Only update password if provided
        if (request.getPassword() != null && !request.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }
        
        User updatedUser = userRepository.save(user);
        return mapToUserResponse(updatedUser);
    }

    @Override
    @Transactional
    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("User not found with id: " + id);
        }
        userRepository.deleteById(id);
    }

    @Override
    @Transactional
    public UserResponse changePassword(Long id, String currentPassword, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
        
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }
        
        user.setPassword(passwordEncoder.encode(newPassword));
        
        User updatedUser = userRepository.save(user);
        return mapToUserResponse(updatedUser);
    }
    
    private UserResponse mapToUserResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .userType(user.getUserType())
                .role(user.getRole())
                .status(user.getStatus())
                .classRoomId(user.getClassRoomId())
                .image(user.getImage())
                .createdAt(user.getCreatedAt())
                .updatedAt(user.getUpdatedAt())
                .build();
    }
}