import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';

abstract class TeacherListState extends Equatable {
  const TeacherListState();

  @override
  List<Object?> get props => [];
}

class TeacherListInitial extends TeacherListState {
  const TeacherListInitial();
}

class TeacherListLoading extends TeacherListState {
  final List<Teacher> oldTeachers;
  final bool isFirstPage;

  const TeacherListLoading(this.oldTeachers, {this.isFirstPage = false});

  @override
  List<Object?> get props => [oldTeachers, isFirstPage];
}

class TeacherListLoaded extends TeacherListState {
  final List<Teacher> teachers;
  final bool hasReachedMax;
  final int page;
  final String? searchQuery;

  const TeacherListLoaded({
    required this.teachers,
    this.hasReachedMax = false,
    this.page = 1,
    this.searchQuery,
  });

  TeacherListLoaded copyWith({
    List<Teacher>? teachers,
    bool? hasReachedMax,
    int? page,
    String? searchQuery,
  }) {
    return TeacherListLoaded(
      teachers: teachers ?? this.teachers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [teachers, hasReachedMax, page, searchQuery];
}

class TeacherListError extends TeacherListState {
  final String message;
  final List<Teacher>? oldTeachers;

  const TeacherListError(this.message, {this.oldTeachers});

  @override
  List<Object?> get props => [message, oldTeachers];
}
