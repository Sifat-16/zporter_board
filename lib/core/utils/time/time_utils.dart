import 'package:intl/intl.dart';

class TimeUtils{
  static String formatDate({required DateTime date, required String pattern}){
    return DateFormat(pattern).format(date);
  }
}