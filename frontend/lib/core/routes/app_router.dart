import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:sim_java_frontend/features/student/presentation/screens/student_detail_screen.dart';
import 'package:sim_java_frontend/features/student/presentation/screens/student_form_screen.dart';
import 'package:sim_java_frontend/features/student/presentation/screens/student_list_screen.dart';

class AppRoutes {
  // Base routes
  static const String home = '/';
  
  // Dashboard route
  static const String dashboard = '/dashboard';
  
  // Student routes
  static const String studentList = '/students';
  static const String studentDetail = 'student/:id';
  static const String addStudent = 'student/add';
  static const String editStudent = 'student/:id/edit';

  // Helper methods
  static String getStudentDetailPath(String id) => 'student/$id';
  static String getEditStudentPath(String id) => 'student/$id/edit';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    // Dashboard route
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),
    
    // Student routes
    GoRoute(
      path: AppRoutes.studentList,
      builder: (context, state) => const StudentListScreen(),
      routes: [
        GoRoute(
          path: AppRoutes.studentDetail,
          builder: (context, state) {
            final studentId = state.pathParameters['id']!;
            return StudentDetailScreen(studentId: studentId);
          },
        ),
        GoRoute(
          path: AppRoutes.addStudent,
          builder: (context, state) => const StudentFormScreen(),
        ),
        GoRoute(
          path: AppRoutes.editStudent,
          builder: (context, state) {
            final student = state.extra as Student;
            return StudentFormScreen(student: student);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);

// Extension for easy navigation
extension RouterExtension on BuildContext {
  // Navigation methods
  void goToDashboard() => appRouter.go(AppRoutes.dashboard);
  void goToStudentList() => appRouter.go(AppRoutes.studentList);
  void goToStudentDetail(String id) => appRouter.go('${AppRoutes.studentList}/${AppRoutes.getStudentDetailPath(id)}');
  void goToAddStudent() => appRouter.go('${AppRoutes.studentList}/${AppRoutes.addStudent}');
  void goToEditStudent(Student student) => appRouter.go('${AppRoutes.studentList}/${AppRoutes.getEditStudentPath(student.id)}');
  
  // Replacement navigation
  void replaceWithDashboard() => appRouter.replace(AppRoutes.dashboard);
  void replaceWithStudentList() => appRouter.replace(AppRoutes.studentList);
  void replaceWithStudentDetail(String id) => appRouter.replace('${AppRoutes.studentList}/${AppRoutes.getStudentDetailPath(id)}');
  
  // Pop with result
  void popWithResult<T>([T? result]) => appRouter.pop(result);
}
