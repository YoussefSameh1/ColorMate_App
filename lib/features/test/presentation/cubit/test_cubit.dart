import 'package:colormate_app/features/test/data/models/question_model.dart';
import 'package:colormate_app/features/test/data/test_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial()) {
    emit(TestQuestionLoaded(currentIndex: 0, questions: questions));
  }

  void selectAnswer() {
    final currentState = state;

    if (currentState is TestQuestionLoaded) {
      if (currentState.currentIndex < currentState.questions.length - 1) {
        emit(
          TestQuestionLoaded(
            currentIndex: currentState.currentIndex + 1,
            questions: currentState.questions,
          ),
        );
      } else {
        emit(TestFinished());
      }
    }
  }

  void restartTest() {
    emit(TestQuestionLoaded(currentIndex: 0, questions: questions));
  }
}
