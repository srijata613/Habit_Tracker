import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    final formatter = DateFormat('MMM dd');
    return '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
