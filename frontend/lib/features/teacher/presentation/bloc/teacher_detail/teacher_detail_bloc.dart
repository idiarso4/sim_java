import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/delete_teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/get_teacher.dart';

part 'teacher_detail_event.dart';
part 'teacher_detail_state.dart';

class TeacherDetailBloc extends Bloc<TeacherDetailEvent, TeacherDetailState> {
  final GetTeacher getTeacher;
  final DeleteTeacher deleteTeacher;

  TeacherDetailBloc({
    required this.getTeacher,
    required this.deleteTeacher,
  }) : super(TeacherDetailInitial()) {
    on<LoadTeacher>(_onLoadTeacher);
    on<RefreshTeacher>(_onRefreshTeacher);
    on<DeleteTeacherEvent>(_onDeleteTeacher);
  }

  Future<void> _onLoadTeacher(
    LoadTeacher event,
    Emitter<TeacherDetailState> emit,
  ) async {
    emit(const TeacherDetailLoading());

    final failureOrTeacher = await getTeacher(event.teacherId);

    await failureOrTeacher.fold(
      (failure) async* {
        yield TeacherDetailLoadFailure(_mapFailureToMessage(failure));
      },
      (teacher) async* {
        yield TeacherDetailLoadSuccess(teacher);
      },
    );
  }

  Future<void> _onRefreshTeacher(
    RefreshTeacher event,
    Emitter<TeacherDetailState> emit,
  ) async {
    emit(const TeacherDetailLoading(isRefreshing: true));

    final failureOrTeacher = await getTeacher(event.teacherId);

    await failureOrTeacher.fold(
      (failure) async* {
        yield TeacherDetailLoadFailure(_mapFailureToMessage(failure));
      },
      (teacher) async* {
        yield TeacherDetailLoadSuccess(teacher);
      },
    );
  }

  Future<void> _onDeleteTeacher(
    DeleteTeacherEvent event,
    Emitter<TeacherDetailState> emit,
  ) async {
    emit(const TeacherDeletionInProgress());

    final failureOrDeleted = await deleteTeacher(event.teacherId);

    await failureOrDeleted.fold(
      (failure) async* {
        yield TeacherDeletionFailure(_mapFailureToMessage(failure));
      },
      (_) async* {
        yield const TeacherDeletionSuccess('Teacher deleted successfully');
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NotFoundFailure:
        return 'Teacher not found';
      case NetworkFailure:
        return 'No internet connection';
      case UnauthorizedFailure:
        return 'You are not authorized to perform this action';
      default:
        return 'Unexpected error';
    }
  }
}
