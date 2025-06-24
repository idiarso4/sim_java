import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';

part 'teacher_model.g.dart';

@JsonSerializable()
class TeacherModel extends Equatable {
  final String id;
  final String nip;
  final String name;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? address;
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  final String? gender;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @JsonKey(name: 'join_date')
  final String? joinDate;
  final String? status;
  final List<String>? subjects;
  final List<String>? classes;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const TeacherModel({
    required this.id,
    required this.nip,
    required this.name,
    this.email,
    this.phoneNumber,
    this.address,
    this.birthDate,
    this.gender,
    this.photoUrl,
    this.joinDate,
    this.status,
    this.subjects,
    this.classes,
    this.createdAt,
    this.updatedAt,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);

  Teacher toEntity() {
    return Teacher(
      id: id,
      nip: nip,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      birthDate: birthDate != null ? DateTime.parse(birthDate!) : null,
      gender: gender,
      photoUrl: photoUrl,
      joinDate: joinDate != null ? DateTime.parse(joinDate!) : null,
      status: status,
      subjects: subjects,
      classes: classes,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory TeacherModel.fromEntity(Teacher teacher) {
    return TeacherModel(
      id: teacher.id,
      nip: teacher.nip,
      name: teacher.name,
      email: teacher.email,
      phoneNumber: teacher.phoneNumber,
      address: teacher.address,
      birthDate: teacher.birthDate?.toIso8601String(),
      gender: teacher.gender,
      photoUrl: teacher.photoUrl,
      joinDate: teacher.joinDate?.toIso8601String(),
      status: teacher.status,
      subjects: teacher.subjects,
      classes: teacher.classes,
      createdAt: teacher.createdAt?.toIso8601String(),
      updatedAt: teacher.updatedAt?.toIso8601String(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        nip,
        name,
        email,
        phoneNumber,
        address,
        birthDate,
        gender,
        photoUrl,
        joinDate,
        status,
        subjects,
        classes,
        createdAt,
        updatedAt,
      ];
}
