import 'package:equatable/equatable.dart';

abstract class StudentListEvent extends Equatable {
  const StudentListEvent();

  @override
  List<Object?> get props => [];
}

class FetchStudents extends StudentListEvent {
  const FetchStudents();
}

class RefreshStudents extends StudentListEvent {
  const RefreshStudents();
}

class SearchStudents extends StudentListEvent {
  final String query;

  const SearchStudents(this.query);

  @override
  List<Object?> get props => [query];
}

class SortStudents extends StudentListEvent {
  final String? sortBy;
  final bool ascending;

  const SortStudents({
    this.sortBy,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [sortBy, ascending];
}
