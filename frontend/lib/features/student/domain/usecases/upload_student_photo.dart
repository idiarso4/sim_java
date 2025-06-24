import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/usecase/usecase.dart';
import 'package:sim_java_frontend/features/student/domain/repositories/student_repository.dart';

class UploadStudentPhotoParams {
  final String studentId;
  final String filePath;

  const UploadStudentPhotoParams({
    required this.studentId,
    required this.filePath,
  });
}

class UploadStudentPhoto implements UseCase<String, UploadStudentPhotoParams> {
  final StudentRepository repository;

  UploadStudentPhoto(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadStudentPhotoParams params) async {
    return await repository.uploadPhoto(
      studentId: params.studentId,
      filePath: params.filePath,
    );
  }
}
