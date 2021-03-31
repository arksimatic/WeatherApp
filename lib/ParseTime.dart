import 'package:intl/intl.dart';

class ParseTime {
  static String parse(dateToParse) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateToParse*1000);
    DateFormat formatter = new DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }

  static String parseSmol(dateToParse) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateToParse*1000);
    DateFormat formatter = new DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}