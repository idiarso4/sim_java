import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSummary>> getDashboardSummary();
  Future<Either<Failure, List<UpcomingClass>>> getUpcomingClasses();
}
