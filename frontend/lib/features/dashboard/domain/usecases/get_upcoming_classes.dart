import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecases/usecase.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetUpcomingClasses implements UseCase<List<UpcomingClass>, NoParams> {
  final DashboardRepository repository;

  GetUpcomingClasses(this.repository);

  @override
  Future<Either<Failure, List<UpcomingClass>>> call(NoParams params) async {
    return await repository.getUpcomingClasses();
  }
}
