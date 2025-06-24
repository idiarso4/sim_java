package com.simjava.controller;

import com.simjava.service.DashboardService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

public class DashboardControllerTest {

    private MockMvc mockMvc;

    @Mock
    private DashboardService dashboardService;

    @InjectMocks
    private DashboardController dashboardController;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(dashboardController).build();
    }

    @Test
    public void testGetDashboardSummary() throws Exception {
        // Prepare test data
        Map<String, Object> summaryData = new HashMap<>();
        summaryData.put("totalStudents", 100);
        summaryData.put("totalTeachers", 20);
        
        // Mock service response
        when(dashboardService.getDashboardSummary()).thenReturn(summaryData);
        
        // Perform the test
        mockMvc.perform(get("/dashboard/summary")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalStudents").value(100))
                .andExpect(jsonPath("$.totalTeachers").value(20));
    }

    @Test
    public void testGetUpcomingClasses() throws Exception {
        // Prepare test data
        Map<String, Object> classesData = new HashMap<>();
        classesData.put("totalClasses", 5);
        
        // Mock service response
        when(dashboardService.getUpcomingClasses(anyInt())).thenReturn(classesData);
        
        // Perform the test
        mockMvc.perform(get("/dashboard/upcoming-classes")
                .param("days", "7")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalClasses").value(5));
    }

    @Test
    public void testGetTeachingActivityStatistics() throws Exception {
        // Prepare test data
        Map<String, Object> statisticsData = new HashMap<>();
        statisticsData.put("totalActivities", 50);
        statisticsData.put("attendanceRate", 85.5);
        
        // Mock service response
        when(dashboardService.getTeachingActivityStatistics(any(LocalDate.class), any(LocalDate.class)))
                .thenReturn(statisticsData);
        
        // Perform the test
        mockMvc.perform(get("/dashboard/teaching-statistics")
                .param("startDate", "2025-06-01")
                .param("endDate", "2025-06-30")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalActivities").value(50))
                .andExpect(jsonPath("$.attendanceRate").value(85.5));
    }
} 