import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/course_model.dart';
import '../data/models/lesson_model.dart';
import '../data/models/quiz_model.dart';
import '../data/repositories/course_repository.dart';

// Course detail provider
final courseDetailProvider =
    FutureProvider.family<CourseModel, int>((ref, courseId) async {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getCourse(courseId);
});

// Course lessons provider
final courseLessonsProvider =
    FutureProvider.family<List<LessonModel>, int>((ref, courseId) async {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getLessons(courseId);
});

// My courses provider with pagination
class MyCoursesNotifier extends StateNotifier<AsyncValue<List<CourseModel>>> {
  final CourseRepository _repository;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  MyCoursesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = const AsyncValue.loading();
    try {
      _page = 1;
      final response = await _repository.getMyCourses(page: _page);
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
      final response = await _repository.getMyCourses(page: _page);
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

final myCoursesProvider =
    StateNotifierProvider<MyCoursesNotifier, AsyncValue<List<CourseModel>>>((ref) {
  return MyCoursesNotifier(ref.watch(courseRepositoryProvider));
});

// Enroll course
final enrollCourseProvider =
    FutureProvider.family<void, int>((ref, courseId) async {
  final repo = ref.watch(courseRepositoryProvider);
  await repo.enrollCourse(courseId);
});

// Quiz provider
final quizProvider =
    FutureProvider.family<QuizModel, int>((ref, lessonId) async {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getQuiz(lessonId);
});

// Quiz submission
class QuizSubmissionNotifier extends StateNotifier<AsyncValue<QuizResult?>> {
  final CourseRepository _repository;

  QuizSubmissionNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> submit(int quizId, Map<int, int> answers) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.submitQuiz(quizId, answers);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final quizSubmissionProvider =
    StateNotifierProvider<QuizSubmissionNotifier, AsyncValue<QuizResult?>>((ref) {
  return QuizSubmissionNotifier(ref.watch(courseRepositoryProvider));
});

// Video progress provider
class VideoProgressNotifier extends StateNotifier<Duration> {
  final CourseRepository _repository;
  final int _lessonId;

  VideoProgressNotifier(this._repository, this._lessonId)
      : super(Duration.zero) {
    _loadSavedProgress();
  }

  void _loadSavedProgress() {
    final saved = _repository.getLocalVideoProgress(_lessonId);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> updateProgress(Duration position) async {
    state = position;
    await _repository.updateLessonProgress(_lessonId, position.inSeconds);
  }
}

final videoProgressProvider =
    StateNotifierProvider.family<VideoProgressNotifier, Duration, int>(
        (ref, lessonId) {
  return VideoProgressNotifier(ref.watch(courseRepositoryProvider), lessonId);
});
