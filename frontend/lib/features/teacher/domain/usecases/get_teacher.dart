import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/repositories/teacher_repository.dart';

class GetTeacher {
  final TeacherRepository repository;

  GetTeacher(this.repository);

  Future<Either<Failure, Teacher>> call(String id) async {
    return await repository.getTeacher(id);
  }
}
