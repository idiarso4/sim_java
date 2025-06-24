import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_upcoming_classes.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'dashboard_bloc_test.mocks.dart';

@GenerateMocks([GetDashboardSummary, GetUpcomingClasses])
void main() {
  late DashboardBloc dashboardBloc;
  late MockGetDashboardSummary mockGetDashboardSummary;
  late MockGetUpcomingClasses mockGetUpcomingClasses;

  final tDashboardSummary = DashboardSummary(
    totalStudents: 245,
    totalTeachers: 32,
    todayAttendance: 87,
    totalClasses: 15,
    upcomingClasses: [],
  );

  final tUpcomingClasses = [];

  setUp(() {
    mockGetDashboardSummary = MockGetDashboardSummary();
    mockGetUpcomingClasses = MockGetUpcomingClasses();
    dashboardBloc = DashboardBloc(
      getDashboardSummary: mockGetDashboardSummary,
      getUpcomingClasses: mockGetUpcomingClasses,
    );
  });

  group('DashboardBloc', () {
    test('initial state is DashboardState.initial()', () {
      // assert
      expect(dashboardBloc.state, equals(const DashboardState()));
    });

    blocTest<DashboardBloc, DashboardState>(
      'emits [loading, success] when LoadDashboard is added and succeeds',
      build: () {
        when(mockGetDashboardSummary(any))
            .thenAnswer((_) async => Right(tDashboardSummary));
        when(mockGetUpcomingClasses(any))
            .thenAnswer((_) async => Right(tUpcomingClasses));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(const LoadDashboard()),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        DashboardState(
          status: DashboardStatus.success,
          summary: tDashboardSummary,
          upcomingClasses: tUpcomingClasses,
        ),
      ],
      verify: (_) {
        verify(mockGetDashboardSummary(any)).called(1);
        verify(mockGetUpcomingClasses(any)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [loading, failure] when LoadDashboard is added and fails',
      build: () {
        when(mockGetDashboardSummary(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        when(mockGetUpcomingClasses(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(const LoadDashboard()),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        const DashboardState(
          status: DashboardStatus.failure,
          error: ServerFailure('Server error'),
        ),
      ],
      verify: (_) {
        verify(mockGetDashboardSummary(any)).called(1);
        verify(mockGetUpcomingClasses(any)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [loading, success] when RefreshDashboard is added and succeeds',
      build: () {
        when(mockGetDashboardSummary(any))
            .thenAnswer((_) async => Right(tDashboardSummary));
        when(mockGetUpcomingClasses(any))
            .thenAnswer((_) async => Right(tUpcomingClasses));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(const RefreshDashboard()),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        DashboardState(
          status: DashboardStatus.success,
          summary: tDashboardSummary,
          upcomingClasses: tUpcomingClasses,
        ),
      ],
      verify: (_) {
        verify(mockGetDashboardSummary(any)).called(1);
        verify(mockGetUpcomingClasses(any)).called(1);
      },
    );
  });
}
