import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';

abstract class StudentDetailState extends Equatable {
  final Student? student;
  
  const StudentDetailState({this.student});

  @override
  List<Object?> get props => [student];
}

class StudentDetailInitial extends StudentDetailState {
  const StudentDetailInitial() : super();
}

class StudentDetailLoading extends StudentDetailState {
  const StudentDetailLoading({Student? student}) : super(student: student);
}

class StudentDetailLoaded extends StudentDetailState {
  const StudentDetailLoaded({required Student student}) : super(student: student);
  
  @override
  List<Object?> get props => [student];
}

class StudentDetailError extends StudentDetailState {
  final String message;
  
  const StudentDetailError({
    required this.message,
    Student? student,
  }) : super(student: student);
  
  @override
  List<Object?> get props => [message, student];
}

class StudentDetailDeleted extends StudentDetailState {
  const StudentDetailDeleted();
  
  @override
  List<Object?> get props => [];
}
