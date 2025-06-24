package com.simjava.controller;

import com.simjava.service.DashboardService;
import com.simjava.security.FirebaseAuthenticationUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
@Tag(name = "Dashboard", description = "Dashboard API for retrieving statistics and summary data")
public class DashboardController {

    private final DashboardService dashboardService;
    private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

    @Operation(
        summary = "Get dashboard summary",
        description = "Retrieves a comprehensive dashboard summary including student statistics, " +
                "attendance statistics, teaching activity statistics, upcoming classes, and recent activities"
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Successfully retrieved dashboard summary"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Authentication required"),
        @ApiResponse(responseCode = "403", description = "Forbidden - Insufficient permissions")
    })
    @GetMapping("/summary")
    public ResponseEntity<Map<String, Object>> getDashboardSummary() {
        return ResponseEntity.ok(dashboardService.getDashboardSummary());
    }

    @Operation(
        summary = "Get upcoming classes",
        description = "Retrieves a list of upcoming classes for the specified number of days"
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Successfully retrieved upcoming classes"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Authentication required"),
        @ApiResponse(responseCode = "403", description = "Forbidden - Insufficient permissions")
    })
    @GetMapping("/upcoming-classes")
    public ResponseEntity<Map<String, Object>> getUpcomingClasses(
            @Parameter(description = "Number of days to look ahead (default: 7)")
            @RequestParam(defaultValue = "7") int days) {
        return ResponseEntity.ok(dashboardService.getUpcomingClasses(days));
    }
    
    @Operation(
        summary = "Get recent activities",
        description = "Retrieves a list of recent activities across the system"
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Successfully retrieved recent activities"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Authentication required"),
        @ApiResponse(responseCode = "403", description = "Forbidden - Insufficient permissions")
    })
    @GetMapping("/recent-activities")
    public ResponseEntity<Map<String, Object>> getRecentActivities(
            @Parameter(description = "Maximum number of activities to return (default: 10)")
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(dashboardService.getRecentActivities(limit));
    }
    
    @Operation(
        summary = "Get teaching activity statistics",
        description = "Retrieves statistics about teaching activities within a specified date range"
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Successfully retrieved teaching activity statistics"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Authentication required"),
        @ApiResponse(responseCode = "403", description = "Forbidden - Insufficient permissions")
    })
    @GetMapping("/teaching-statistics")
    public ResponseEntity<Map<String, Object>> getTeachingActivityStatistics(
            @Parameter(description = "Start date for filtering (format: YYYY-MM-DD)")
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @Parameter(description = "End date for filtering (format: YYYY-MM-DD)")
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return ResponseEntity.ok(dashboardService.getTeachingActivityStatistics(startDate, endDate));
    }
    
    @Operation(
        summary = "Get student statistics",
        description = "Retrieves statistics about students including counts by gender, class, and religion"
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Successfully retrieved student statistics"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Authentication required"),
        @ApiResponse(responseCode = "403", description = "Forbidden - Insufficient permissions")
    })
    @GetMapping("/student-statistics")
    public ResponseEntity<Map<String, Object>> getStudentStatistics() {
        return ResponseEntity.ok(dashboardService.getStudentStatistics());
    }
    
    @Operation(
        summary = "Get attendance statistics",
        description = "Retrieves statistics about student attendance within a specified date range"
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Successfully retrieved attendance statistics"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Authentication required"),
        @ApiResponse(responseCode = "403", description = "Forbidden - Insufficient permissions")
    })
    @GetMapping("/attendance-statistics")
    public ResponseEntity<Map<String, Object>> getAttendanceStatistics(
            @Parameter(description = "Start date for filtering (format: YYYY-MM-DD)")
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @Parameter(description = "End date for filtering (format: YYYY-MM-DD)")
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return ResponseEntity.ok(dashboardService.getAttendanceStatistics(startDate, endDate));
    }

    @GetMapping
    public ResponseEntity<?> getDashboardData() {
        try {
            // Mendapatkan informasi pengguna yang terautentikasi
            String uid = FirebaseAuthenticationUtil.getUid();
            String email = FirebaseAuthenticationUtil.getEmail();
            
            logger.info("Dashboard data requested by user: {} ({})", email, uid);
            
            Map<String, Object> dashboardData = dashboardService.getDashboardData();
            
            // Tambahkan informasi pengguna ke respons
            dashboardData.put("currentUser", Map.of(
                "uid", uid,
                "email", email,
                "displayName", FirebaseAuthenticationUtil.getDisplayName()
            ));
            
            return ResponseEntity.ok(dashboardData);
        } catch (Exception e) {
            logger.error("Error retrieving dashboard data: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to retrieve dashboard data: " + e.getMessage()));
        }
    }
}
