import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../models/subject_model.dart';
import '../models/teacher_model.dart';
import '../../../course/data/models/course_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
    ref.watch(dioProvider),
    ref.watch(localStorageProvider),
  );
});

class HomeRepository {
  final Dio _dio;
  final LocalStorageService _localStorage;

  HomeRepository(this._dio, this._localStorage);

  Future<List<SubjectModel>> getSubjects() async {
    // Try cache first
    final cached = _localStorage.getCachedData<List<SubjectModel>>(
      AppConstants.cacheBox,
      'subjects',
      (data) => (data as List).map((e) => SubjectModel.fromJson(e)).toList(),
      maxAge: const Duration(hours: 6),
    );
    if (cached != null) return cached;

    final response = await _dio.get(ApiConstants.subjects);
    final subjects = (response.data['data'] as List)
        .map((e) => SubjectModel.fromJson(e))
        .toList();

    // Cache the result
    await _localStorage.cacheData(
      AppConstants.cacheBox,
      'subjects',
      subjects.map((e) => e.toJson()).toList(),
    );

    return subjects;
  }

  Future<List<TeacherModel>> getFeaturedTeachers() async {
    final cached = _localStorage.getCachedData<List<TeacherModel>>(
      AppConstants.cacheBox,
      'featured_teachers',
      (data) => (data as List).map((e) => TeacherModel.fromJson(e)).toList(),
      maxAge: const Duration(hours: 2),
    );
    if (cached != null) return cached;

    final response = await _dio.get(ApiConstants.featuredTeachers);
    final teachers = (response.data['data'] as List)
        .map((e) => TeacherModel.fromJson(e))
        .toList();

    await _localStorage.cacheData(
      AppConstants.cacheBox,
      'featured_teachers',
      teachers.map((e) => e.toJson()).toList(),
    );

    return teachers;
  }

  Future<PaginatedResponse<CourseModel>> getRecommendedCourses({
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiConstants.recommendedCourses,
      queryParameters: {'page': page, 'per_page': AppConstants.pageSize},
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => CourseModel.fromJson(json),
    );
  }
}
