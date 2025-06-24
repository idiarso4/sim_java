import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  const AppStarted();
}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String userId;

  const LoggedIn({required this.token, required this.userId});

  @override
  List<Object> get props => [token, userId];
}

class LoggedOut extends AuthenticationEvent {
  const LoggedOut();
}

class CheckAuthentication extends AuthenticationEvent {
  const CheckAuthentication();
}

class TokenExpired extends AuthenticationEvent {
  const TokenExpired();
}
