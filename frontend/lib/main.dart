import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sim_java_frontend/core/config/app_config.dart';
import 'package:sim_java_frontend/core/di/injection_container.dart' as di;
import 'package:sim_java_frontend/core/routes/app_router.dart';
import 'package:sim_java_frontend/core/services/firebase_messaging_service.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';
import 'package:sim_java_frontend/core/utils/logger_utils.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_detail/student_detail_bloc.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_form/student_form_bloc.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_list/student_list_bloc.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_search/student_search_bloc.dart';
import 'package:sim_java_frontend/features/student/presentation/screens/student_detail_screen.dart';
import 'package:sim_java_frontend/features/student/presentation/screens/student_form_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    
    // Initialize dependency injection
    await di.init();
    
    // Initialize Firebase Messaging
    await FirebaseMessagingService().initialize();
    
    // Initialize logger
    final logger = GetIt.I<LoggerUtils>();
    logger.i('App initialized');
    
    runApp(const MyApp());
  } catch (e, stackTrace) {
    // Handle any initialization errors
    debugPrint('Error during initialization: $e\n$stackTrace');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            // Add global BLoCs here
            BlocProvider(create: (_) => GetIt.I<DashboardBloc>()),
            BlocProvider(create: (_) => GetIt.I<StudentListBloc>()),
            BlocProvider(create: (_) => GetIt.I<StudentSearchBloc>()),
          ],
          child: MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light, // Or use theme cubit for dynamic theming
            routerConfig: appRouter,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('id', 'ID'),
              Locale('en', 'US'),
            ],
            builder: (context, child) {
              // Add any app-wide configurations here
              return GestureDetector(
                onTap: () {
                  // Dismiss keyboard when tapping outside of text fields
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus && 
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}

// Wrapper for student detail screen with its own BLoC
class StudentDetailScreenWrapper extends StatelessWidget {
  final String studentId;

  const StudentDetailScreenWrapper({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentDetailBloc(
        getStudent: GetIt.I(),
        deleteStudent: GetIt.I(),
      )..add(LoadStudent(studentId)),
      child: StudentDetailScreen(studentId: studentId),
    );
  }
}

// Wrapper for student form screen with its own BLoC
class StudentFormScreenWrapper extends StatelessWidget {
  final Student? student;

  const StudentFormScreenWrapper({
    super.key,
    this.student,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentFormBloc(
        createStudent: GetIt.I(),
        updateStudent: GetIt.I(),
        uploadPhoto: GetIt.I(),
        initialStudent: student,
      ),
      child: StudentFormScreen(student: student),
    );
  }
}

