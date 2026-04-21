abstract class FruitResultState {}

class FruitResultInitial extends FruitResultState {}

class FruitResultLoading extends FruitResultState {}

class FruitResultSuccess extends FruitResultState {
  final String imagePath;
  final double spoiledPercent;
  final String status; // fresh / not fresh

  FruitResultSuccess({
    required this.imagePath,
    required this.spoiledPercent,
    required this.status,
  });
}

class FruitResultError extends FruitResultState {
  final String message;

  FruitResultError(this.message);
}