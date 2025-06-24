import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final String id;
  final String nip;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final DateTime? birthDate;
  final String? gender;
  final String? photoUrl;
  final DateTime? joinDate;
  final String? status;
  final List<String>? subjects;
  final List<String>? classes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Teacher({
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

  Teacher copyWith({
    String? id,
    String? nip,
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    DateTime? birthDate,
    String? gender,
    String? photoUrl,
    DateTime? joinDate,
    String? status,
    List<String>? subjects,
    List<String>? classes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      nip: nip ?? this.nip,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      joinDate: joinDate ?? this.joinDate,
      status: status ?? this.status,
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
