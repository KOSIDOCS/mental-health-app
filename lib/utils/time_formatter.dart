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

  static String formatTimeUserCard({ required String dateTime }) {
    final format = DateFormat('MMMM dd, HH:mm');
    return format.format(DateTime.parse(dateTime));
  }

  static String formatCommentDate({ required DateTime dateTime }) {
    final format = DateFormat('MMMM dd, y');
    return format.format(dateTime);
  }
}