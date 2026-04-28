class QuestionModel {
  final int imageId;
  final String image;
  final String value;
  final List<int> options;
  final bool usedForDiagnosis;

  QuestionModel({
    required this.imageId,
    required this.image,
    required this.value,
    required this.options,
    required this.usedForDiagnosis,
  });
}
