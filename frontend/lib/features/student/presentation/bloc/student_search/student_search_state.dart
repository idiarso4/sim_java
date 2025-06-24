import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';

abstract class StudentSearchState extends Equatable {
  final String? query;
  
  const StudentSearchState({this.query});

  @override
  List<Object?> get props => [query];
}

class StudentSearchInitial extends StudentSearchState {
  const StudentSearchInitial() : super();
}

class StudentSearchLoading extends StudentSearchState {
  const StudentSearchLoading({required String query}) : super(query: query);
}

class StudentSearchSuccess extends StudentSearchState {
  final List<Student> students;
  
  const StudentSearchSuccess({
    required this.students,
    required String query,
  }) : super(query: query);
  
  @override
  List<Object?> get props => [students, query];
}

class StudentSearchEmpty extends StudentSearchState {
  const StudentSearchEmpty({required String query}) : super(query: query);
}

class StudentSearchError extends StudentSearchState {
  final String message;
  
  const StudentSearchError({
    required this.message,
    required String query,
  }) : super(query: query);
  
  @override
  List<Object?> get props => [message, query];
}
