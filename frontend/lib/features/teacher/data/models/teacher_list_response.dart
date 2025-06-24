import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sim_java_frontend/features/teacher/data/models/teacher_model.dart';

part 'teacher_list_response.g.dart';

@JsonSerializable()
class TeacherListResponse extends Equatable {
  final List<TeacherModel> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const TeacherListResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory TeacherListResponse.fromJson(Map<String, dynamic> json) =>
      _$TeacherListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherListResponseToJson(this);

  @override
  List<Object> get props => [data, page, limit, total, totalPages];
}
