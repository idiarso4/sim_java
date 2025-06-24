package com.simjava.security;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class AuthorizationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testAdminCanAccessAllEndpoints() throws Exception {
        // Admin should be able to access all endpoints
        
        // Student endpoints
        mockMvc.perform(get("/students"))
                .andExpect(status().isOk());
        
        // Teacher endpoints
        mockMvc.perform(get("/teachers"))
                .andExpect(status().isOk());
        
        // Class endpoints
        mockMvc.perform(get("/classes"))
                .andExpect(status().isOk());
        
        // User endpoints
        mockMvc.perform(get("/users"))
                .andExpect(status().isOk());
        
        // Dashboard endpoints
        mockMvc.perform(get("/dashboard/summary"))
                .andExpect(status().isOk());
    }
    
    @Test
    @WithMockUser(roles = "TEACHER")
    public void testTeacherAccess() throws Exception {
        // Teachers should have limited access
        
        // Can access student information (read-only)
        mockMvc.perform(get("/students"))
                .andExpect(status().isOk());
        
        // Cannot create/modify students
        mockMvc.perform(post("/students")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isForbidden());
        
        // Can access own teacher information
        mockMvc.perform(get("/teachers/me"))
                .andExpect(status().isOk());
        
        // Can access dashboard
        mockMvc.perform(get("/dashboard/summary"))
                .andExpect(status().isOk());
        
        // Cannot access user management
        mockMvc.perform(get("/users"))
                .andExpect(status().isForbidden());
    }
    
    @Test
    @WithMockUser(roles = "STUDENT")
    public void testStudentAccess() throws Exception {
        // Students should have very limited access
        
        // Can access own student information
        mockMvc.perform(get("/students/me"))
                .andExpect(status().isOk());
        
        // Cannot access all students
        mockMvc.perform(get("/students"))
                .andExpect(status().isForbidden());
        
        // Cannot access teacher information
        mockMvc.perform(get("/teachers"))
                .andExpect(status().isForbidden());
        
        // Cannot access user management
        mockMvc.perform(get("/users"))
                .andExpect(status().isForbidden());
        
        // Can access limited dashboard
        mockMvc.perform(get("/dashboard/student-summary"))
                .andExpect(status().isOk());
    }
    
    @Test
    @WithMockUser(roles = "USER")
    public void testBasicUserAccess() throws Exception {
        // Basic users should have minimal access
        
        // Cannot access student information
        mockMvc.perform(get("/students"))
                .andExpect(status().isForbidden());
        
        // Cannot access teacher information
        mockMvc.perform(get("/teachers"))
                .andExpect(status().isForbidden());
        
        // Cannot access user management
        mockMvc.perform(get("/users"))
                .andExpect(status().isForbidden());
        
        // Can access public dashboard
        mockMvc.perform(get("/dashboard/public"))
                .andExpect(status().isOk());
    }
    
    @Test
    public void testUnauthenticatedAccess() throws Exception {
        // Unauthenticated users should not be able to access any protected endpoints
        
        mockMvc.perform(get("/students"))
                .andExpect(status().isUnauthorized());
        
        mockMvc.perform(get("/teachers"))
                .andExpect(status().isUnauthorized());
        
        mockMvc.perform(get("/classes"))
                .andExpect(status().isUnauthorized());
        
        mockMvc.perform(get("/users"))
                .andExpect(status().isUnauthorized());
        
        mockMvc.perform(get("/dashboard/summary"))
                .andExpect(status().isUnauthorized());
    }
} 