/// Formats seconds into MM:SS format
/// Example: 65 -> "01:05"
String formatTimer(int totalSeconds) {
  final minutes = (totalSeconds / 60).floor().toString().padLeft(2, '0');
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  return "$minutes:$seconds";
}
