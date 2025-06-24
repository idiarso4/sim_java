import 'package:equatable/equatable.dart';

abstract class TeacherDetailEvent extends Equatable {
  const TeacherDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadTeacher extends TeacherDetailEvent {
  final String teacherId;

  const LoadTeacher(this.teacherId);

  @override
  List<Object?> get props => [teacherId];
}

class RefreshTeacher extends TeacherDetailEvent {
  final String teacherId;

  const RefreshTeacher(this.teacherId);

  @override
  List<Object?> get props => [teacherId];
}

class DeleteTeacher extends TeacherDetailEvent {
  final String teacherId;

  const DeleteTeacher(this.teacherId);

  @override
  List<Object?> get props => [teacherId];
}
