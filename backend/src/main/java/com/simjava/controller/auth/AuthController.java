package com.simjava.controller.auth;

import com.simjava.dto.AuthRequest;
import com.simjava.dto.AuthResponse;
import com.simjava.service.auth.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody AuthRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    // @PostMapping("/refresh-token")
    // public ResponseEntity<AuthResponse> refreshToken(@RequestBody RefreshTokenRequest request) {
    //     return ResponseEntity.ok(authService.refreshToken(request.getRefreshToken()));
    // }
}
