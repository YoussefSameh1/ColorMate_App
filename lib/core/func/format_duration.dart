String formatDuration(String? duration) {
  if (duration == null || duration.isEmpty) return '';
  List<String> parts = duration.split(':');
  if (parts.length != 3) return duration;
  if (parts[0] == '00') {
    // اعرض فقط الدقايق والثواني
    return '${parts[1]}:${parts[2]}';
  }
  // اعرض الساعات والدقايق والثواني بشكل عادي
  return '${parts[0]}:${parts[1]}:${parts[2]}';
}
