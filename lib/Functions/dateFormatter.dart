import 'package:intl/intl.dart';

String dateFormater(DateTime date, [String formate = 'yyyy/MM/dd hh:mm a']) {
  final DateFormat formatter = DateFormat(formate);
  String formatted = formatter.format(date);
  // print(formatted);
  return formatted;
}