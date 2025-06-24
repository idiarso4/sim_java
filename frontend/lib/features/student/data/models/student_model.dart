import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel extends Equatable {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'nisn')
  final String nisn;
  
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'email')
  final String email;
  
  @JsonKey(name: 'phone')
  final String? phone;
  
  @JsonKey(name: 'address')
  final String? address;
  
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  
  @JsonKey(name: 'gender')
  final String gender;
  
  @JsonKey(name: 'class_name')
  final String className;
  
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const StudentModel({
    required this.id,
    required this.nisn,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.birthDate,
    required this.gender,
    required this.className,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => 
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
  
  StudentModel copyWith({
    String? id,
    String? nisn,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? birthDate,
    String? gender,
    String? className,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      nisn: nisn ?? this.nisn,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      className: className ?? this.className,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nisn,
        name,
        email,
        phone,
        address,
        birthDate,
        gender,
        className,
        photoUrl,
        createdAt,
        updatedAt,
      ];
}

// Extension to convert to/from entity if using clean architecture
// extension StudentModelX on StudentModel {
//   Student toEntity() {
//     return Student(
//       id: id,
//       nisn: nisn,
//       name: name,
//       email: email,
//       phone: phone,
//       address: address,
//       birthDate: birthDate,
//       gender: gender,
//       className: className,
//       photoUrl: photoUrl,
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//     );
//   }
// }
