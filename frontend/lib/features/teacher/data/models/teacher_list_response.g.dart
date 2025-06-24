// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherListResponse _$TeacherListResponseFromJson(Map<String, dynamic> json) =>
    TeacherListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TeacherModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$TeacherListResponseToJson(
        TeacherListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
    };
