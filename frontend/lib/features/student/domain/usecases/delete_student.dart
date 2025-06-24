import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecase/usecase.dart';
import 'package:sim_java_frontend/features/student/domain/repositories/student_repository.dart';

class DeleteStudentParams {
  final String id;

  const DeleteStudentParams(this.id);
}

class DeleteStudent implements UseCase<void, DeleteStudentParams> {
  final StudentRepository repository;

  DeleteStudent(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteStudentParams params) async {
    return await repository.deleteStudent(params.id);
  }
}
