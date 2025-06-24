import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class StudentFormEvent extends Equatable {
  const StudentFormEvent();

  @override
  List<Object?> get props => [];
}

class FormSubmitted extends StudentFormEvent {
  final String nisn;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final String gender;
  final String className;

  const FormSubmitted({
    required this.nisn,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.birthDate,
    required this.gender,
    required this.className,
  });

  @override
  List<Object?> get props => [
        nisn,
        name,
        email,
        phone,
        address,
        birthDate,
        gender,
        className,
      ];
}

class PhotoChanged extends StudentFormEvent {
  final XFile photo;

  const PhotoChanged(this.photo);

  @override
  List<Object?> get props => [photo];
}

class PhotoRemoved extends StudentFormEvent {
  const PhotoRemoved();
}

class FormReset extends StudentFormEvent {
  const FormReset();
}
