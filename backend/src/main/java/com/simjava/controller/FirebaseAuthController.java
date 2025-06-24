package com.simjava.controller;

import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.simjava.dto.CreateUserRequest;
import com.simjava.dto.SetCustomClaimsRequest;
import com.simjava.dto.UpdateUserRequest;
import com.simjava.service.FirebaseAuthService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class FirebaseAuthController {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseAuthController.class);
    
    @Autowired
    private FirebaseAuthService firebaseAuthService;
    
    /**
     * Mendapatkan informasi pengguna berdasarkan UID
     */
    @GetMapping("/users/{uid}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> getUserByUid(@PathVariable String uid) {
        try {
            UserRecord userRecord = firebaseAuthService.getUserByUid(uid);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("user", convertUserRecordToMap(userRecord));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error getting user by UID: {}", e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to get user data: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * Mendapatkan informasi pengguna berdasarkan email
     */
    @GetMapping("/users/email/{email}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> getUserByEmail(@PathVariable String email) {
        try {
            UserRecord userRecord = firebaseAuthService.getUserByEmail(email);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("user", convertUserRecordToMap(userRecord));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error getting user by email: {}", e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to get user data: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * Membuat pengguna baru
     */
    @PostMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> createUser(@Valid @RequestBody CreateUserRequest request) {
        try {
            UserRecord userRecord = firebaseAuthService.createUser(
                    request.getEmail(),
                    request.getPassword(),
                    request.getDisplayName()
            );
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("user", convertUserRecordToMap(userRecord));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error creating user: {}", e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to create user: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * Memperbarui informasi pengguna
     */
    @PutMapping("/users/{uid}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> updateUser(
            @PathVariable String uid,
            @Valid @RequestBody UpdateUserRequest request) {
        try {
            Map<String, Object> updates = new HashMap<>();
            
            if (request.getDisplayName() != null) {
                updates.put("displayName", request.getDisplayName());
            }
            
            if (request.getEmail() != null) {
                updates.put("email", request.getEmail());
            }
            
            if (request.getPassword() != null) {
                updates.put("password", request.getPassword());
            }
            
            if (request.getPhoneNumber() != null) {
                updates.put("phoneNumber", request.getPhoneNumber());
            }
            
            if (request.getPhotoUrl() != null) {
                updates.put("photoUrl", request.getPhotoUrl());
            }
            
            if (request.getDisabled() != null) {
                updates.put("disabled", request.getDisabled());
            }
            
            if (request.getEmailVerified() != null) {
                updates.put("emailVerified", request.getEmailVerified());
            }
            
            UserRecord userRecord = firebaseAuthService.updateUser(uid, updates);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("user", convertUserRecordToMap(userRecord));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error updating user: {}", e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to update user: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * Menghapus pengguna
     */
    @DeleteMapping("/users/{uid}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> deleteUser(@PathVariable String uid) {
        try {
            firebaseAuthService.deleteUser(uid);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "User deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error deleting user: {}", e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to delete user: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * Mengatur klaim kustom untuk pengguna (misalnya, role)
     */
    @PostMapping("/users/{uid}/claims")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> setCustomClaims(
            @PathVariable String uid,
            @Valid @RequestBody SetCustomClaimsRequest request) {
        try {
            firebaseAuthService.setCustomUserClaims(uid, request.getClaims());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Custom claims set successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error setting custom claims: {}", e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to set custom claims: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * Membuat token kustom untuk pengguna
     */
    @PostMapping("/users/{uid}/token")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> createCustomToken(
            @PathVariable String uid,
            @RequestBody(required = false) Map<String, Object> additionalClaims) {
        try {
            String token = firebaseAuthService.createCustomToken(uid, additionalClaims);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("token", token);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error creating custom token: {}", e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to create custom token: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * Konversi UserRecord ke Map untuk respons JSON
     */
    private Map<String, Object> convertUserRecordToMap(UserRecord userRecord) {
        Map<String, Object> userMap = new HashMap<>();
        userMap.put("uid", userRecord.getUid());
        userMap.put("email", userRecord.getEmail());
        userMap.put("emailVerified", userRecord.isEmailVerified());
        userMap.put("displayName", userRecord.getDisplayName());
        userMap.put("photoUrl", userRecord.getPhotoUrl());
        userMap.put("disabled", userRecord.isDisabled());
        userMap.put("phoneNumber", userRecord.getPhoneNumber());
        userMap.put("creationTimestamp", userRecord.getUserMetadata().getCreationTimestamp());
        userMap.put("lastSignInTimestamp", userRecord.getUserMetadata().getLastSignInTimestamp());
        userMap.put("customClaims", userRecord.getCustomClaims());
        userMap.put("providerData", userRecord.getProviderData());
        return userMap;
    }
} 