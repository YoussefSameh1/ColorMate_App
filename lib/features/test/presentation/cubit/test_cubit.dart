import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/test/data/models/question_model.dart';
import 'package:colormate_app/features/test/data/test_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial()) {
    emit(
      TestQuestionLoaded(currentIndex: 0, questions: questions, answers: []),
    );
  }

  TestFinished? lastResult;

  final _storage = SimpleAuthStorage();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://colormate.runasp.net/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  void selectAnswer(String? selectedValue) {
  final currentState = state;
  if (currentState is! TestQuestionLoaded) return;

  final question = currentState.questions[currentState.currentIndex];

  final updatedAnswers = [
    ...currentState.answers,
    {
      "imageId": question.imageId,
      // ✅ Send "x" when user couldn't see it, otherwise the number as string
      "value": selectedValue ?? "x",
      // ✅ usedForDiagnosis is false only when user couldn't see the number
      "usedForDiagnosis": selectedValue != null,
    },
  ];

  if (currentState.currentIndex < currentState.questions.length - 1) {
    emit(
      TestQuestionLoaded(
        currentIndex: currentState.currentIndex + 1,
        questions: currentState.questions,
        answers: updatedAnswers,
      ),
    );
  } else {
    _submitAnswers(updatedAnswers);
  }
}

  Future<void> _submitAnswers(List<Map<String, dynamic>> answers) async {
    emit(TestLoading());
    try {
      await _storage.init();

      final token = _storage.getSavedToken();

      if (token == null || token.isEmpty) {
        emit(TestError('You are not logged in. Please log in and try again.'));
        return;
      }

      final response = await _dio.post(
        'Ishihara/submit-answers',
        data: answers,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data;

      lastResult = TestFinished(
        diagnosis: data['diagnosis'] ?? 'Unknown',
        correctAnswerCount: data['correctAnswerCount'] ?? 0,
        protanAnswerCount: data['protanAnswerCount'] ?? 0,
        deutanAnswerCount: data['deutanAnswerCount'] ?? 0,
      );

      emit(lastResult!);
    } on DioException catch (e) {
      final message = switch (e.type) {
        DioExceptionType.connectionTimeout =>
          'Connection timed out. Check your internet.',
        DioExceptionType.receiveTimeout => 'Server took too long to respond.',
        DioExceptionType.badResponse => switch (e.response?.statusCode) {
          401 => 'Session expired. Please log in again.',
          403 => 'Access denied.',
          _ => 'Server error: ${e.response?.statusCode}',
        },
        DioExceptionType.connectionError => 'No internet connection.',
        _ => 'Something went wrong. Please try again.',
      };
      emit(TestError(message));
    }
  }

  void restartTest() {
    lastResult = null;
    emit(
      TestQuestionLoaded(currentIndex: 0, questions: questions, answers: []),
    );
  }
}