import 'package:equatable/equatable.dart';

abstract class TeacherSearchEvent extends Equatable {
  const TeacherSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends TeacherSearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchCleared extends TeacherSearchEvent {
  const SearchCleared();
}

class SearchSubmitted extends TeacherSearchEvent {
  final String query;

  const SearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}
