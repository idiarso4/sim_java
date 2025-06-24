part of 'user_form_bloc.dart';

enum UserFormStatus { initial, loading, success, failure }

class UserFormState extends Equatable {
  const UserFormState({
    this.status = UserFormStatus.initial,
    this.errorMessage,
    this.formData = const {},
    this.errors = const {},
  });

  final UserFormStatus status;
  final String? errorMessage;
  final Map<String, dynamic> formData;
  final Map<String, String> errors;

  bool get isSubmitting => status == UserFormStatus.loading;
  bool get isSuccess => status == UserFormStatus.success;
  bool get isFailure => status == UserFormStatus.failure;

  UserFormState copyWith({
    UserFormStatus? status,
    String? errorMessage,
    Map<String, dynamic>? formData,
    Map<String, String>? errors,
  }) {
    return UserFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      formData: formData ?? this.formData,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, formData, errors];
}
