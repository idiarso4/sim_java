import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/exceptions.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/network/network_info.dart';
import 'package:sim_java_frontend/features/teacher/data/datasources/teacher_remote_data_source.dart';
import 'package:sim_java_frontend/features/teacher/data/models/teacher_model.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/repositories/teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TeacherRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Teacher>>> getTeachers({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final teachers = await remoteDataSource.getTeachers(
          page: page,
          limit: limit,
          searchQuery: searchQuery,
        );
        return Right(teachers.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Teacher>> getTeacher(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final teacher = await remoteDataSource.getTeacher(id);
        return Right(teacher.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Teacher>> createTeacher(Teacher teacher) async {
    if (await networkInfo.isConnected) {
      try {
        final teacherModel = TeacherModel.fromEntity(teacher);
        final createdTeacher = await remoteDataSource.createTeacher(teacherModel);
        return Right(createdTeacher.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Teacher>> updateTeacher(Teacher teacher) async {
    if (await networkInfo.isConnected) {
      try {
        final teacherModel = TeacherModel.fromEntity(teacher);
        final updatedTeacher = await remoteDataSource.updateTeacher(teacherModel);
        return Right(updatedTeacher.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeacher(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTeacher(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto({
    required String teacherId,
    required String filePath,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final photoUrl = await remoteDataSource.uploadPhoto(
          teacherId: teacherId,
          filePath: filePath,
        );
        return Right(photoUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Teacher>>> searchTeachers(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final teachers = await remoteDataSource.searchTeachers(query);
        return Right(teachers.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
