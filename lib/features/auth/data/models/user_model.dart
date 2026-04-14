import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String email,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') String? createdAt,
    @Default(0) int points,
    @Default(0) @JsonKey(name: 'current_streak') int currentStreak,
    @Default(0) @JsonKey(name: 'courses_count') int coursesCount,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
