import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecase/usecase.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/repositories/student_repository.dart';

class GetStudentsParams {
  final int page;
  final int limit;
  final String? searchQuery;
  final String? sortBy;
  final bool ascending;

  const GetStudentsParams({
    this.page = 1,
    this.limit = 10,
    this.searchQuery,
    this.sortBy,
    this.ascending = true,
  });
}

class GetStudents implements UseCase<List<Student>, GetStudentsParams> {
  final StudentRepository repository;

  GetStudents(this.repository);

  @override
  Future<Either<Failure, List<Student>>> call(GetStudentsParams params) async {
    return await repository.getStudents(
      page: params.page,
      limit: params.limit,
      searchQuery: params.searchQuery,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}
