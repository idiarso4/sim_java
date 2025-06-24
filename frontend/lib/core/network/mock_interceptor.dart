import 'dart:convert';
import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  final bool isEnabled;
  final Duration delay;

  MockInterceptor({this.isEnabled = true, this.delay = const Duration(milliseconds: 500)});

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!isEnabled) {
      return handler.next(options);
    }

    // Simulate network delay
    await Future.delayed(delay);

    // Mock responses
    if (options.path.endsWith('/dashboard/summary')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'totalStudents': 245,
            'totalTeachers': 32,
            'todayAttendance': 87,
            'totalClasses': 15,
            'upcomingClasses': [
              {
                'id': '1',
                'className': 'XII IPA 1',
                'subject': 'Matematika',
                'time': '08:00 - 09:30',
                'teacherName': 'Budi Santoso',
              },
              {
                'id': '2',
                'className': 'XI IPS 2',
                'subject': 'Bahasa Inggris',
                'time': '10:00 - 11:30',
                'teacherName': 'Ani Lestari',
              },
            ],
          },
        ),
      );
    }

    if (options.path.endsWith('/dashboard/upcoming-classes')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'id': '1',
              'className': 'XII IPA 1',
              'subject': 'Matematika',
              'time': '08:00 - 09:30',
              'teacherName': 'Budi Santoso',
            },
            {
              'id': '2',
              'className': 'XI IPS 2',
              'subject': 'Bahasa Inggris',
              'time': '10:00 - 11:30',
              'teacherName': 'Ani Lestari',
            },
            {
              'id': '3',
              'className': 'X MIPA 3',
              'subject': 'Fisika',
              'time': '13:00 - 14:30',
              'teacherName': 'Dewi Kurnia',
            },
          ],
        ),
      );
    }

    // Let other requests pass through
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors if needed
    handler.next(err);
  }
}
