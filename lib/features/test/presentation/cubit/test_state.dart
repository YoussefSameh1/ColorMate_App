part of 'test_cubit.dart';

abstract class TestState {}

final class TestInitial extends TestState {}

final class TestQuestionLoaded extends TestState {
  final int currentIndex;
  final List<QuestionModel> questions;

  TestQuestionLoaded({required this.currentIndex, required this.questions});
}

final class TestFinished extends TestState {}