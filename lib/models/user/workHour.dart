import 'package:flutter/material.dart';

class WorkHour {
  late String day;
  late String from;
  late String to;

  String get getDay => day;
  set setDay(String _day) {
    day = _day;
  }

  TimeOfDay get getFrom {
    return stringToTime(from);
  }

  set setFrom(String _from) {
    from = _from;
  }

  TimeOfDay get getTo {
    return stringToTime(to);
  }

  set setTo(String _to) {
    to = _to;
  }

  static TimeOfDay stringToTime(String time) {
    int hh = 0;
    if (time.endsWith('PM')) hh = 12;
    time = time.split(' ')[0];
    return TimeOfDay(
      hour: hh + int.parse(time.split(":")[0]) % 24,
      minute: int.parse(time.split(":")[1]) % 60,
    );
  }

  WorkHour(this.day, this.from, this.to);

  WorkHour.fromJson(data) {
    if (data.containsKey('day')) day = data['day'];
    if (data.containsKey('from')) from = data['from'].toString().replaceAll(' AM', '').replaceAll(' PM', '');
    if (data.containsKey('to')) to = data['to'].toString().replaceAll(' AM', '').replaceAll(' PM', '');
  }
}
