import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/core/utils/logger.dart';
import 'package:sim_java_frontend/presentation/bloc/authentication/authentication_event.dart';
import 'package:sim_java_frontend/presentation/bloc/authentication/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<CheckAuthentication>(_onCheckAuthentication);
    on<TokenExpired>(_onTokenExpired);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationLoading());
      
      // Check if user is already authenticated
      final isAuthenticated = await _checkIfUserIsAuthenticated();
      
      if (isAuthenticated) {
        final token = await _getToken();
        final userId = await _getUserId();
        
        if (token != null && userId != null) {
          emit(AuthenticationAuthenticated(userId: userId, token: token));
        } else {
          await _clearAuthData();
          emit(const AuthenticationUnauthenticated());
        }
      } else {
        emit(const AuthenticationUnauthenticated());
      }
    } catch (e) {
      AppLogger.e('Error in _onAppStarted', e);
      emit(AuthenticationFailure(message: 'Failed to start authentication'));
    }
  }

  Future<void> _onLoggedIn(
    LoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationLoading());
      
      // Save token and user ID to secure storage
      await _saveToken(event.token);
      await _saveUserId(event.userId);
      
      emit(AuthenticationAuthenticated(
        userId: event.userId,
        token: event.token,
      ));
    } catch (e) {
      AppLogger.e('Error in _onLoggedIn', e);
      emit(AuthenticationFailure(message: 'Failed to log in'));
    }
  }

  Future<void> _onLoggedOut(
    LoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationLoading());
      
      // Clear all authentication data
      await _clearAuthData();
      
      emit(const AuthenticationUnauthenticated());
    } catch (e) {
      AppLogger.e('Error in _onLoggedOut', e);
      emit(AuthenticationFailure(message: 'Failed to log out'));
    }
  }

  Future<void> _onCheckAuthentication(
    CheckAuthentication event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final isAuthenticated = await _checkIfUserIsAuthenticated();
      
      if (isAuthenticated) {
        final token = await _getToken();
        final userId = await _getUserId();
        
        if (token != null && userId != null) {
          emit(AuthenticationAuthenticated(userId: userId, token: token));
        } else {
          await _clearAuthData();
          emit(const AuthenticationUnauthenticated());
        }
      } else {
        emit(const AuthenticationUnauthenticated());
      }
    } catch (e) {
      AppLogger.e('Error in _onCheckAuthentication', e);
      emit(const AuthenticationUnauthenticated());
    }
  }

  Future<void> _onTokenExpired(
    TokenExpired event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _clearAuthData();
      emit(const AuthenticationTokenExpired(
        message: 'Your session has expired. Please log in again.',
      ));
    } catch (e) {
      AppLogger.e('Error in _onTokenExpired', e);
      emit(const AuthenticationUnauthenticated());
    }
  }

  // Helper methods for authentication
  Future<bool> _checkIfUserIsAuthenticated() async {
    // TODO: Implement actual token check from secure storage
    // For now, return false
    return false;
  }

  Future<String?> _getToken() async {
    // TODO: Implement getting token from secure storage
    return null;
  }

  Future<String?> _getUserId() async {
    // TODO: Implement getting user ID from secure storage
    return null;
  }

  Future<void> _saveToken(String token) async {
    // TODO: Implement saving token to secure storage
  }

  Future<void> _saveUserId(String userId) async {
    // TODO: Implement saving user ID to secure storage
  }

  Future<void> _clearAuthData() async {
    // TODO: Implement clearing all authentication data from secure storage
  }
}
