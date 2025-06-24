import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/repositories/teacher_repository.dart';

class UpdateTeacher {
  final TeacherRepository repository;

  UpdateTeacher(this.repository);

  Future<Either<Failure, Teacher>> call(Teacher teacher) async {
    return await repository.updateTeacher(teacher);
  }
}
