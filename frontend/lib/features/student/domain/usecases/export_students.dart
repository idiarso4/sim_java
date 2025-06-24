import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecase/usecase.dart';
import 'package:sim_java_frontend/features/student/domain/repositories/student_repository.dart';

class ExportStudentsParams {
  final String? searchQuery;
  final String? sortBy;
  final bool ascending;

  const ExportStudentsParams({
    this.searchQuery,
    this.sortBy,
    this.ascending = true,
  });
}

class ExportStudents implements UseCase<String, ExportStudentsParams> {
  final StudentRepository repository;

  ExportStudents(this.repository);

  @override
  Future<Either<Failure, String>> call(ExportStudentsParams params) async {
    return await repository.exportStudents(
      searchQuery: params.searchQuery,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}
