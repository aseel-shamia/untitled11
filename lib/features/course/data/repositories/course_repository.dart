import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(
    ref.watch(dioProvider),
    ref.watch(localStorageProvider),
  );
});

class CourseRepository {
  final Dio _dio;
  final LocalStorageService _localStorage;

  CourseRepository(this._dio, this._localStorage);

  Future<CourseModel> getCourse(int id) async {
    final response = await _dio.get('${ApiConstants.courses}/$id');
    return CourseModel.fromJson(response.data['data']);
  }

  Future<PaginatedResponse<CourseModel>> getMyCourses({int page = 1}) async {
    final response = await _dio.get(
      ApiConstants.myCourses,
      queryParameters: {'page': page, 'per_page': AppConstants.pageSize},
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => CourseModel.fromJson(json),
    );
  }

  Future<void> enrollCourse(int courseId) async {
    final url = ApiConstants.enrollCourse.replaceFirst('{id}', '$courseId');
    await _dio.post(url);
  }

  Future<List<LessonModel>> getLessons(int courseId) async {
    final url = ApiConstants.lessons.replaceFirst('{courseId}', '$courseId');
    final response = await _dio.get(url);
    return (response.data['data'] as List)
        .map((e) => LessonModel.fromJson(e))
        .toList();
  }

  Future<LessonModel> getLesson(int lessonId) async {
    final url = ApiConstants.lessonDetail.replaceFirst('{id}', '$lessonId');
    final response = await _dio.get(url);
    return LessonModel.fromJson(response.data['data']);
  }

  Future<void> updateLessonProgress(int lessonId, int progressSeconds) async {
    final url = ApiConstants.lessonProgress.replaceFirst('{id}', '$lessonId');
    await _dio.post(url, data: {'progress_seconds': progressSeconds});
    // Also save locally
    await _localStorage.saveVideoProgress(
      '$lessonId',
      Duration(seconds: progressSeconds),
    );
  }

  Future<QuizModel> getQuiz(int lessonId) async {
    final url = ApiConstants.quizzes.replaceFirst('{lessonId}', '$lessonId');
    final response = await _dio.get(url);
    return QuizModel.fromJson(response.data['data']);
  }

  Future<QuizResult> submitQuiz(
    int quizId,
    Map<int, int> answers,
  ) async {
    final url = ApiConstants.submitQuiz.replaceFirst('{id}', '$quizId');
    final response = await _dio.post(url, data: {
      'answers': answers.entries
          .map((e) => {'question_id': e.key, 'option_id': e.value})
          .toList(),
    });
    return QuizResult.fromJson(response.data['data']);
  }

  Duration? getLocalVideoProgress(int lessonId) {
    return _localStorage.getVideoProgress('$lessonId');
  }
}
