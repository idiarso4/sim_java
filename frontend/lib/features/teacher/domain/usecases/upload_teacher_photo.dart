import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/repositories/teacher_repository.dart';

class UploadTeacherPhoto {
  final TeacherRepository repository;

  UploadTeacherPhoto(this.repository);

  Future<Either<Failure, String>> call({
    required String teacherId,
    required String filePath,
  }) async {
    return await repository.uploadPhoto(
      teacherId: teacherId,
      filePath: filePath,
    );
  }
}
