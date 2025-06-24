import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
}

class AuthenticationAuthenticated extends AuthenticationState {
  final String userId;
  final String token;

  const AuthenticationAuthenticated({
    required this.userId,
    required this.token,
  });

  @override
  List<Object> get props => [userId, token];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  const AuthenticationUnauthenticated();
}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  const AuthenticationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthenticationTokenExpired extends AuthenticationState {
  final String message;

  const AuthenticationTokenExpired({required this.message});

  @override
  List<Object> get props => [message];
}
