import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecase/usecase.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/repositories/student_repository.dart';

class GetStudentParams {
  final String id;

  const GetStudentParams(this.id);
}

class GetStudent implements UseCase<Student, GetStudentParams> {
  final StudentRepository repository;

  GetStudent(this.repository);

  @override
  Future<Either<Failure, Student>> call(GetStudentParams params) async {
    return await repository.getStudentById(params.id);
  }
}
