import 'package:formz/formz.dart';

// Validation error messages
enum TeacherValidationError {
  empty('Field cannot be empty'),
  invalidNip('NIP must be at least 10 characters'),
  invalidEmail('Please enter a valid email'),
  invalidPhone('Please enter a valid phone number'),
  invalidDate('Please enter a valid date');

  final String message;
  const TeacherValidationError(this.message);
}

// NIP (Teacher ID) input
class Nip extends FormzInput<String, TeacherValidationError> {
  const Nip.pure() : super.pure('');
  const Nip.dirty([String value = '']) : super.dirty(value);

  @override
  TeacherValidationError? validator(String value) {
    if (value.isEmpty) return TeacherValidationError.empty;
    if (value.length < 10) return TeacherValidationError.invalidNip;
    return null;
  }
}

// Name input
class Name extends FormzInput<String, TeacherValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  TeacherValidationError? validator(String value) {
    if (value.isEmpty) return TeacherValidationError.empty;
    return null;
  }
}

// Email input
class Email extends FormzInput<String, TeacherValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  @override
  TeacherValidationError? validator(String value) {
    if (value.isNotEmpty && !_emailRegex.hasMatch(value)) {
      return TeacherValidationError.invalidEmail;
    }
    return null;
  }
}

// Phone number input
class PhoneNumber extends FormzInput<String, TeacherValidationError> {
  const PhoneNumber.pure() : super.pure('');
  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  static final _phoneRegex = RegExp(r'^[0-9+\-\s()]{10,20}$');

  @override
  TeacherValidationError? validator(String value) {
    if (value.isNotEmpty && !_phoneRegex.hasMatch(value)) {
      return TeacherValidationError.invalidPhone;
    }
    return null;
  }
}

// Date input (for birth date and join date)
class FormDate extends FormzInput<DateTime?, TeacherValidationError> {
  const FormDate.pure() : super.pure(null);
  const FormDate.dirty([DateTime? value]) : super.dirty(value);

  @override
  TeacherValidationError? validator(DateTime? value) {
    if (value != null && value.isAfter(DateTime.now())) {
      return TeacherValidationError.invalidDate;
    }
    return null;
  }
}
