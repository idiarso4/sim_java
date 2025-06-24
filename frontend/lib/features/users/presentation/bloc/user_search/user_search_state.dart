part of 'user_search_bloc.dart';

enum UserSearchStatus { initial, loading, success, failure }

class UserSearchState extends Equatable {
  const UserSearchState({
    this.status = UserSearchStatus.initial,
    this.searchResults = const [],
    this.query = '',
    this.errorMessage,
  });

  final UserSearchStatus status;
  final List<User> searchResults;
  final String query;
  final String? errorMessage;

  bool get isInitial => status == UserSearchStatus.initial;
  bool get isLoading => status == UserSearchStatus.loading;
  bool get isSuccess => status == UserSearchStatus.success;
  bool get isFailure => status == UserSearchStatus.failure;

  UserSearchState copyWith({
    UserSearchStatus? status,
    List<User>? searchResults,
    String? query,
    String? errorMessage,
  }) {
    return UserSearchState(
      status: status ?? this.status,
      searchResults: searchResults ?? this.searchResults,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, searchResults, query, errorMessage];
}
