package com.simjava.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class StudentApiIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;
    
    private Long testStudentId;
    private String testStudentNis;
    
    @BeforeEach
    public void setup() throws Exception {
        // Create a test student for use in the tests
        if (testStudentId == null) {
            Map<String, Object> studentData = createTestStudentData("test-nis-" + System.currentTimeMillis());
            
            MvcResult result = mockMvc.perform(post("/students")
                    .with(SecurityMockMvcRequestPostProcessors.csrf())
                    .with(SecurityMockMvcRequestPostProcessors.user("admin").roles("ADMIN"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(objectMapper.writeValueAsString(studentData)))
                    .andReturn();
            
            // Extract the ID from the response
            String responseContent = result.getResponse().getContentAsString();
            @SuppressWarnings("unchecked")
            Map<String, Object> responseMap = objectMapper.readValue(responseContent, Map.class);
            testStudentId = Long.valueOf(responseMap.get("id").toString());
            testStudentNis = studentData.get("nis").toString();
        }
    }

    private Map<String, Object> createTestStudentData(String nis) {
        Map<String, Object> studentData = new HashMap<>();
        studentData.put("nis", nis);
        studentData.put("namaLengkap", "Test Student");
        studentData.put("email", "test-" + nis + "@example.com");
        studentData.put("telp", "081234567890");
        studentData.put("jenisKelamin", "L");
        studentData.put("agama", "Islam");
        studentData.put("classRoomId", 1);
        return studentData;
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetAllStudents() throws Exception {
        // Test retrieving all students
        mockMvc.perform(get("/students")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(greaterThanOrEqualTo(0))));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetStudentById() throws Exception {
        // Get a student by ID and verify the response
        mockMvc.perform(get("/students/" + testStudentId)
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testStudentId))
                .andExpect(jsonPath("$.nis").value(testStudentNis))
                .andExpect(jsonPath("$.namaLengkap").value("Test Student"));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testCreateStudent() throws Exception {
        // Create a new student and verify it was created successfully
        String uniqueNis = "new-nis-" + System.currentTimeMillis();
        Map<String, Object> studentData = createTestStudentData(uniqueNis);
        
        mockMvc.perform(post("/students")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(studentData)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.nis").value(uniqueNis))
                .andExpect(jsonPath("$.namaLengkap").value("Test Student"));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testUpdateStudent() throws Exception {
        // Update an existing student and verify the changes
        Map<String, Object> updateData = new HashMap<>();
        updateData.put("namaLengkap", "Updated Student Name");
        updateData.put("email", "updated-" + testStudentNis + "@example.com");
        
        mockMvc.perform(put("/students/" + testStudentId)
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateData)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testStudentId))
                .andExpect(jsonPath("$.namaLengkap").value("Updated Student Name"))
                .andExpect(jsonPath("$.email").value("updated-" + testStudentNis + "@example.com"));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testDeleteStudent() throws Exception {
        // Create a student to delete
        String uniqueNis = "delete-nis-" + System.currentTimeMillis();
        Map<String, Object> studentData = createTestStudentData(uniqueNis);
        
        MvcResult createResult = mockMvc.perform(post("/students")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(studentData)))
                .andExpect(status().isOk())
                .andReturn();
        
        // Extract the ID from the response
        String responseContent = createResult.getResponse().getContentAsString();
        @SuppressWarnings("unchecked")
        Map<String, Object> responseMap = objectMapper.readValue(responseContent, Map.class);
        Long studentIdToDelete = Long.valueOf(responseMap.get("id").toString());
        
        // Delete the student
        mockMvc.perform(delete("/students/" + studentIdToDelete)
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
        
        // Verify the student was deleted
        mockMvc.perform(get("/students/" + studentIdToDelete)
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @WithMockUser(roles = "USER")
    public void testAccessDeniedForNonAdminUsers() throws Exception {
        // Test that non-admin users cannot create/update/delete students
        mockMvc.perform(post("/students")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isForbidden());
    }
}
