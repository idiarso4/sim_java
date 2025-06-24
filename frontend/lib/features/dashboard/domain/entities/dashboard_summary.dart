import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  final int totalStudents;
  final int totalTeachers;
  final int todayAttendance;
  final int totalClasses;
  final List<UpcomingClass> upcomingClasses;

  const DashboardSummary({
    required this.totalStudents,
    required this.totalTeachers,
    required this.todayAttendance,
    required this.totalClasses,
    this.upcomingClasses = const [],
  });

  factory DashboardSummary.empty() => const DashboardSummary(
        totalStudents: 0,
        totalTeachers: 0,
        todayAttendance: 0,
        totalClasses: 0,
        upcomingClasses: [],
      );

  @override
  List<Object?> get props => [
        totalStudents,
        totalTeachers,
        todayAttendance,
        totalClasses,
        upcomingClasses,
      ];
}

class UpcomingClass extends Equatable {
  final String id;
  final String className;
  final String subject;
  final String time;
  final String? teacherName;

  const UpcomingClass({
    required this.id,
    required this.className,
    required this.subject,
    required this.time,
    this.teacherName,
  });

  @override
  List<Object?> get props => [id, className, subject, time, teacherName];
}
