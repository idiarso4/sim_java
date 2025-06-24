import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/repositories/teacher_repository.dart';

class SearchTeachers {
  final TeacherRepository repository;

  SearchTeachers(this.repository);

  Future<Either<Failure, List<Teacher>>> call(String query) async {
    return await repository.searchTeachers(query);
  }
}
