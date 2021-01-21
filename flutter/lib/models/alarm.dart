import 'package:flutter/material.dart';

class Alarm {
  final String id;
  final String title;
  final int timeStamp;
  final int alarmTime;

  Alarm(
      {@required this.title,
      this.id,
      @required this.timeStamp,
      @required this.alarmTime});

  static Alarm fromJson(Map<String, dynamic> json) {
    return Alarm(
        id: json["_id"],
        title: json["title"],
        timeStamp: json["timeStamp"],
        alarmTime: json["alarmTime"]);
  }

  static Map<String, dynamic> toJson(Alarm alarm) {
    return {
      "title": alarm.title,
      "timeStamp": int.parse(alarm.timeStamp.toString()),
      "alarmTime": int.parse(alarm.alarmTime.toString())
    };
  }
}
