import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';

abstract class StudentListState extends Equatable {
  const StudentListState();

  @override
  List<Object?> get props => [];
}

class StudentListInitial extends StudentListState {
  const StudentListInitial();
}

class StudentListLoading extends StudentListState {
  const StudentListLoading();
}

class StudentListLoaded extends StudentListState {
  final List<Student> students;
  final bool hasReachedMax;

  const StudentListLoaded({
    required this.students,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [students, hasReachedMax];
  
  StudentListLoaded copyWith({
    List<Student>? students,
    bool? hasReachedMax,
  }) {
    return StudentListLoaded(
      students: students ?? this.students,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class StudentListEmpty extends StudentListState {
  const StudentListEmpty();
}

class StudentListError extends StudentListState {
  final String message;
  final List<Student>? students;

  const StudentListError({
    required this.message,
    this.students,
  });

  @override
  List<Object?> get props => [message, students];
  
  bool get hasStudents => students != null && students!.isNotEmpty;
}
