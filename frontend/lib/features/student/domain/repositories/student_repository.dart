import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/student/data/models/student_model.dart';

abstract class StudentRepository {
  // Get all students with pagination
  Future<Either<Failure, List<StudentModel>>> getStudents({
    int page = 1,
    int limit = 10,
    String? searchQuery,
    String? sortBy,
    bool ascending = true,
  });

  // Get student by ID
  Future<Either<Failure, StudentModel>> getStudentById(String id);

  // Create a new student
  Future<Either<Failure, StudentModel>> createStudent({
    required String nisn,
    required String name,
    required String email,
    String? phone,
    String? address,
    DateTime? birthDate,
    required String gender,
    required String className,
    String? photoUrl,
  });

  // Update an existing student
  Future<Either<Failure, StudentModel>> updateStudent({
    required String id,
    String? nisn,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? birthDate,
    String? gender,
    String? className,
    String? photoUrl,
  });

  // Delete a student
  Future<Either<Failure, void>> deleteStudent(String id);

  // Upload student photo
  Future<Either<Failure, String>> uploadPhoto({
    required String studentId,
    required String filePath,
  });

  // Export students to CSV/Excel
  Future<Either<Failure, String>> exportStudents({
    String? searchQuery,
    String? sortBy,
    bool ascending = true,
  });
}
