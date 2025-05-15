class DateTimeHelper {
  static DateTime stringToDateTime(String dateString) {
    List<String> dateComponents = dateString.split('/');
    int day = int.parse(dateComponents[1]);
    int month = int.parse(dateComponents[0]);
    int year = int.parse(dateComponents[2]);
    return DateTime(year, month, day);
  }
}
