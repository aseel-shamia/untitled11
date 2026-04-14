class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://api.tawjihi.com/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/profile';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Subjects
  static const String subjects = '/subjects';

  // Teachers
  static const String teachers = '/teachers';
  static const String featuredTeachers = '/teachers/featured';

  // Courses
  static const String courses = '/courses';
  static const String recommendedCourses = '/courses/recommended';
  static const String myCourses = '/courses/my';
  static const String enrollCourse = '/courses/{id}/enroll';

  // Lessons
  static const String lessons = '/courses/{courseId}/lessons';
  static const String lessonDetail = '/lessons/{id}';
  static const String lessonProgress = '/lessons/{id}/progress';

  // Quizzes
  static const String quizzes = '/lessons/{lessonId}/quizzes';
  static const String submitQuiz = '/quizzes/{id}/submit';

  // Dashboard
  static const String dashboard = '/student/dashboard';
  static const String achievements = '/student/achievements';
  static const String streaks = '/student/streaks';

  // Notifications
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';

  // Video
  static const String videoUrl = '/videos/{id}/stream';
}
