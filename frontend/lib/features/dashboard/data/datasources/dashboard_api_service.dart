import 'package:dio/dio.dart';
import 'package:sim_java_frontend/core/error/exceptions.dart';
import 'package:sim_java_frontend/core/network/api_constants.dart';
import 'package:sim_java_frontend/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:sim_java_frontend/features/dashboard/data/models/upcoming_class_model.dart';

class DashboardApiService {
  final Dio client;

  DashboardApiService({required this.client});

  Future<DashboardSummaryModel> getDashboardSummary() async {
    try {
      final response = await client.get(
        '${ApiConstants.baseUrl}/dashboard/summary',
      );

      if (response.statusCode == 200) {
        return DashboardSummaryModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException('Failed to load dashboard summary');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      }
      throw ServerException(e.message ?? 'Failed to load dashboard summary');
    }
  }

  Future<List<UpcomingClassModel>> getUpcomingClasses() async {
    try {
      final response = await client.get(
        '${ApiConstants.baseUrl}/dashboard/upcoming-classes',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => UpcomingClassModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException('Failed to load upcoming classes');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      }
      throw ServerException(e.message ?? 'Failed to load upcoming classes');
    }
  }
}
