import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/repositories/teacher_repository.dart';

class DeleteTeacher {
  final TeacherRepository repository;

  DeleteTeacher(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTeacher(id);
  }
}
