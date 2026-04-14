import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

@freezed
class QuizModel with _$QuizModel {
  const factory QuizModel({
    required int id,
    required String title,
    @JsonKey(name: 'lesson_id') required int lessonId,
    @Default([]) List<QuestionModel> questions,
    @JsonKey(name: 'total_points') @Default(0) int totalPoints,
    @JsonKey(name: 'time_limit_seconds') int? timeLimitSeconds,
  }) = _QuizModel;

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
}

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required int id,
    required String question,
    required List<AnswerOption> options,
    @JsonKey(name: 'correct_option_id') int? correctOptionId,
    @Default(1) int points,
    String? explanation,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class AnswerOption with _$AnswerOption {
  const factory AnswerOption({
    required int id,
    required String text,
    @Default(false) @JsonKey(name: 'is_correct') bool isCorrect,
  }) = _AnswerOption;

  factory AnswerOption.fromJson(Map<String, dynamic> json) =>
      _$AnswerOptionFromJson(json);
}

@freezed
class QuizResult with _$QuizResult {
  const factory QuizResult({
    @JsonKey(name: 'quiz_id') required int quizId,
    required int score,
    @JsonKey(name: 'total_points') required int totalPoints,
    @JsonKey(name: 'correct_answers') required int correctAnswers,
    @JsonKey(name: 'total_questions') required int totalQuestions,
    @JsonKey(name: 'time_taken_seconds') int? timeTakenSeconds,
  }) = _QuizResult;

  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);
}
