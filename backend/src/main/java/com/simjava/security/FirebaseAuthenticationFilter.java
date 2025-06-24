package com.simjava.security;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.simjava.service.FirebaseAuthService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Component
public class FirebaseAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseAuthenticationFilter.class);
    
    @Autowired
    private FirebaseAuthService firebaseAuthService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        // Cek apakah ada header Authorization
        String authorizationHeader = request.getHeader("Authorization");
        
        // Jika tidak ada header Authorization atau bukan Bearer token, lanjutkan ke filter berikutnya
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }
        
        // Ekstrak token dari header
        String idToken = authorizationHeader.substring(7);
        
        try {
            // Verifikasi token Firebase
            FirebaseToken decodedToken = firebaseAuthService.verifyToken(idToken);
            
            // Buat daftar otoritas (roles) berdasarkan klaim kustom
            List<SimpleGrantedAuthority> authorities = new ArrayList<>();
            
            // Periksa apakah ada klaim kustom 'role' atau 'roles'
            Map<String, Object> claims = decodedToken.getClaims();
            
            // Periksa klaim 'role' (string tunggal)
            if (claims.containsKey("role")) {
                String role = (String) claims.get("role");
                authorities.add(new SimpleGrantedAuthority("ROLE_" + role.toUpperCase()));
            }
            
            // Periksa klaim 'roles' (array string)
            if (claims.containsKey("roles")) {
                List<String> roles = (List<String>) claims.get("roles");
                for (String role : roles) {
                    authorities.add(new SimpleGrantedAuthority("ROLE_" + role.toUpperCase()));
                }
            }
            
            // Tambahkan role default jika tidak ada role yang ditemukan
            if (authorities.isEmpty()) {
                authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
            }
            
            // Buat objek autentikasi Spring Security
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    decodedToken.getUid(), idToken, authorities);
            
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            
            // Set autentikasi ke Security Context
            SecurityContextHolder.getContext().setAuthentication(authentication);
            
            // Tambahkan informasi pengguna ke request attributes
            request.setAttribute("firebaseUser", decodedToken);
            
            logger.info("Firebase Authentication successful for user: {}", decodedToken.getEmail());
            
        } catch (Exception e) {
            logger.error("Firebase Authentication failed: {}", e.getMessage());
            // Tidak set autentikasi jika verifikasi gagal
        }
        
        filterChain.doFilter(request, response);
    }
} 