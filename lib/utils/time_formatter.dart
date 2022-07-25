import 'package:intl/intl.dart';

class TimFormatter {
  static String formatShortDate(DateTime dateTime) {
    final format = DateFormat('MMM dd');
    return format.format(dateTime);
  }

  static String formatChatTime(int dateTime) {
    //final format = DateFormat('HH:mm');
    final hour = DateTime.fromMillisecondsSinceEpoch(dateTime).toLocal().hour;
    final minute = DateTime.fromMillisecondsSinceEpoch(dateTime).toLocal().minute;
    return "${hour}.${minute}";
  }
}