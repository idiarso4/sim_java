package com.simjava.service;

import com.simjava.domain.kbm.TeachingActivity;
import com.simjava.domain.kbm.TeachingActivityAttendance;
import com.simjava.domain.security.Attendance;
import com.simjava.domain.security.Student;
import com.simjava.repository.AttendanceRepository;
import com.simjava.repository.StudentRepository;
import com.simjava.repository.kbm.TeachingActivityAttendanceRepository;
import com.simjava.repository.kbm.TeachingActivityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final StudentRepository studentRepository;
    private final AttendanceRepository attendanceRepository;
    private final TeachingActivityRepository teachingActivityRepository;
    private final TeachingActivityAttendanceRepository teachingActivityAttendanceRepository;

    @Override
    public Map<String, Object> getDashboardSummary() {
        Map<String, Object> summary = new HashMap<>();
        
        // Add student statistics
        summary.put("studentStatistics", getStudentStatistics());
        
        // Add attendance statistics for the last 30 days
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(30);
        summary.put("attendanceStatistics", getAttendanceStatistics(startDate, endDate));
        
        // Add teaching activity statistics for the last 30 days
        summary.put("teachingActivityStatistics", getTeachingActivityStatistics(startDate, endDate));
        
        // Add upcoming classes for the next 7 days
        summary.put("upcomingClasses", getUpcomingClasses(7));
        
        // Add recent activities
        summary.put("recentActivities", getRecentActivities(10));
        
        return summary;
    }

    @Override
    public Map<String, Object> getUpcomingClasses(int days) {
        LocalDate today = LocalDate.now();
        LocalDate endDate = today.plusDays(days);
        
        List<TeachingActivity> upcomingActivities = teachingActivityRepository.findAll()
                .stream()
                .filter(activity -> !activity.getTanggal().isBefore(today) && !activity.getTanggal().isAfter(endDate))
                .sorted(Comparator.comparing(TeachingActivity::getTanggal).thenComparing(TeachingActivity::getJamMulai))
                .collect(Collectors.toList());
        
        List<Map<String, Object>> classes = new ArrayList<>();
        for (TeachingActivity activity : upcomingActivities) {
            Map<String, Object> classInfo = new HashMap<>();
            classInfo.put("id", activity.getId());
            classInfo.put("mataPelajaran", activity.getMataPelajaran());
            classInfo.put("tanggal", activity.getTanggal());
            classInfo.put("jamMulai", activity.getJamMulai());
            classInfo.put("jamSelesai", activity.getJamSelesai());
            classInfo.put("guruId", activity.getGuru().getId());
            classInfo.put("guruNama", activity.getGuru().getName());
            classInfo.put("classRoomId", activity.getClassRoomId());
            classes.add(classInfo);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("classes", classes);
        result.put("totalClasses", classes.size());
        
        return result;
    }

    @Override
    public Map<String, Object> getRecentActivities(int limit) {
        // Get recent teaching activities
        List<TeachingActivity> recentTeachingActivities = teachingActivityRepository.findAll(
                PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "createdAt"))
        ).getContent();
        
        List<Map<String, Object>> activities = new ArrayList<>();
        for (TeachingActivity activity : recentTeachingActivities) {
            Map<String, Object> activityInfo = new HashMap<>();
            activityInfo.put("id", activity.getId());
            activityInfo.put("type", "teaching");
            activityInfo.put("title", activity.getMataPelajaran());
            activityInfo.put("date", activity.getTanggal());
            activityInfo.put("time", activity.getJamMulai());
            activityInfo.put("guruId", activity.getGuru().getId());
            activityInfo.put("guruNama", activity.getGuru().getName());
            activities.add(activityInfo);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("activities", activities);
        result.put("totalActivities", activities.size());
        
        return result;
    }

    @Override
    public Map<String, Object> getTeachingActivityStatistics(LocalDate startDate, LocalDate endDate) {
        // Default to last 30 days if dates not provided
        LocalDate start = startDate != null ? startDate : LocalDate.now().minusDays(30);
        LocalDate end = endDate != null ? endDate : LocalDate.now();
        
        List<TeachingActivity> activities = teachingActivityRepository.findAll()
                .stream()
                .filter(activity -> !activity.getTanggal().isBefore(start) && !activity.getTanggal().isAfter(end))
                .collect(Collectors.toList());
        
        // Get all teaching activity attendances for these activities
        List<TeachingActivityAttendance> attendances = teachingActivityAttendanceRepository.findAll()
                .stream()
                .filter(attendance -> activities.contains(attendance.getTeachingActivity()))
                .collect(Collectors.toList());
        
        // Calculate statistics
        Map<String, Object> statistics = new HashMap<>();
        
        // Total number of teaching activities
        statistics.put("totalActivities", activities.size());
        
        // Activities by subject
        Map<String, Long> activitiesBySubject = activities.stream()
                .collect(Collectors.groupingBy(TeachingActivity::getMataPelajaran, Collectors.counting()));
        statistics.put("activitiesBySubject", activitiesBySubject);
        
        // Activities by day of week
        Map<String, Long> activitiesByDayOfWeek = activities.stream()
                .collect(Collectors.groupingBy(a -> a.getTanggal().getDayOfWeek().toString(), Collectors.counting()));
        statistics.put("activitiesByDayOfWeek", activitiesByDayOfWeek);
        
        // Activities by teacher
        Map<Long, Long> activitiesByTeacher = activities.stream()
                .collect(Collectors.groupingBy(a -> a.getGuru().getId(), Collectors.counting()));
        statistics.put("activitiesByTeacher", activitiesByTeacher);
        
        // Average duration in minutes
        double avgDurationMinutes = activities.stream()
                .mapToLong(a -> ChronoUnit.MINUTES.between(a.getJamMulai(), a.getJamSelesai()))
                .average()
                .orElse(0);
        statistics.put("averageDurationMinutes", avgDurationMinutes);
        
        // Attendance statistics
        long totalAttendances = attendances.size();
        statistics.put("totalAttendances", totalAttendances);
        
        // Attendance by status
        Map<String, Long> attendanceByStatus = attendances.stream()
                .collect(Collectors.groupingBy(TeachingActivityAttendance::getStatus, Collectors.counting()));
        statistics.put("attendanceByStatus", attendanceByStatus);
        
        // Calculate attendance rate
        long presentCount = attendanceByStatus.getOrDefault("Hadir", 0L);
        double attendanceRate = totalAttendances > 0 ? (double) presentCount / totalAttendances * 100 : 0;
        statistics.put("attendanceRate", attendanceRate);
        
        // Activities by class
        Map<Long, Long> activitiesByClass = activities.stream()
                .collect(Collectors.groupingBy(TeachingActivity::getClassRoomId, Collectors.counting()));
        statistics.put("activitiesByClass", activitiesByClass);
        
        return statistics;
    }

    @Override
    public Map<String, Object> getStudentStatistics() {
        List<Student> students = studentRepository.findAll();
        
        Map<String, Object> statistics = new HashMap<>();
        
        // Total number of students
        statistics.put("totalStudents", students.size());
        
        // Students by gender
        Map<Character, Long> studentsByGender = students.stream()
                .collect(Collectors.groupingBy(Student::getJenisKelamin, Collectors.counting()));
        statistics.put("studentsByGender", studentsByGender);
        
        // Students by class
        Map<Long, Long> studentsByClass = students.stream()
                .collect(Collectors.groupingBy(Student::getClassRoomId, Collectors.counting()));
        statistics.put("studentsByClass", studentsByClass);
        
        // Students by religion
        Map<String, Long> studentsByReligion = students.stream()
                .collect(Collectors.groupingBy(Student::getAgama, Collectors.counting()));
        statistics.put("studentsByReligion", studentsByReligion);
        
        return statistics;
    }

    @Override
    public Map<String, Object> getAttendanceStatistics(LocalDate startDate, LocalDate endDate) {
        // Default to last 30 days if dates not provided
        LocalDate start = startDate != null ? startDate : LocalDate.now().minusDays(30);
        LocalDate end = endDate != null ? endDate : LocalDate.now();
        
        List<Attendance> attendances = attendanceRepository.findAll()
                .stream()
                .filter(attendance -> !attendance.getDate().isBefore(start) && !attendance.getDate().isAfter(end))
                .collect(Collectors.toList());
        
        Map<String, Object> statistics = new HashMap<>();
        
        // Total number of attendances
        statistics.put("totalAttendances", attendances.size());
        
        // Attendances by status
        Map<String, Long> attendancesByStatus = attendances.stream()
                .collect(Collectors.groupingBy(Attendance::getStatus, Collectors.counting()));
        statistics.put("attendancesByStatus", attendancesByStatus);
        
        // Attendances by date
        Map<LocalDate, Long> attendancesByDate = attendances.stream()
                .collect(Collectors.groupingBy(Attendance::getDate, Collectors.counting()));
        statistics.put("attendancesByDate", attendancesByDate);
        
        // Attendance rate
        long presentCount = attendancesByStatus.getOrDefault("Hadir", 0L);
        double attendanceRate = attendances.size() > 0 ? (double) presentCount / attendances.size() * 100 : 0;
        statistics.put("attendanceRate", attendanceRate);
        
        // Attendances by type
        Map<String, Long> attendancesByType = attendances.stream()
                .collect(Collectors.groupingBy(Attendance::getType, Collectors.counting()));
        statistics.put("attendancesByType", attendancesByType);
        
        return statistics;
    }

    @Override
    public Map<String, Object> getDashboardData() {
        Map<String, Object> dashboardData = new HashMap<>();
        
        // Tambahkan statistik siswa
        dashboardData.put("studentStatistics", getStudentStatistics());
        
        // Tambahkan statistik kehadiran
        LocalDate startDate = LocalDate.now().minusDays(30);
        LocalDate endDate = LocalDate.now();
        dashboardData.put("attendanceStatistics", getAttendanceStatistics(startDate, endDate));
        
        // Tambahkan aktivitas terbaru (5 aktivitas terakhir)
        dashboardData.put("recentActivities", getRecentActivities(5));
        
        // Tambahkan kelas yang akan datang (5 kelas terdekat)
        dashboardData.put("upcomingClasses", getUpcomingClasses(5));
        
        return dashboardData;
    }
}
