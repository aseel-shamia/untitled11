import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
class CourseModel with _$CourseModel {
  const factory CourseModel({
    required int id,
    required String title,
    String? description,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'teacher_name') String? teacherName,
    @JsonKey(name: 'teacher_avatar') String? teacherAvatar,
    @JsonKey(name: 'teacher_id') int? teacherId,
    @JsonKey(name: 'subject_name') String? subjectName,
    @Default(0.0) double rating,
    @Default(0) @JsonKey(name: 'reviews_count') int reviewsCount,
    @Default(0) @JsonKey(name: 'students_count') int studentsCount,
    @Default(0) @JsonKey(name: 'lessons_count') int lessonsCount,
    @Default(0) @JsonKey(name: 'duration_minutes') int durationMinutes,
    double? price,
    @Default(false) @JsonKey(name: 'is_enrolled') bool isEnrolled,
    @Default(0) @JsonKey(name: 'progress_percent') int progressPercent,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}
