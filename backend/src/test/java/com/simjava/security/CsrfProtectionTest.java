package com.simjava.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.HashMap;
import java.util.Map;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class CsrfProtectionTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testPostRequestWithoutCsrfToken() throws Exception {
        // Create a test student object
        Map<String, Object> studentData = new HashMap<>();
        studentData.put("nis", "12345678");
        studentData.put("namaLengkap", "Test Student");
        studentData.put("email", "test@example.com");
        
        // Post request without CSRF token should be forbidden
        mockMvc.perform(post("/students")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(studentData)))
                .andExpect(status().isForbidden());
    }
    
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testPostRequestWithCsrfToken() throws Exception {
        // Create a test student object
        Map<String, Object> studentData = new HashMap<>();
        studentData.put("nis", "12345678");
        studentData.put("namaLengkap", "Test Student");
        studentData.put("email", "test@example.com");
        
        // Post request with CSRF token should be accepted
        mockMvc.perform(post("/students")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(studentData)))
                .andExpect(status().isOk());
    }
    
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testPutRequestWithoutCsrfToken() throws Exception {
        // Create update data
        Map<String, Object> updateData = new HashMap<>();
        updateData.put("namaLengkap", "Updated Student Name");
        
        // Put request without CSRF token should be forbidden
        mockMvc.perform(put("/students/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateData)))
                .andExpect(status().isForbidden());
    }
    
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testPutRequestWithCsrfToken() throws Exception {
        // Create update data
        Map<String, Object> updateData = new HashMap<>();
        updateData.put("namaLengkap", "Updated Student Name");
        
        // Put request with CSRF token should be accepted
        mockMvc.perform(put("/students/1")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateData)))
                .andExpect(status().isOk());
    }
    
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testDeleteRequestWithoutCsrfToken() throws Exception {
        // Delete request without CSRF token should be forbidden
        mockMvc.perform(delete("/students/1")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isForbidden());
    }
    
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testDeleteRequestWithCsrfToken() throws Exception {
        // Delete request with CSRF token should be accepted
        mockMvc.perform(delete("/students/1")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }
    
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetRequestWithoutCsrfToken() throws Exception {
        // GET requests should not require CSRF token
        mockMvc.perform(get("/students")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }
} 