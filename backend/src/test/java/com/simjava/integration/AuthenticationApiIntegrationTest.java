package com.simjava.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.simjava.dto.AuthRequest;
import com.simjava.dto.AuthResponse;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class AuthenticationApiIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void testSuccessfulLogin() throws Exception {
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
                .andExpect(jsonPath("$.userId").exists())
                .andExpect(jsonPath("$.email").value("admin@example.com"))
                .andReturn();

        // Extract token from response
        AuthResponse response = objectMapper.readValue(
                result.getResponse().getContentAsString(), AuthResponse.class);
        String token = response.getToken();
        
        // Verify token is not empty
        assertNotNull(token);
        assertTrue(token.length() > 20);
    }

    @Test
    public void testFailedLoginWithInvalidCredentials() throws Exception {
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
    public void testFailedLoginWithNonExistentUser() throws Exception {
        // Create login request with non-existent user
        AuthRequest loginRequest = new AuthRequest();
        loginRequest.setEmail("nonexistent@example.com");
        loginRequest.setPassword("password");

        // Perform login request and expect failure
        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    public void testLogout() throws Exception {
        // First, login to get a token
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

        // Then, logout using the token
        mockMvc.perform(post("/auth/logout")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        // Try to access a protected endpoint with the same token (should fail)
        mockMvc.perform(get("/students")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized());
    }

    @Test
    public void testLoginWithMalformedRequest() throws Exception {
        // Create malformed login request (missing required fields)
        String malformedRequest = "{\"email\": \"admin@example.com\"}";

        // Perform login request and expect bad request
        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(malformedRequest))
                .andExpect(status().isBadRequest());
    }
} 