import 'package:equatable/equatable.dart';

abstract class StudentDetailEvent extends Equatable {
  const StudentDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudent extends StudentDetailEvent {
  final String studentId;

  const LoadStudent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class RefreshStudent extends StudentDetailEvent {
  const RefreshStudent();
}

class DeleteStudentEvent extends StudentDetailEvent {
  const DeleteStudentEvent();
}
