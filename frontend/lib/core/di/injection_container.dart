import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import '../network/mock_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Firebase
import '../services/firebase_messaging_service.dart';

// Student Feature
import '../../../features/student/data/datasources/student_remote_data_source.dart';
import '../../../features/student/data/repositories/student_repository_impl.dart';
import '../../../features/student/domain/repositories/student_repository.dart';
import '../../../features/student/domain/usecases/create_student.dart';
import '../../../features/student/domain/usecases/delete_student.dart';
import '../../../features/student/domain/usecases/export_students.dart';
import '../../../features/student/domain/usecases/get_student.dart';
import '../../../features/student/domain/usecases/get_students.dart';
import '../../../features/student/domain/usecases/update_student.dart';
import '../../../features/student/domain/usecases/upload_student_photo.dart';
import '../../../features/student/presentation/bloc/student_detail/student_detail_bloc.dart';
import '../../../features/student/presentation/bloc/student_form/student_form_bloc.dart';
import '../../../features/student/presentation/bloc/student_list/student_list_bloc.dart';
import '../../../features/student/presentation/bloc/student_search/student_search_bloc.dart';

// Dashboard Feature
import '../../../features/dashboard/di/dashboard_injection.dart';
import '../../../features/dashboard/di/dashboard_injection_dev.dart' show initDashboardFeatureDev;

// Core
import '../../utils/api_utils.dart';
import '../../utils/logger_utils.dart';
import '../../utils/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  await _initExternalDependencies();
  
  //! Core
  await _initCoreDependencies();
  
  //! Add mock interceptor for development
  final dio = sl<Dio>();
  dio.interceptors.add(MockInterceptor(isEnabled: true));
  
  //! Features
  await _initStudentDependencies();
  await _initDashboardDependencies(); // Using real implementation with mock interceptor
}

Future<void> _initExternalDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Internet Connection Checker
  sl.registerLazySingleton(() => InternetConnectionChecker());
  
  // Dio
  sl.registerLazySingleton(() => Dio()
    ..options = BaseOptions(
      baseUrl: 'https://your-api-base-url.com/api', // Replace with your API base URL
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    )
    ..interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    )));
    
  // Firebase Messaging Service
  sl.registerLazySingleton(() => FirebaseMessagingService());
}

Future<void> _initCoreDependencies() async {
  // Logger
  sl.registerLazySingleton<LoggerUtils>(() => LoggerUtils());
  
  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );
  
  // API Utils
  sl.registerLazySingleton<ApiUtils>(
    () => ApiUtils(dio: sl<Dio>(), networkInfo: sl<NetworkInfo>()),
  );
}

Future<void> _initStudentDependencies() async {
  // Data sources
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(client: sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      remoteDataSource: sl<StudentRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetStudents(sl<StudentRepository>()));
  sl.registerLazySingleton(() => GetStudent(sl<StudentRepository>()));
  sl.registerLazySingleton(() => CreateStudent(sl<StudentRepository>()));
  sl.registerLazySingleton(() => UpdateStudent(sl<StudentRepository>()));
  sl.registerLazySingleton(() => DeleteStudent(sl<StudentRepository>()));
  sl.registerLazySingleton(() => UploadStudentPhoto(sl<StudentRepository>()));
  sl.registerLazySingleton(() => ExportStudents(sl<StudentRepository>()));

  // BLoCs
  sl.registerFactory(
    () => StudentListBloc(
      getStudents: sl<GetStudents>(),
      deleteStudent: sl<DeleteStudent>(),
    ),
  );

  sl.registerFactory(
    () => StudentDetailBloc(
      getStudent: sl<GetStudent>(),
    ),
  );

  sl.registerFactory(
    () => StudentFormBloc(
      createStudent: sl<CreateStudent>(),
      updateStudent: sl<UpdateStudent>(),
      uploadPhoto: sl<UploadStudentPhoto>(),
    ),
  );

  sl.registerFactory(
    () => StudentSearchBloc(
      searchStudents: sl<GetStudents>(),
    ),
  );
}

Future<void> _initDashboardDependencies() async {
  initDashboardFeature(sl);
}

Future<void> _initDashboardDependenciesDev() async {
  initDashboardFeatureDev(sl);
}
