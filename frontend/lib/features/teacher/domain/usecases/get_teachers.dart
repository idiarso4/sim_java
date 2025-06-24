import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/repositories/teacher_repository.dart';

class GetTeachers {
  final TeacherRepository repository;

  GetTeachers(this.repository);

  Future<Either<Failure, List<Teacher>>> call({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    return await repository.getTeachers(
      page: page,
      limit: limit,
      searchQuery: searchQuery,
    );
  }
}
