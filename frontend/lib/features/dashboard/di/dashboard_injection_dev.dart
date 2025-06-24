import 'package:get_it/get_it.dart';
import 'package:sim_java_frontend/features/dashboard/data/repositories/dashboard_repository_mock.dart';
import 'package:sim_java_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_upcoming_classes.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';

void initDashboardFeatureDev(GetIt sl) {
  // Use mock repository for development
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryMock(),
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
