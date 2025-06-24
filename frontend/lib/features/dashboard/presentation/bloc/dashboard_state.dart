import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardSummary? summary;
  final List<UpcomingClass> upcomingClasses;
  final Failure? error;
  final bool hasReachedMax;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.summary,
    this.upcomingClasses = const [],
    this.error,
    this.hasReachedMax = false,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummary? summary,
    List<UpcomingClass>? upcomingClasses,
    Failure? error,
    bool? hasReachedMax,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      upcomingClasses: upcomingClasses ?? this.upcomingClasses,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        status,
        summary,
        upcomingClasses,
        error,
        hasReachedMax,
      ];

  bool get isInitial => status == DashboardStatus.initial;
  bool get isLoading => status == DashboardStatus.loading;
  bool get isSuccess => status == DashboardStatus.success;
  bool get isFailure => status == DashboardStatus.failure;
}
