import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String nisn;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final String gender;
  final String className;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Student({
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
      
  Student copyWith({
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
    return Student(
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
}
