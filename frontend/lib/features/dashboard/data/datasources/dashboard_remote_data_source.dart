import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummary> getDashboardSummary();
  Future<List<UpcomingClass>> getUpcomingClasses();
}
