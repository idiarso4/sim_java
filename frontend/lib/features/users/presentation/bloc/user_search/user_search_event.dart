part of 'user_search_bloc.dart';

abstract class UserSearchEvent extends Equatable {
  const UserSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchUsers extends UserSearchEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends UserSearchEvent {}
