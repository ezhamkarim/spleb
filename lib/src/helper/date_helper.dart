import 'package:intl/intl.dart';

class DateHelper {
  static String toDateOnly(String? dateTime) {
    if (dateTime == null) return dateTime ?? '';
    var format = DateFormat('dd/MM/yyyy');
    var date = DateTime.tryParse(dateTime);

    if (date == null) return dateTime;
    return format.format(date);
  }
}
