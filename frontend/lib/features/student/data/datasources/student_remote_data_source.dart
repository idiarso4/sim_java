import 'package:dio/dio.dart';
import 'package:sim_java_frontend/core/error/exceptions.dart';
import 'package:sim_java_frontend/core/network/api_utils.dart';
import 'package:sim_java_frontend/features/student/data/models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<List<StudentModel>> getStudents({
    int page,
    int limit,
    String? searchQuery,
    String? sortBy,
    bool ascending,
  });

  Future<StudentModel> getStudentById(String id);
  
  Future<StudentModel> createStudent(StudentModel student);
  
  Future<StudentModel> updateStudent({
    required String id,
    required StudentModel student,
  });
  
  Future<void> deleteStudent(String id);
  
  Future<String> uploadPhoto({
    required String studentId,
    required String filePath,
  });
  
  Future<String> exportStudents({
    String? searchQuery,
    String? sortBy,
    bool ascending,
  });
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final Dio dio;
  
  StudentRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<StudentModel>> getStudents({
    int page = 1,
    int limit = 10,
    String? searchQuery,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      final params = {
        'page': page,
        'limit': limit,
        if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
        if (sortBy != null) 'sort_by': sortBy,
        'order': ascending ? 'asc' : 'desc',
      };
      
      final response = await ApiUtils(dio: dio).get(
        '/students',
        queryParameters: params,
      );
      
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => StudentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to load students');
    }
  }

  @override
  Future<StudentModel> getStudentById(String id) async {
    try {
      final response = await ApiUtils(dio: dio).get('/students/$id');
      return StudentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to load student');
    }
  }

  @override
  Future<StudentModel> createStudent(StudentModel student) async {
    try {
      final response = await ApiUtils(dio: dio).post(
        '/students',
        data: student.toJson(),
      );
      return StudentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to create student');
    }
  }

  @override
  Future<StudentModel> updateStudent({
    required String id,
    required StudentModel student,
  }) async {
    try {
      final response = await ApiUtils(dio: dio).put(
        '/students/$id',
        data: student.toJson(),
      );
      return StudentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to update student');
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    try {
      await ApiUtils(dio: dio).delete('/students/$id');
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to delete student');
    }
  }

  @override
  Future<String> uploadPhoto({
    required String studentId,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });
      
      final response = await ApiUtils(dio: dio).post(
        '/students/$studentId/photo',
        data: formData,
      );
      
      return response.data['data']['photo_url'];
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to upload photo');
    }
  }

  @override
  Future<String> exportStudents({
    String? searchQuery,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      final params = {
        if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
        if (sortBy != null) 'sort_by': sortBy,
        'order': ascending ? 'asc' : 'desc',
        'export': 'true',
      };
      
      final response = await ApiUtils(dio: dio).get(
        '/students/export',
        queryParameters: params,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      
      // Save file locally and return the path
      // This is a simplified example - you might want to use a proper file saver
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/students_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(response.data);
      
      return file.path;
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to export students');
    }
  }
  
  // Helper method to get temporary directory
  Future<Directory> getTemporaryDirectory() async {
    // In a real app, you might want to use path_provider
    // return await getTemporaryDirectory();
    return Directory.systemTemp;
  }
}
