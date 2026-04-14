import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/teacher_model.dart';
import '../../../course/data/models/course_model.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository(ref.watch(dioProvider));
});

class TeacherRepository {
  final Dio _dio;

  TeacherRepository(this._dio);

  Future<TeacherModel> getTeacher(int id) async {
    final response = await _dio.get('${ApiConstants.teachers}/$id');
    return TeacherModel.fromJson(response.data['data']);
  }

  Future<List<CourseModel>> getTeacherCourses(int teacherId) async {
    final response = await _dio.get(
      '${ApiConstants.teachers}/$teacherId/courses',
    );
    return (response.data['data'] as List)
        .map((e) => CourseModel.fromJson(e))
        .toList();
  }
}
