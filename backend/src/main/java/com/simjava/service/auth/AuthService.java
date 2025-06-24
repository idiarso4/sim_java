package com.simjava.service.auth;

import com.simjava.dto.AuthRequest;
import com.simjava.dto.AuthResponse;
import com.simjava.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthResponse login(AuthRequest authRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        authRequest.getEmail(),
                        authRequest.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtTokenProvider.generateToken(authentication);

        return AuthResponse.builder()
                .token(token)
                .build();
    }

    // Hapus method refreshToken untuk sementara karena tidak lengkap
    // public AuthResponse refreshToken(String token) {
    //     UserDetails userDetails = jwtTokenProvider.getUserDetailsFromToken(token);
    //     String newToken = jwtTokenProvider.generateToken(userDetails);
    //
    //     return AuthResponse.builder()
    //             .token(newToken)
    //             .username(userDetails.getUsername())
    //             .roles(userDetails.getAuthorities().stream().map(Object::toString).collect(Collectors.toList()))
    //             .build();
    // }
}
