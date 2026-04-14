import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_model.freezed.dart';
part 'subject_model.g.dart';

@freezed
class SubjectModel with _$SubjectModel {
  const factory SubjectModel({
    required int id,
    required String name,
    @JsonKey(name: 'name_ar') String? nameAr,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'color_hex') String? colorHex,
    @Default(0) @JsonKey(name: 'courses_count') int coursesCount,
    @Default(0) @JsonKey(name: 'teachers_count') int teachersCount,
  }) = _SubjectModel;

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);
}
