part of 'test_cubit.dart';

abstract class TestState {}

final class TestInitial extends TestState {}

final class TestQuestionLoaded extends TestState {
  final int currentIndex;
  final List<QuestionModel> questions;
  final List<Map<String, dynamic>> answers;

  TestQuestionLoaded({
    required this.currentIndex,
    required this.questions,
    required this.answers,
  });
}

final class TestLoading extends TestState {}

final class TestFinished extends TestState {
  final String diagnosis;
  final int correctAnswerCount;
  final int protanAnswerCount;
  final int deutanAnswerCount;

  TestFinished({
    required this.diagnosis,
    required this.correctAnswerCount,
    required this.protanAnswerCount,
    required this.deutanAnswerCount,
  });
}

final class TestError extends TestState {
  final String message;
  TestError(this.message);
}