import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';

abstract class TeacherFormEvent extends Equatable {
  const TeacherFormEvent();

  @override
  List<Object?> get props => [];
}

// Form field update events
class NipChanged extends TeacherFormEvent {
  final String nip;
  
  const NipChanged(this.nip);
  
  @override
  List<Object> get props => [nip];
}

class NameChanged extends TeacherFormEvent {
  final String name;
  
  const NameChanged(this.name);
  
  @override
  List<Object> get props => [name];
}

class EmailChanged extends TeacherFormEvent {
  final String email;
  
  const EmailChanged(this.email);
  
  @override
  List<Object> get props => [email];
}

class PhoneNumberChanged extends TeacherFormEvent {
  final String phoneNumber;
  
  const PhoneNumberChanged(this.phoneNumber);
  
  @override
  List<Object> get props => [phoneNumber];
}

class BirthDateChanged extends TeacherFormEvent {
  final DateTime? birthDate;
  
  const BirthDateChanged(this.birthDate);
  
  @override
  List<Object?> get props => [birthDate];
}

class JoinDateChanged extends TeacherFormEvent {
  final DateTime? joinDate;
  
  const JoinDateChanged(this.joinDate);
  
  @override
  List<Object?> get props => [joinDate];
}

class TeacherFormSubmitted extends TeacherFormEvent {
  final bool isEditing;

  const TeacherFormSubmitted({
    this.isEditing = false,
  });

  @override
  List<Object?> get props => [isEditing];
}

class TeacherPhotoChanged extends TeacherFormEvent {
  final String? photoPath;

  const TeacherPhotoChanged(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

class TeacherPhotoRemoved extends TeacherFormEvent {
  const TeacherPhotoRemoved();
}

class TeacherFormReset extends TeacherFormEvent {
  const TeacherFormReset();
}

class TeacherFormLoad extends TeacherFormEvent {
  final String teacherId;

  const TeacherFormLoad(this.teacherId);

  @override
  List<Object?> get props => [teacherId];
}
