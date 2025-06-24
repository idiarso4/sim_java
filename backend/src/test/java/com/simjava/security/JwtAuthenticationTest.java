package com.simjava.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.simjava.dto.AuthRequest;
import com.simjava.dto.AuthResponse;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class JwtAuthenticationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void testLoginWithValidCredentialsShouldReturnToken() throws Exception {
        // Create login request
        AuthRequest loginRequest = new AuthRequest();
        loginRequest.setEmail("admin@example.com");
        loginRequest.setPassword("password");

        // Perform login request
        MvcResult result = mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").exists())
                .andReturn();

        // Extract token from response
        AuthResponse response = objectMapper.readValue(
                result.getResponse().getContentAsString(), AuthResponse.class);
        String token = response.getToken();
        assertNotNull(token);
        assertTrue(token.length() > 20); // Simple validation that token looks reasonable
    }

    @Test
    public void testLoginWithInvalidCredentialsShouldFail() throws Exception {
        // Create login request with invalid credentials
        AuthRequest loginRequest = new AuthRequest();
        loginRequest.setEmail("admin@example.com");
        loginRequest.setPassword("wrongpassword");

        // Perform login request and expect failure
        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    public void testAccessProtectedEndpointWithoutAuthenticationShouldFail() throws Exception {
        // Try to access protected endpoint without authentication
        mockMvc.perform(get("/students"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @WithMockUser(roles = "USER")
    public void testAccessAdminEndpointWithUserRoleShouldFail() throws Exception {
        // Try to access admin endpoint with USER role
        mockMvc.perform(post("/students")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isForbidden());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testAccessAdminEndpointWithAdminRoleShouldSucceed() throws Exception {
        // Access admin endpoint with ADMIN role
        mockMvc.perform(get("/students"))
                .andExpect(status().isOk());
    }

    @Test
    public void testAuthenticationWithValidTokenShouldSucceed() throws Exception {
        // First, get a valid token
        AuthRequest loginRequest = new AuthRequest();
        loginRequest.setEmail("admin@example.com");
        loginRequest.setPassword("password");

        MvcResult loginResult = mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andReturn();

        AuthResponse response = objectMapper.readValue(
                loginResult.getResponse().getContentAsString(), AuthResponse.class);
        String token = response.getToken();

        // Then use the token to access a protected endpoint
        mockMvc.perform(get("/students")
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    @Test
    public void testAuthenticationWithInvalidTokenShouldFail() throws Exception {
        // Use an invalid token to access a protected endpoint
        String invalidToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." +
                "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ." +
                "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

        mockMvc.perform(get("/students")
                .header("Authorization", "Bearer " + invalidToken))
                .andExpect(status().isUnauthorized());
    }
} 