import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/subject_model.dart';
import '../data/models/teacher_model.dart';
import '../../course/data/models/course_model.dart';
import '../data/repositories/home_repository.dart';

// Subjects provider
final subjectsProvider = FutureProvider<List<SubjectModel>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getSubjects();
});

// Featured teachers provider
final featuredTeachersProvider =
    FutureProvider<List<TeacherModel>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getFeaturedTeachers();
});

// Recommended courses provider with pagination
class RecommendedCoursesNotifier extends StateNotifier<AsyncValue<List<CourseModel>>> {
  final HomeRepository _repository;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  RecommendedCoursesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = const AsyncValue.loading();
    try {
      _page = 1;
      final response = await _repository.getRecommendedCourses(page: _page);
      _hasMore = response.hasMore;
      state = AsyncValue.data(response.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    try {
      _page++;
      final response = await _repository.getRecommendedCourses(page: _page);
      _hasMore = response.hasMore;
      final currentData = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentData, ...response.data]);
    } catch (e) {
      _page--;
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
}

final recommendedCoursesProvider =
    StateNotifierProvider<RecommendedCoursesNotifier, AsyncValue<List<CourseModel>>>((ref) {
  return RecommendedCoursesNotifier(ref.watch(homeRepositoryProvider));
});
