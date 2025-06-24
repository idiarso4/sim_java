import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecase/usecase.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/repositories/student_repository.dart';

class CreateStudentParams {
  final String nisn;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final String gender;
  final String className;
  final String? photoUrl;

  const CreateStudentParams({
    required this.nisn,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.birthDate,
    required this.gender,
    required this.className,
    this.photoUrl,
  });
}

class CreateStudent implements UseCase<Student, CreateStudentParams> {
  final StudentRepository repository;

  CreateStudent(this.repository);

  @override
  Future<Either<Failure, Student>> call(CreateStudentParams params) async {
    return await repository.createStudent(
      nisn: params.nisn,
      name: params.name,
      email: params.email,
      phone: params.phone,
      address: params.address,
      birthDate: params.birthDate,
      gender: params.gender,
      className: params.className,
      photoUrl: params.photoUrl,
    );
  }
}
