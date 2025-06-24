import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';

abstract class TeacherDetailState extends Equatable {
  const TeacherDetailState();

  @override
  List<Object?> get props => [];
}

class TeacherDetailInitial extends TeacherDetailState {
  const TeacherDetailInitial();
}

class TeacherDetailLoading extends TeacherDetailState {
  final bool isRefreshing;

  const TeacherDetailLoading({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class TeacherDetailLoadSuccess extends TeacherDetailState {
  final Teacher teacher;

  const TeacherDetailLoadSuccess(this.teacher);

  @override
  List<Object?> get props => [teacher];
}

class TeacherDetailLoadFailure extends TeacherDetailState {
  final String message;

  const TeacherDetailLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TeacherDeletionInProgress extends TeacherDetailState {
  const TeacherDeletionInProgress();
}

class TeacherDeletionSuccess extends TeacherDetailState {
  final String message;

  const TeacherDeletionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TeacherDeletionFailure extends TeacherDetailState {
  final String message;

  const TeacherDeletionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
