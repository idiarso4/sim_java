import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/users/domain/entities/user.dart';
import 'package:frontend/features/users/domain/usecases/get_users.dart';
import 'package:frontend/features/users/domain/usecases/delete_user.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetUsers getUsers;
  final DeleteUser deleteUser;

  UserListBloc({
    required this.getUsers,
    required this.deleteUser,
  }) : super(const UserListState()) {
    on<LoadUsers>(_onLoadUsers);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(state.copyWith(status: UserListStatus.loading));
    
    final result = await getUsers();
    
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (users) => emit(
        state.copyWith(
          status: UserListStatus.success,
          users: users,
        ),
      ),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<UserListState> emit,
  ) async {
    final result = await deleteUser(Params(id: event.userId));
    
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadUsers()),
    );
  }
}
