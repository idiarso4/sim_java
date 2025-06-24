import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/usecases/get_upcoming_classes.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummary getDashboardSummary;
  final GetUpcomingClasses getUpcomingClasses;

  DashboardBloc({
    required this.getDashboardSummary,
    required this.getUpcomingClasses,
  }) : super(const DashboardState()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.status == DashboardStatus.loading) return;

    emit(state.copyWith(status: DashboardStatus.loading));

    final summaryResult = await getDashboardSummary(NoParams());
    final classesResult = await getUpcomingClasses(NoParams());

    if (summaryResult.isLeft() || classesResult.isLeft()) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        error: summaryResult.fold((l) => l, (r) => classesResult.fold((l) => l, (r) => null)),
      ));
      return;
    }

    final summary = summaryResult.getOrElse(() => throw UnimplementedError());
    final upcomingClasses = classesResult.getOrElse(() => throw UnimplementedError());

    emit(
      state.copyWith(
        status: DashboardStatus.success,
        summary: summary,
        upcomingClasses: upcomingClasses,
        hasReachedMax: upcomingClasses.length < 5, // Assuming we want to show max 5 upcoming classes
      ),
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    add(const LoadDashboard());
  }
}
