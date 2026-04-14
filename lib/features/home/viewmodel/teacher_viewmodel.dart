import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/data/models/teacher_model.dart';
import '../../home/data/repositories/teacher_repository.dart';
import '../data/models/course_model.dart';

final teacherDetailProvider =
    FutureProvider.family<TeacherModel, int>((ref, teacherId) async {
  final repo = ref.watch(teacherRepositoryProvider);
  return repo.getTeacher(teacherId);
});

final teacherCoursesProvider =
    FutureProvider.family<List<CourseModel>, int>((ref, teacherId) async {
  final repo = ref.watch(teacherRepositoryProvider);
  return repo.getTeacherCourses(teacherId);
});
