import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecases/usecase.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardSummary implements UseCase<DashboardSummary, NoParams> {
  final DashboardRepository repository;

  GetDashboardSummary(this.repository);

  @override
  Future<Either<Failure, DashboardSummary>> call(NoParams params) async {
    return await repository.getDashboardSummary();
  }
}
