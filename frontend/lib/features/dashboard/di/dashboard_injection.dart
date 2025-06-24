import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sim_java_frontend/core/network/network_info.dart';
import 'package:sim_java_frontend/features/dashboard/data/datasources/dashboard_api_service.dart';
import 'package:sim_java_frontend/features/dashboard/data/datasources/dashboard_remote_data_source_impl.dart';
import 'package:sim_java_frontend/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sim_java_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_upcoming_classes.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';

void initDashboardFeature(GetIt sl) {
  // API Service
  sl.registerLazySingleton<DashboardApiService>(
    () => DashboardApiService(client: sl<Dio>()),
  );

  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(apiService: sl<DashboardApiService>()),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDashboardSummary(sl<DashboardRepository>()));
  sl.registerLazySingleton(() => GetUpcomingClasses(sl<DashboardRepository>()));

  // BLoC
  sl.registerFactory(
    () => DashboardBloc(
      getDashboardSummary: sl<GetDashboardSummary>(),
      getUpcomingClasses: sl<GetUpcomingClasses>(),
    ),
  );
}
