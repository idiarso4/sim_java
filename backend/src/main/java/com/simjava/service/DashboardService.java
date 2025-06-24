package com.simjava.service;

import java.time.LocalDate;
import java.util.Map;

public interface DashboardService {
    
    /**
     * Get overall dashboard summary including student, attendance, and teaching activity statistics
     * @return Map containing summary statistics
     */
    Map<String, Object> getDashboardSummary();
    
    /**
     * Get upcoming classes for the next few days
     * @param days Number of days to look ahead
     * @return List of upcoming classes
     */
    Map<String, Object> getUpcomingClasses(int days);
    
    /**
     * Get recent activities across the system
     * @param limit Maximum number of activities to return
     * @return List of recent activities
     */
    Map<String, Object> getRecentActivities(int limit);
    
    /**
     * Get teaching activity statistics
     * @param startDate Optional start date for filtering
     * @param endDate Optional end date for filtering
     * @return Map containing teaching activity statistics
     */
    Map<String, Object> getTeachingActivityStatistics(LocalDate startDate, LocalDate endDate);
    
    /**
     * Get student statistics
     * @return Map containing student statistics
     */
    Map<String, Object> getStudentStatistics();
    
    /**
     * Get attendance statistics
     * @param startDate Optional start date for filtering
     * @param endDate Optional end date for filtering
     * @return Map containing attendance statistics
     */
    Map<String, Object> getAttendanceStatistics(LocalDate startDate, LocalDate endDate);
    
    /**
     * Mendapatkan data dashboard lengkap
     * 
     * @return Map berisi data dashboard
     */
    Map<String, Object> getDashboardData();
} 