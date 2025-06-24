// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
      id: json['id'] as String,
      nip: json['nip'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      birthDate: json['birth_date'] as String?,
      gender: json['gender'] as String?,
      photoUrl: json['photo_url'] as String?,
      joinDate: json['join_date'] as String?,
      status: json['status'] as String?,
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      classes:
          (json['classes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nip': instance.nip,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'address': instance.address,
      'birth_date': instance.birthDate,
      'gender': instance.gender,
      'photo_url': instance.photoUrl,
      'join_date': instance.joinDate,
      'status': instance.status,
      'subjects': instance.subjects,
      'classes': instance.classes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
