import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecase/usecase.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/repositories/student_repository.dart';

class UpdateStudentParams {
  final String id;
  final String? nisn;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final String? gender;
  final String? className;
  final String? photoUrl;

  const UpdateStudentParams({
    required this.id,
    this.nisn,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.birthDate,
    this.gender,
    this.className,
    this.photoUrl,
  });
}

class UpdateStudent implements UseCase<Student, UpdateStudentParams> {
  final StudentRepository repository;

  UpdateStudent(this.repository);

  @override
  Future<Either<Failure, Student>> call(UpdateStudentParams params) async {
    return await repository.updateStudent(
      id: params.id,
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
