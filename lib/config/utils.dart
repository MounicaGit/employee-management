import 'app_constants.dart';

class Utils {
  // Convert DateTime to date string
  static String formatDate(DateTime date) {
    return "${date.day} ${AppConstants.monthsShortAbbreviations[date.month - 1]} ${date.year}";
  }

  // Convert date string to DateTime
  static DateTime formatToDateTime(String dateString) {
    List<String> parts = dateString.split(' ');
    int day = int.parse(parts[0]);
    Map<String, int> monthMap = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    int month = monthMap[parts[1]] ?? 1;
    int year = int.parse(parts[2]);
    DateTime dateTime = DateTime(year, month, day);
    return (dateTime);
  }

  // Compare two dates
  static compareDates(DateTime date1, DateTime date2) {
    return (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year);
  }
}
