import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/users/domain/entities/user.dart';
import 'package:frontend/features/users/domain/usecases/get_user.dart';

part of 'user_detail_bloc.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final GetUser getUser;

  UserDetailBloc({required this.getUser}) : super(const UserDetailState()) {
    on<LoadUserDetail>(_onLoadUserDetail);
  }

  Future<void> _onLoadUserDetail(
    LoadUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(state.copyWith(status: UserDetailStatus.loading));

    final result = await getUser(Params(id: event.userId));

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: UserDetailStatus.success,
          user: user,
        ),
      ),
    );
  }
}
