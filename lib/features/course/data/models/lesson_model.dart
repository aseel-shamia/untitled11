import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    required int id,
    required String title,
    String? description,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'duration_seconds') @Default(0) int durationSeconds,
    @Default(0) @JsonKey(name: 'order_index') int orderIndex,
    @Default(false) @JsonKey(name: 'is_free') bool isFree,
    @Default(false) @JsonKey(name: 'is_completed') bool isCompleted,
    @Default(0) @JsonKey(name: 'progress_seconds') int progressSeconds,
    @JsonKey(name: 'course_id') int? courseId,
    @Default(false) @JsonKey(name: 'has_quiz') bool hasQuiz,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}
