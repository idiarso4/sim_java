import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';

class UpcomingClassModel extends UpcomingClass with EquatableMixin {
  const UpcomingClassModel({
    required String id,
    required String className,
    required String subject,
    required String time,
    String? teacherName,
  }) : super(
          id: id,
          className: className,
          subject: subject,
          time: time,
          teacherName: teacherName,
        );

  factory UpcomingClassModel.fromJson(Map<String, dynamic> json) {
    return UpcomingClassModel(
      id: json['id'] as String,
      className: json['class_name'] as String,
      subject: json['subject'] as String,
      time: json['time'] as String,
      teacherName: json['teacher_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'subject': subject,
      'time': time,
      if (teacherName != null) 'teacher_name': teacherName,
    };
  }
}
