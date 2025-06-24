import 'package:equatable/equatable.dart';

abstract class TeacherListEvent extends Equatable {
  const TeacherListEvent();

  @override
  List<Object?> get props => [];
}

class LoadTeachers extends TeacherListEvent {
  final bool refresh;
  final String? searchQuery;

  const LoadTeachers({this.refresh = false, this.searchQuery});

  @override
  List<Object?> get props => [refresh, searchQuery];
}

class RefreshTeachers extends TeacherListEvent {
  final String? searchQuery;

  const RefreshTeachers({this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

class SearchTeachers extends TeacherListEvent {
  final String query;

  const SearchTeachers(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends TeacherListEvent {
  const ClearSearch();
}
