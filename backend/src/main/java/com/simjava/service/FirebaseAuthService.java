package com.simjava.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.google.firebase.auth.UserRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class FirebaseAuthService {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseAuthService.class);
    
    /**
     * Verifikasi token ID Firebase
     * 
     * @param idToken Token ID yang diterima dari klien
     * @return FirebaseToken yang berisi informasi pengguna
     */
    public FirebaseToken verifyToken(String idToken) {
        try {
            return FirebaseAuth.getInstance().verifyIdToken(idToken);
        } catch (FirebaseAuthException e) {
            logger.error("Error verifying Firebase ID token: {}", e.getMessage());
            throw new RuntimeException("Unauthorized: Invalid Firebase ID token", e);
        }
    }
    
    /**
     * Mendapatkan informasi pengguna berdasarkan UID
     * 
     * @param uid UID pengguna Firebase
     * @return UserRecord yang berisi informasi pengguna
     */
    public UserRecord getUserByUid(String uid) {
        try {
            return FirebaseAuth.getInstance().getUser(uid);
        } catch (FirebaseAuthException e) {
            logger.error("Error getting user by UID: {}", e.getMessage());
            throw new RuntimeException("Failed to get user data", e);
        }
    }
    
    /**
     * Mendapatkan informasi pengguna berdasarkan email
     * 
     * @param email Email pengguna
     * @return UserRecord yang berisi informasi pengguna
     */
    public UserRecord getUserByEmail(String email) {
        try {
            return FirebaseAuth.getInstance().getUserByEmail(email);
        } catch (FirebaseAuthException e) {
            logger.error("Error getting user by email: {}", e.getMessage());
            throw new RuntimeException("Failed to get user data", e);
        }
    }
    
    /**
     * Membuat pengguna baru di Firebase Authentication
     * 
     * @param email Email pengguna
     * @param password Password pengguna
     * @param displayName Nama yang ditampilkan
     * @return UserRecord yang berisi informasi pengguna yang dibuat
     */
    public UserRecord createUser(String email, String password, String displayName) {
        try {
            UserRecord.CreateRequest request = new UserRecord.CreateRequest()
                    .setEmail(email)
                    .setPassword(password)
                    .setDisplayName(displayName)
                    .setEmailVerified(false);
            
            return FirebaseAuth.getInstance().createUser(request);
        } catch (FirebaseAuthException e) {
            logger.error("Error creating user: {}", e.getMessage());
            throw new RuntimeException("Failed to create user", e);
        }
    }
    
    /**
     * Memperbarui informasi pengguna
     * 
     * @param uid UID pengguna
     * @param updates Map berisi field yang akan diupdate
     * @return UserRecord yang berisi informasi pengguna yang diperbarui
     */
    public UserRecord updateUser(String uid, Map<String, Object> updates) {
        try {
            UserRecord.UpdateRequest request = new UserRecord.UpdateRequest(uid);
            
            if (updates.containsKey("displayName")) {
                request.setDisplayName((String) updates.get("displayName"));
            }
            
            if (updates.containsKey("email")) {
                request.setEmail((String) updates.get("email"));
            }
            
            if (updates.containsKey("password")) {
                request.setPassword((String) updates.get("password"));
            }
            
            if (updates.containsKey("phoneNumber")) {
                request.setPhoneNumber((String) updates.get("phoneNumber"));
            }
            
            if (updates.containsKey("photoUrl")) {
                request.setPhotoUrl((String) updates.get("photoUrl"));
            }
            
            if (updates.containsKey("disabled")) {
                request.setDisabled((Boolean) updates.get("disabled"));
            }
            
            if (updates.containsKey("emailVerified")) {
                request.setEmailVerified((Boolean) updates.get("emailVerified"));
            }
            
            return FirebaseAuth.getInstance().updateUser(request);
        } catch (FirebaseAuthException e) {
            logger.error("Error updating user: {}", e.getMessage());
            throw new RuntimeException("Failed to update user", e);
        }
    }
    
    /**
     * Menghapus pengguna berdasarkan UID
     * 
     * @param uid UID pengguna
     */
    public void deleteUser(String uid) {
        try {
            FirebaseAuth.getInstance().deleteUser(uid);
        } catch (FirebaseAuthException e) {
            logger.error("Error deleting user: {}", e.getMessage());
            throw new RuntimeException("Failed to delete user", e);
        }
    }
    
    /**
     * Membuat token kustom untuk pengguna
     * 
     * @param uid UID pengguna
     * @param additionalClaims Klaim tambahan untuk token
     * @return Token kustom
     */
    public String createCustomToken(String uid, Map<String, Object> additionalClaims) {
        try {
            if (additionalClaims == null) {
                return FirebaseAuth.getInstance().createCustomToken(uid);
            } else {
                return FirebaseAuth.getInstance().createCustomToken(uid, additionalClaims);
            }
        } catch (FirebaseAuthException e) {
            logger.error("Error creating custom token: {}", e.getMessage());
            throw new RuntimeException("Failed to create custom token", e);
        }
    }
    
    /**
     * Mengatur klaim kustom untuk pengguna
     * 
     * @param uid UID pengguna
     * @param claims Map berisi klaim yang akan diatur
     */
    public void setCustomUserClaims(String uid, Map<String, Object> claims) {
        try {
            FirebaseAuth.getInstance().setCustomUserClaims(uid, claims);
        } catch (FirebaseAuthException e) {
            logger.error("Error setting custom user claims: {}", e.getMessage());
            throw new RuntimeException("Failed to set custom user claims", e);
        }
    }
} 