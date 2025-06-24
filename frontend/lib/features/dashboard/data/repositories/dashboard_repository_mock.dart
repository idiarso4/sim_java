import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryMock implements DashboardRepository {
  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock data
    return Right(
      DashboardSummary(
        totalStudents: 245,
        totalTeachers: 32,
        todayAttendance: 87,
        totalClasses: 15,
        upcomingClasses: [
          UpcomingClass(
            id: '1',
            className: 'XII IPA 1',
            subject: 'Matematika',
            time: '08:00 - 09:30',
            teacherName: 'Budi Santoso',
          ),
          UpcomingClass(
            id: '2',
            className: 'XI IPS 2',
            subject: 'Bahasa Inggris',
            time: '10:00 - 11:30',
            teacherName: 'Ani Lestari',
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, List<UpcomingClass>>> getUpcomingClasses() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock data
    return Right([
      UpcomingClass(
        id: '1',
        className: 'XII IPA 1',
        subject: 'Matematika',
        time: '08:00 - 09:30',
        teacherName: 'Budi Santoso',
      ),
      UpcomingClass(
        id: '2',
        className: 'XI IPS 2',
        subject: 'Bahasa Inggris',
        time: '10:00 - 11:30',
        teacherName: 'Ani Lestari',
      ),
      UpcomingClass(
        id: '3',
        className: 'X MIPA 3',
        subject: 'Fisika',
        time: '13:00 - 14:30',
        teacherName: 'Dewi Kurnia',
      ),
    ]);
  }
}
