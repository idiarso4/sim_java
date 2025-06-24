import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/utils/logger_utils.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/create_student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/update_student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/upload_student_photo.dart';

part 'student_form_event.dart';
part 'student_form_state.dart';

class StudentFormBloc extends Bloc<StudentFormEvent, StudentFormState> {
  final CreateStudent createStudent;
  final UpdateStudent updateStudent;
  final UploadStudentPhoto uploadPhoto;
  final _logger = LoggerUtils();

  StudentFormBloc({
    required this.createStudent,
    required this.updateStudent,
    required this.uploadPhoto,
    Student? initialStudent,
  }) : super(StudentFormInitial(initialStudent: initialStudent)) {
    on<FormSubmitted>(_onFormSubmitted);
    on<PhotoChanged>(_onPhotoChanged);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<FormReset>(_onFormReset);
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<StudentFormState> emit,
  ) async {
    emit(StudentFormSubmitting(
      student: state.student,
      photo: state.photo,
    ));

    try {
      // If there's a new photo to upload
      String? photoUrl = state.student?.photoUrl;
      final photoFile = state.photo;
      
      if (photoFile != null) {
        final uploadResult = await uploadPhoto(UploadStudentPhotoParams(
          studentId: state.student?.id ?? 'new',
          filePath: photoFile.path,
        ));
        
        uploadResult.fold(
          (failure) => throw failure,
          (url) => photoUrl = url,
        );
      }

      // Create or update student
      if (state.isEditMode) {
        // Update existing student
        final result = await updateStudent(UpdateStudentParams(
          id: state.student!.id,
          nisn: event.nisn,
          name: event.name,
          email: event.email,
          phone: event.phone,
          address: event.address,
          birthDate: event.birthDate,
          gender: event.gender,
          className: event.className,
          photoUrl: photoUrl,
        ));

        await result.fold(
          (failure) => throw failure,
          (student) => emit(StudentFormSuccess(student: student)),
        );
      } else {
        // Create new student
        final result = await createStudent(CreateStudentParams(
          nisn: event.nisn,
          name: event.name,
          email: event.email,
          phone: event.phone,
          address: event.address,
          birthDate: event.birthDate,
          gender: event.gender,
          className: event.className,
          photoUrl: photoUrl,
        ));

        await result.fold(
          (failure) => throw failure,
          (student) => emit(StudentFormSuccess(student: student)),
        );
      }
    } on Failure catch (failure) {
      _logger.e('Form submission failed', failure);
      emit(StudentFormFailure(
        message: _mapFailureToMessage(failure),
        student: state.student,
        photo: state.photo,
      ));
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in form submission', e, stackTrace);
      emit(StudentFormFailure(
        message: 'An unexpected error occurred',
        student: state.student,
        photo: state.photo,
      ));
    }
  }

  void _onPhotoChanged(
    PhotoChanged event,
    Emitter<StudentFormState> emit,
  ) {
    emit(StudentFormInitial(
      student: state.student,
      photo: event.photo,
    ));
  }

  void _onPhotoRemoved(
    PhotoRemoved event,
    Emitter<StudentFormState> emit,
  ) {
    emit(StudentFormInitial(
      student: state.student,
      photo: null,
    ));
  }

  void _onFormReset(
    FormReset event,
    Emitter<StudentFormState> emit,
  ) {
    emit(StudentFormInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) {
      // Join all validation errors into a single message
      return failure.errors?.entries
              .map((e) => '${e.key}: ${e.value}')
              .join('\n') ??
          'Please check your input and try again.';
    }
    
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'No internet connection';
      case UnauthorizedFailure:
        return 'Session expired. Please login again.';
      case ForbiddenFailure:
        return 'You do not have permission to perform this action';
      case NotFoundFailure:
        return 'Resource not found';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
