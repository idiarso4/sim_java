import 'package:equatable/equatable.dart';

abstract class StudentSearchEvent extends Equatable {
  const StudentSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends StudentSearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchCleared extends StudentSearchEvent {
  const SearchCleared();
}
