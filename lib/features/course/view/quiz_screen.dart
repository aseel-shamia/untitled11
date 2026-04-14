import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/quiz_model.dart';
import '../viewmodel/course_viewmodel.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final int lessonId;

  const QuizScreen({super.key, required this.lessonId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final Map<int, int> _selectedAnswers = {};
  int _currentQuestionIndex = 0;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizProvider(widget.lessonId));
    final submissionState = ref.watch(quizSubmissionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          if (!_submitted)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(
                child: quizAsync.whenOrNull(
                  data: (quiz) => Text(
                    '${_currentQuestionIndex + 1}/${quiz.questions.length}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: quizAsync.when(
        data: (quiz) {
          // Show result if submitted
          final result = submissionState.valueOrNull;
          if (_submitted && result != null) {
            return _QuizResultView(
              result: result,
              onRetry: () {
                setState(() {
                  _submitted = false;
                  _selectedAnswers.clear();
                  _currentQuestionIndex = 0;
                });
              },
              onBack: () => context.pop(),
            );
          }

          if (quiz.questions.isEmpty) {
            return Center(
              child: Text(
                'No questions available',
                style: TextStyle(fontSize: 16.sp),
              ),
            );
          }

          final question = quiz.questions[_currentQuestionIndex];

          return Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / quiz.questions.length,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Text(
                        question.question,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${question.points} point${question.points > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Options
                      ...question.options.map((option) {
                        final isSelected =
                            _selectedAnswers[question.id] == option.id;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedAnswers[question.id] = option.id;
                                });
                              },
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                          .withValues(alpha: 0.1)
                                      : Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Theme.of(context).dividerColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24.w,
                                      height: 24.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Theme.of(context)
                                                  .dividerColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              size: 14.sp,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        option.text,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Navigation Buttons
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      if (_currentQuestionIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _currentQuestionIndex--);
                            },
                            child: const Text('Previous'),
                          ),
                        ),
                      if (_currentQuestionIndex > 0) SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedAnswers
                                  .containsKey(question.id)
                              ? () {
                                  if (_currentQuestionIndex <
                                      quiz.questions.length - 1) {
                                    setState(() => _currentQuestionIndex++);
                                  } else {
                                    _submitQuiz(quiz);
                                  }
                                }
                              : null,
                          child: Text(
                            _currentQuestionIndex <
                                    quiz.questions.length - 1
                                ? 'Next'
                                : 'Submit',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load quiz'),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(quizProvider(widget.lessonId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitQuiz(QuizModel quiz) {
    setState(() => _submitted = true);
    ref.read(quizSubmissionProvider.notifier).submit(
          quiz.id,
          _selectedAnswers,
        );
  }
}

class _QuizResultView extends StatelessWidget {
  final QuizResult result;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _QuizResultView({
    required this.result,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = result.totalQuestions > 0
        ? (result.correctAnswers / result.totalQuestions * 100).toInt()
        : 0;
    final isPassing = percentage >= 60;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result Icon
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: (isPassing ? AppColors.success : AppColors.error)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPassing
                    ? Icons.celebration_rounded
                    : Icons.sentiment_dissatisfied_rounded,
                size: 50.sp,
                color: isPassing ? AppColors.success : AppColors.error,
              ),
            ),
            SizedBox(height: 24.h),

            Text(
              isPassing ? 'Great Job!' : 'Keep Trying!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),

            Text(
              'You scored $percentage%',
              style: TextStyle(
                fontSize: 18.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ResultStat(
                  label: 'Correct',
                  value: '${result.correctAnswers}',
                  color: AppColors.success,
                ),
                _ResultStat(
                  label: 'Wrong',
                  value:
                      '${result.totalQuestions - result.correctAnswers}',
                  color: AppColors.error,
                ),
                _ResultStat(
                  label: 'Points',
                  value: '${result.score}',
                  color: AppColors.accent,
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Actions
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: onBack,
                child: const Text('Continue'),
              ),
            ),
            SizedBox(height: 12.h),
            if (!isPassing)
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Try Again'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
