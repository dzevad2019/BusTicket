extension DateTimeExtension on DateTime {
  DateTime withTimeFromString(String timeString) {
    final parts = timeString.split(':');

    return DateTime(
      year,
      month,
      day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}