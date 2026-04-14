import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_model.freezed.dart';
part 'teacher_model.g.dart';

@freezed
class TeacherModel with _$TeacherModel {
  const factory TeacherModel({
    required int id,
    required String name,
    String? bio,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'subject_name') String? subjectName,
    @Default(0.0) double rating,
    @Default(0) @JsonKey(name: 'reviews_count') int reviewsCount,
    @Default(0) @JsonKey(name: 'students_count') int studentsCount,
    @Default(0) @JsonKey(name: 'courses_count') int coursesCount,
    @Default(false) @JsonKey(name: 'is_featured') bool isFeatured,
  }) = _TeacherModel;

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);
}
