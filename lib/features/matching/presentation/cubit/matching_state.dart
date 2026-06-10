abstract class MatchingState {}

class MatchingInitial extends MatchingState {}

class MatchingLoading extends MatchingState {}

class MatchingSuccess extends MatchingState {
  final String imagePath;
  final double score;
  final List<String> suggestions;

  MatchingSuccess({
    required this.imagePath,
    required this.score,
    required this.suggestions,
  });
}

class MatchingError extends MatchingState {
  final String message;
  MatchingError(this.message);
}