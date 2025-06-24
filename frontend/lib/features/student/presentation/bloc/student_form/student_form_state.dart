import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';

abstract class StudentFormState extends Equatable {
  final Student? student;
  final XFile? photo;
  
  const StudentFormState({
    this.student,
    this.photo,
  });
  
  bool get isEditMode => student != null;
  
  @override
  List<Object?> get props => [student, photo];
}

class StudentFormInitial extends StudentFormState {
  const StudentFormInitial({
    Student? student,
    XFile? photo,
  }) : super(
          student: student,
          photo: photo,
        );
}

class StudentFormSubmitting extends StudentFormState {
  const StudentFormSubmitting({
    required Student? student,
    XFile? photo,
  }) : super(
          student: student,
          photo: photo,
        );
  
  @override
  List<Object?> get props => [student, photo];
}

class StudentFormSuccess extends StudentFormState {
  final Student student;
  
  const StudentFormSuccess({
    required this.student,
  }) : super(student: student);
  
  @override
  List<Object?> get props => [student];
}

class StudentFormFailure extends StudentFormState {
  final String message;
  
  const StudentFormFailure({
    required this.message,
    Student? student,
    XFile? photo,
  }) : super(
          student: student,
          photo: photo,
        );
  
  @override
  List<Object?> get props => [message, student, photo];
}
