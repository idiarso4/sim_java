package com.simjava.security;

import com.google.firebase.auth.FirebaseToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import java.util.Optional;

@Component
public class FirebaseAuthenticationUtil {

    /**
     * Mendapatkan UID pengguna yang terautentikasi
     * 
     * @return UID pengguna atau null jika tidak terautentikasi
     */
    public static String getUid() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getPrincipal())) {
            return (String) authentication.getPrincipal();
        }
        return null;
    }
    
    /**
     * Mendapatkan token Firebase yang terautentikasi
     * 
     * @return FirebaseToken atau null jika tidak tersedia
     */
    public static FirebaseToken getFirebaseToken() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes != null) {
            HttpServletRequest request = attributes.getRequest();
            return (FirebaseToken) request.getAttribute("firebaseUser");
        }
        return null;
    }
    
    /**
     * Mendapatkan email pengguna yang terautentikasi
     * 
     * @return Email pengguna atau null jika tidak tersedia
     */
    public static String getEmail() {
        FirebaseToken token = getFirebaseToken();
        return token != null ? token.getEmail() : null;
    }
    
    /**
     * Mendapatkan nama tampilan pengguna yang terautentikasi
     * 
     * @return Nama tampilan pengguna atau null jika tidak tersedia
     */
    public static String getDisplayName() {
        FirebaseToken token = getFirebaseToken();
        return token != null ? token.getName() : null;
    }
    
    /**
     * Memeriksa apakah pengguna yang terautentikasi memiliki klaim tertentu
     * 
     * @param claimName Nama klaim
     * @return true jika pengguna memiliki klaim, false jika tidak
     */
    public static boolean hasClaim(String claimName) {
        FirebaseToken token = getFirebaseToken();
        if (token != null) {
            Map<String, Object> claims = token.getClaims();
            return claims.containsKey(claimName);
        }
        return false;
    }
    
    /**
     * Mendapatkan nilai klaim tertentu
     * 
     * @param claimName Nama klaim
     * @return Nilai klaim atau null jika tidak tersedia
     */
    public static Object getClaim(String claimName) {
        FirebaseToken token = getFirebaseToken();
        if (token != null) {
            Map<String, Object> claims = token.getClaims();
            return claims.get(claimName);
        }
        return null;
    }
    
    /**
     * Mendapatkan nilai klaim tertentu dengan tipe tertentu
     * 
     * @param claimName Nama klaim
     * @param clazz Kelas tipe klaim
     * @return Optional yang berisi nilai klaim atau empty jika tidak tersedia
     */
    public static <T> Optional<T> getClaim(String claimName, Class<T> clazz) {
        FirebaseToken token = getFirebaseToken();
        if (token != null) {
            Map<String, Object> claims = token.getClaims();
            Object value = claims.get(claimName);
            if (value != null && clazz.isInstance(value)) {
                return Optional.of(clazz.cast(value));
            }
        }
        return Optional.empty();
    }
    
    /**
     * Memeriksa apakah pengguna yang terautentikasi memiliki role tertentu
     * 
     * @param role Nama role (tanpa prefix "ROLE_")
     * @return true jika pengguna memiliki role, false jika tidak
     */
    public static boolean hasRole(String role) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_" + role.toUpperCase()));
        }
        return false;
    }
} 