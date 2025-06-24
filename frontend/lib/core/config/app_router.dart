import 'package:flutter/material.dart';
import 'package:sim_java_frontend/presentation/pages/auth/login_page.dart';
import 'package:sim_java_frontend/presentation/pages/auth/register_page.dart';
import 'package:sim_java_frontend/presentation/pages/auth/forgot_password_page.dart';
import 'package:sim_java_frontend/presentation/pages/dashboard/dashboard_page.dart';
import 'package:sim_java_frontend/presentation/pages/splash/splash_page.dart';
import 'package:sim_java_frontend/presentation/pages/not_found/not_found_page.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String notFound = '/not-found';

  // Generate routes
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }

  // Navigation methods
  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
  }

  static void goToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, dashboard, (route) => false);
  }

  static void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, register);
  }

  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, forgotPassword);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
