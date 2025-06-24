part of 'user_form_bloc.dart';

abstract class UserFormEvent extends Equatable {
  const UserFormEvent();

  @override
  List<Object> get props => [];
}

class UserFormSubmitted extends UserFormEvent {
  final Map<String, dynamic> formData;
  final String? userId;

  const UserFormSubmitted(this.formData, {this.userId});

  @override
  List<Object> get props => [formData, if (userId != null) userId!];
}

class UserFormReset extends UserFormEvent {}

class UserFormFieldChanged extends UserFormEvent {
  final String field;
  final dynamic value;

  const UserFormFieldChanged(this.field, this.value);

  @override
  List<Object> get props => [field, value];
}
