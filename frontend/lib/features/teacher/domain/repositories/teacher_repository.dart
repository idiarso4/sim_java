import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';

abstract class TeacherRepository {
  // Get all teachers with pagination
  Future<Either<Failure, List<Teacher>>> getTeachers({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  });

  // Get a single teacher by ID
  Future<Either<Failure, Teacher>> getTeacher(String id);

  // Create a new teacher
  Future<Either<Failure, Teacher>> createTeacher(Teacher teacher);

  // Update an existing teacher
  Future<Either<Failure, Teacher>> updateTeacher(Teacher teacher);

  // Delete a teacher
  Future<Either<Failure, void>> deleteTeacher(String id);

  // Upload teacher photo
  Future<Either<Failure, String>> uploadPhoto({
    required String teacherId,
    required String filePath,
  });

  // Search teachers by query
  Future<Either<Failure, List<Teacher>>> searchTeachers(String query);
}
