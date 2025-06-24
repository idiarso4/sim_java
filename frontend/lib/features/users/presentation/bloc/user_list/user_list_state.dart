part of 'user_list_bloc.dart';

enum UserListStatus { initial, loading, success, failure }

class UserListState extends Equatable {
  const UserListState({
    this.status = UserListStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  final UserListStatus status;
  final List<User> users;
  final String? errorMessage;

  UserListState copyWith({
    UserListStatus? status,
    List<User>? users,
    String? errorMessage,
  }) {
    return UserListState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage];
}
