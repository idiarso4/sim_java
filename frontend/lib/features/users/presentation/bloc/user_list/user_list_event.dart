part of 'user_list_bloc.dart';

abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserListEvent {}

class DeleteUser extends UserListEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object> get props => [userId];
}
