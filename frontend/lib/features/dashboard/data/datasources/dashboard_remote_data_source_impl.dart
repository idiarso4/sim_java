import 'package:dio/dio.dart';
import 'package:sim_java_frontend/core/error/exceptions.dart';
import 'package:sim_java_frontend/features/dashboard/data/datasources/dashboard_api_service.dart';
import 'package:sim_java_frontend/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:sim_java_frontend/features/dashboard/data/models/upcoming_class_model.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DashboardApiService apiService;

  DashboardRemoteDataSourceImpl({required this.apiService});

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    try {
      return await apiService.getDashboardSummary();
    } on ServerException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to load dashboard summary');
    }
  }

  @override
  Future<List<UpcomingClass>> getUpcomingClasses() async {
    try {
      return await apiService.getUpcomingClasses();
    } on ServerException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to load upcoming classes');
    }
  }
}
