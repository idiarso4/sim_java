import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'models/teacher_form_inputs.dart';

class TeacherFormState extends Equatable {
  final Teacher teacher;
  final String? photoPath;
  final FormzStatus status;
  final String? errorMessage;
  final bool isEditMode;
  
  // Form inputs
  final Nip nip;
  final Name name;
  final Email email;
  final PhoneNumber phoneNumber;
  final FormDate birthDate;
  final FormDate joinDate;
  
  // Computed properties
  bool get isFormValid => Formz.validate([
        nip,
        name,
        email,
        phoneNumber,
        birthDate,
        joinDate,
      ]).isValidated;

  const TeacherFormState({
    required this.teacher,
    this.photoPath,
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.isEditMode = false,
    this.nip = const Nip.pure(),
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.birthDate = const FormDate.pure(),
    this.joinDate = const FormDate.pure(),
  });
  
  // Initial state factory
  factory TeacherFormState.fromTeacher(Teacher teacher, {bool isEditMode = false}) {
    return TeacherFormState(
      teacher: teacher,
      isEditMode: isEditMode,
      nip: Nip.dirty(teacher.nip),
      name: Name.dirty(teacher.name),
      email: Email.dirty(teacher.email ?? ''),
      phoneNumber: PhoneNumber.dirty(teacher.phoneNumber ?? ''),
      birthDate: FormDate.dirty(teacher.birthDate),
      joinDate: FormDate.dirty(teacher.joinDate),
    );
  }

  TeacherFormState copyWith({
    Teacher? teacher,
    String? photoPath,
    FormzStatus? status,
    String? errorMessage,
    bool? isEditMode,
    Nip? nip,
    Name? name,
    Email? email,
    PhoneNumber? phoneNumber,
    FormDate? birthDate,
    FormDate? joinDate,
  }) {
    return TeacherFormState(
      teacher: teacher ?? this.teacher,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditMode: isEditMode ?? this.isEditMode,
      nip: nip ?? this.nip,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  @override
  List<Object?> get props => [
        teacher,
        photoPath,
        status,
        errorMessage,
        isEditMode,
        nip,
        name,
        email,
        phoneNumber,
        birthDate,
        joinDate,
      ];

  bool get isLoading => status.isInProgress;
  bool get isSuccess => status.isSuccess;
  bool get isFailure => status.isFailure;
  bool get isInitial => status.isPure;
  bool get isSubmitting => status.isInProgress;
  bool get isSubmissionSuccess => status.isSuccess;
  bool get isSubmissionFailure => status.isFailure;
  bool get hasPhoto => photoPath != null || teacher.photoUrl != null;
  String? get photoUrl => photoPath ?? teacher.photoUrl;
}
