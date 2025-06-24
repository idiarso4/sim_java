import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';

abstract class TeacherSearchState extends Equatable {
  final String query;
  final List<Teacher> teachers;
  final bool hasReachedMax;

  const TeacherSearchState({
    this.query = '',
    this.teachers = const [],
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [query, teachers, hasReachedMax];
}

class TeacherSearchInitial extends TeacherSearchState {
  const TeacherSearchInitial();
}

class TeacherSearchLoading extends TeacherSearchState {
  const TeacherSearchLoading({
    required String query,
    required List<Teacher> teachers,
  }) : super(query: query, teachers: teachers);
  
  @override
  List<Object?> get props => [query, teachers];
}

class TeacherSearchSuccess extends TeacherSearchState {
  const TeacherSearchSuccess({
    required String query,
    required List<Teacher> teachers,
    bool hasReachedMax = false,
  }) : super(
          query: query,
          teachers: teachers,
          hasReachedMax: hasReachedMax,
        );
  
  @override
  List<Object?> get props => [query, teachers, hasReachedMax];
  
  TeacherSearchSuccess copyWith({
    String? query,
    List<Teacher>? teachers,
    bool? hasReachedMax,
  }) {
    return TeacherSearchSuccess(
      query: query ?? this.query,
      teachers: teachers ?? this.teachers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class TeacherSearchEmpty extends TeacherSearchState {
  final String message;

  const TeacherSearchEmpty({
    required this.message,
    required String query,
  }) : super(query: query);
  
  @override
  List<Object?> get props => [message, query];
}

class TeacherSearchError extends TeacherSearchState {
  final String message;

  const TeacherSearchError({
    required this.message,
    required String query,
    List<Teacher> teachers = const [],
  }) : super(query: query, teachers: teachers);
  
  @override
  List<Object?> get props => [message, query, teachers];
}
