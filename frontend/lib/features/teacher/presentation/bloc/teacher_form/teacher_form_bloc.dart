import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/create_teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/get_teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/update_teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/upload_teacher_photo.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_form/models/teacher_form_inputs.dart';

part 'teacher_form_event.dart';
part 'teacher_form_state.dart';

class TeacherFormBloc extends Bloc<TeacherFormEvent, TeacherFormState> {
  final CreateTeacher createTeacher;
  final UpdateTeacher updateTeacher;
  final GetTeacher getTeacher;
  final UploadTeacherPhoto uploadPhoto;

  TeacherFormBloc({
    required this.createTeacher,
    required this.updateTeacher,
    required this.getTeacher,
    required this.uploadPhoto,
    Teacher? initialTeacher,
  }) : super(
          initialTeacher != null
              ? TeacherFormState.fromTeacher(initialTeacher, isEditMode: true)
              : TeacherFormState(
                  teacher: const Teacher(
                    id: '',
                    nip: '',
                    name: '',
                  ),
                  isEditMode: false,
                ),
        ) {
    // Form field events
    on<NipChanged>(_onNipChanged);
    on<NameChanged>(_onNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<BirthDateChanged>(_onBirthDateChanged);
    on<JoinDateChanged>(_onJoinDateChanged);
    
    // Form actions
    on<TeacherFormSubmitted>(_onSubmitted);
    on<TeacherPhotoChanged>(_onPhotoChanged);
    on<TeacherPhotoRemoved>(_onPhotoRemoved);
    on<TeacherFormReset>(_onReset);
    on<TeacherFormLoad>(_onLoad);
  }

  Future<void> _onLoad(
    TeacherFormLoad event,
    Emitter<TeacherFormState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    
    final failureOrTeacher = await getTeacher(event.teacherId);
    
    await failureOrTeacher.fold(
      (failure) async* {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (teacher) async* {
        emit(TeacherFormState.fromTeacher(teacher, isEditMode: true));
      },
    );
  }

  Future<void> _onSubmitted(
    TeacherFormSubmitted event,
    Emitter<TeacherFormState> emit,
  ) async {
    // Validate all fields
    final nip = Nip.dirty(state.nip.value);
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    final birthDate = FormDate.dirty(state.birthDate.value);
    final joinDate = FormDate.dirty(state.joinDate.value);

    final isFormValid = Formz.validate([
      nip,
      name,
      email,
      phoneNumber,
      birthDate,
      joinDate,
    ]).isValidated;

    // Update state with validation results
    emit(state.copyWith(
      nip: nip,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
      joinDate: joinDate,
      status: isFormValid ? FormzStatus.valid : FormzStatus.invalid,
    ));

    if (!isFormValid) {
      return;
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      String? photoUrl = state.photoPath;
      
      // Upload new photo if it's a local file path
      if (!photoUrl.startsWith('http')) {
        final uploadResult = await uploadPhoto(
          teacherId: state.teacher.id,
          filePath: photoUrl,
        );
        
        photoUrl = await uploadResult.fold(
          (failure) => throw failure,
          (url) => url,
        );
      }

      // Create updated teacher with form values
      final updatedTeacher = state.teacher.copyWith(
        nip: nip.value,
        name: name.value,
        email: email.value.isNotEmpty ? email.value : null,
        phoneNumber: phoneNumber.value.isNotEmpty ? phoneNumber.value : null,
        birthDate: birthDate.value,
        joinDate: joinDate.value,
        photoUrl: photoUrl ?? state.teacher.photoUrl,
      );

      // Create or update teacher
      final result = event.isEditing
          ? await updateTeacher(updatedTeacher)
          : await createTeacher(updatedTeacher);

      await result.fold(
        (failure) async* {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: _mapFailureToMessage(failure),
          ));
        },
        (teacher) async* {
          emit(TeacherFormState.fromTeacher(
            teacher,
            isEditMode: event.isEditing,
          ).copyWith(
            status: FormzStatus.submissionSuccess,
          ));
        },
      );
    } on Failure catch (failure) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: _mapFailureToMessage(failure),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'An unexpected error occurred',
      ));
    }
  }

  // Form field update handlers
  void _onNipChanged(
    NipChanged event,
    Emitter<TeacherFormState> emit,
  ) {
    final nip = Nip.dirty(event.nip);
    emit(state.copyWith(
      nip: nip,
      status: Formz.validate([
        nip,
        state.name,
        state.email,
        state.phoneNumber,
        state.birthDate,
        state.joinDate,
      ]),
    ));
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<TeacherFormState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([
        state.nip,
        name,
        state.email,
        state.phoneNumber,
        state.birthDate,
        state.joinDate,
      ]),
    ));
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<TeacherFormState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.nip,
        state.name,
        email,
        state.phoneNumber,
        state.birthDate,
        state.joinDate,
      ]),
    ));
  }

  void _onPhoneNumberChanged(
    PhoneNumberChanged event,
    Emitter<TeacherFormState> emit,
  ) {
    final phoneNumber = PhoneNumber.dirty(event.phoneNumber);
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      status: Formz.validate([
        state.nip,
        state.name,
        state.email,
        phoneNumber,
        state.birthDate,
        state.joinDate,
      ]),
    ));
  }

  void _onBirthDateChanged(
    BirthDateChanged event,
    Emitter<TeacherFormState> emit,
  ) {
    final birthDate = FormDate.dirty(event.birthDate);
    emit(state.copyWith(
      birthDate: birthDate,
      status: Formz.validate([
        state.nip,
        state.name,
        state.email,
        state.phoneNumber,
        birthDate,
        state.joinDate,
      ]),
    ));
  }

  void _onJoinDateChanged(
    JoinDateChanged event,
    Emitter<TeacherFormState> emit,
  ) {
    final joinDate = FormDate.dirty(event.joinDate);
    emit(state.copyWith(
      joinDate: joinDate,
      status: Formz.validate([
        state.nip,
        state.name,
        state.email,
        state.phoneNumber,
        state.birthDate,
        joinDate,
      ]),
    ));
  }

  void _onPhotoChanged(
    TeacherPhotoChanged event,
    Emitter<TeacherFormState> emit,
  ) {
    emit(state.copyWith(photoPath: event.photoPath));
  }

  void _onPhotoRemoved(
    TeacherPhotoRemoved event,
    Emitter<TeacherFormState> emit,
  ) {
    emit(state.copyWith(
      photoPath: null,
      teacher: state.teacher.copyWith(photoUrl: null),
    ));
  }

  void _onReset(
    TeacherFormReset event,
    Emitter<TeacherFormState> emit,
  ) {
    emit(TeacherFormState(
      teacher: const Teacher(id: '', nip: '', name: ''),
      isEditMode: state.isEditMode,
      status: FormzStatus.pure,
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return 'No internet connection';
      case ValidationFailure:
        return (failure as ValidationFailure).message;
      case UnauthorizedFailure:
        return 'You are not authorized to perform this action';
      case NotFoundFailure:
        return 'Teacher not found';
      default:
        return 'An unexpected error occurred';
    }
  }
}
