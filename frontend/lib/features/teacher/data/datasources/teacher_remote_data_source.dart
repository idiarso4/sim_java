import 'package:dio/dio.dart';
import 'package:sim_java_frontend/core/error/exceptions.dart';
import 'package:sim_java_frontend/core/network/api_constants.dart';
import 'package:sim_java_frontend/features/teacher/data/models/teacher_list_response.dart';
import 'package:sim_java_frontend/features/teacher/data/models/teacher_model.dart';

abstract class TeacherRemoteDataSource {
  Future<List<TeacherModel>> getTeachers({
    int page,
    int limit,
    String? searchQuery,
  });

  Future<TeacherModel> getTeacher(String id);
  Future<TeacherModel> createTeacher(TeacherModel teacher);
  Future<TeacherModel> updateTeacher(TeacherModel teacher);
  Future<void> deleteTeacher(String id);
  Future<String> uploadPhoto({
    required String teacherId,
    required String filePath,
  });
  Future<List<TeacherModel>> searchTeachers(String query);
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final Dio dio;

  TeacherRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TeacherModel>> getTeachers({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.teachers}',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      if (response.statusCode == 200) {
        final responseData = TeacherListResponse.fromJson(response.data);
        return responseData.data;
      } else {
        throw ServerException(message: 'Failed to load teachers');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<TeacherModel> getTeacher(String id) async {
    try {
      final response = await dio.get('${ApiConstants.teachers}/$id');
      if (response.statusCode == 200) {
        return TeacherModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to load teacher');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<TeacherModel> createTeacher(TeacherModel teacher) async {
    try {
      final response = await dio.post(
        ApiConstants.teachers,
        data: teacher.toJson(),
      );
      if (response.statusCode == 201) {
        return TeacherModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to create teacher');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<TeacherModel> updateTeacher(TeacherModel teacher) async {
    try {
      final response = await dio.put(
        '${ApiConstants.teachers}/${teacher.id}',
        data: teacher.toJson(),
      );
      if (response.statusCode == 200) {
        return TeacherModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to update teacher');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteTeacher(String id) async {
    try {
      final response = await dio.delete('${ApiConstants.teachers}/$id');
      if (response.statusCode != 204) {
        throw ServerException(message: 'Failed to delete teacher');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<String> uploadPhoto({
    required String teacherId,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });

      final response = await dio.post(
        '${ApiConstants.teachers}/$teacherId/photo',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data']['photo_url'];
      } else {
        throw ServerException(message: 'Failed to upload photo');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<TeacherModel>> searchTeachers(String query) async {
    try {
      final response = await dio.get(
        '${ApiConstants.teachers}/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => TeacherModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to search teachers');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
