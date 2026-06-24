abstract class FruitResultState {}

class FruitResultInitial extends FruitResultState {}

class FruitResultLoading extends FruitResultState {}

class FruitResultSuccess extends FruitResultState {
  final String imagePath;
  final double spoiledPercent;
  final String status;
  // ✅ Extra fields from the API response
  final String predictedClass;
  final double confidence;

  FruitResultSuccess({
    required this.imagePath,
    required this.spoiledPercent,
    required this.status,
    required this.predictedClass,
    required this.confidence,
  });
}

class FruitResultError extends FruitResultState {
  final String message;
  FruitResultError(this.message);
}