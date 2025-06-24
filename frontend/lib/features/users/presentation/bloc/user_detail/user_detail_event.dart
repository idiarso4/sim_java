part of 'user_detail_bloc.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadUserDetail extends UserDetailEvent {
  final String userId;

  const LoadUserDetail(this.userId);

  @override
  List<Object> get props => [userId];
}
