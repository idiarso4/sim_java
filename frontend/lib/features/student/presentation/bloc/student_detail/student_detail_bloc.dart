import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/delete_student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/get_student.dart';

part 'student_detail_event.dart';
part 'student_detail_state.dart';

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  final GetStudent getStudent;
  final DeleteStudent deleteStudent;

  StudentDetailBloc({
    required this.getStudent,
    required this.deleteStudent,
  }) : super(StudentDetailInitial()) {
    on<LoadStudent>(_onLoadStudent);
    on<RefreshStudent>(_onRefreshStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
  }

  Future<void> _onLoadStudent(
    LoadStudent event,
    Emitter<StudentDetailState> emit,
  ) async {
    emit(StudentDetailLoading());
    
    final result = await getStudent(GetStudentParams(event.studentId));
    
    result.fold(
      (failure) => emit(StudentDetailError(message: _mapFailureToMessage(failure))),
      (student) => emit(StudentDetailLoaded(student: student)),
    );
  }

  Future<void> _onRefreshStudent(
    RefreshStudent event,
    Emitter<StudentDetailState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is StudentDetailLoaded) {
      final result = await getStudent(GetStudentParams(currentState.student.id));
      
      result.fold(
        (failure) => emit(StudentDetailError(
          message: _mapFailureToMessage(failure),
          student: currentState.student,
        )),
        (student) => emit(StudentDetailLoaded(student: student)),
      );
    }
  }

  Future<void> _onDeleteStudent(
    DeleteStudentEvent event,
    Emitter<StudentDetailState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is StudentDetailLoaded) {
      emit(StudentDetailLoading(student: currentState.student));
      
      final result = await deleteStudent(DeleteStudentParams(currentState.student.id));
      
      result.fold(
        (failure) => emit(StudentDetailError(
          message: _mapFailureToMessage(failure),
          student: currentState.student,
        )),
        (_) => emit(StudentDetailDeleted()),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
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
        return 'Student not found';
      default:
        return 'An unexpected error occurred';
    }
  }
}
