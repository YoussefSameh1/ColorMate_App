class QuestionModel {
  final int questionNumber;
  final String image;
  final int correctAnswer;
  final List<int> options;

  QuestionModel({
    required this.questionNumber,
    required this.image,
    required this.correctAnswer,
    required this.options,
  });
}
