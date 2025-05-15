extension DateTimeExtension on DateTime {
  DateTime withTimeFromString(String timeString) {
    final parts = timeString.split(':');
    print(DateTime(
      year,
      month,
      day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    ));
    return DateTime(
      year,
      month,
      day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}