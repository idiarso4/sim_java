import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/dashboard/data/models/upcoming_class_model.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required int totalStudents,
    required int totalTeachers,
    required int todayAttendance,
    required int totalClasses,
    required List<UpcomingClass> upcomingClasses,
  }) : super(
          totalStudents: totalStudents,
          totalTeachers: totalTeachers,
          todayAttendance: todayAttendance,
          totalClasses: totalClasses,
          upcomingClasses: upcomingClasses,
        );

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalStudents: json['total_students'] as int,
      totalTeachers: json['total_teachers'] as int,
      todayAttendance: json['today_attendance'] as int,
      totalClasses: json['total_classes'] as int,
      upcomingClasses: (json['upcoming_classes'] as List<dynamic>?)
              ?.map((e) => UpcomingClassModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'total_teachers': totalTeachers,
      'today_attendance': todayAttendance,
      'total_classes': totalClasses,
      'upcoming_classes': upcomingClasses
          .map((e) => (e as UpcomingClassModel).toJson())
          .toList(),
    };
  }
}
