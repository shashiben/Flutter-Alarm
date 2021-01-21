import 'dart:convert';

import 'package:alarm_test/models/alarm.dart';
import 'package:alarm_test/utils/dateTimeUtils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class AlarmRepositories {
  static final String baseUrl =
      "https://alarm-manager-server.herokuapp.com/alarm/";

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, Alarm alarm) async {
    print(
        "Scheduling Alarm at ${DateTimeUtils().getWholeDate(scheduledNotificationDateTime.millisecondsSinceEpoch)}");
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      '${alarm.title}',
      'Alarm Created at ${DateTimeUtils().timeAgoSinceDate(alarm.timeStamp)}',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  addNewAlarm(Alarm alarm) async {
    try {
      http.Response res = await http.post(baseUrl + "addAlarm",
          headers: {
            "content-type": "application/json",
          },
          body: json.encode(Alarm.toJson(alarm)));
      print("Got result is:${res.body}");
      if (res.statusCode == 200) {
        return true;
      }
      return jsonDecode(res.body)["message"];
    } catch (e) {
      print("Exception Occured is :$e");
    }
  }

  editAlarm(Alarm alarm) async {
    print(Alarm.toJson(alarm));
    var res = await http.put(baseUrl + "${alarm.id}",
        headers: {
          "content-type": "application/json",
        },
        body: jsonEncode(Alarm.toJson(alarm)));

    if (jsonDecode(res.body)["message"] == "Alarm Updated") {
      return jsonDecode(res.body)["alarm"];
    }
    return jsonDecode(res.body)["message"];
  }

  deleteAlarm(Alarm alarm) async {
    var res = await http.delete(baseUrl + "${alarm.id}");
    if (jsonDecode(res.body)["message"] == "Alarm Deleted") {
      return true;
    } else {
      return jsonDecode(res.body)["message"];
    }
  }

  Stream<List<Alarm>> getAllAlarms(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getAllAlarm();
    }
  }

  Future<List<Alarm>> getAllAlarm() async {
    var res = await http.get(baseUrl + "all");
    if (res.statusCode == 200) {
      List<Alarm> alarmList = [];
      var data = jsonDecode(res.body);
      for (int i = 0; i < data.length; i++) {
        alarmList.add(Alarm.fromJson(data[i]));
        if (alarmList[i].alarmTime >= DateTime.now().millisecondsSinceEpoch) {
          scheduleAlarm(
              DateTime.fromMillisecondsSinceEpoch(alarmList[i].alarmTime),
              alarmList[i]);
        }
      }

      return alarmList;
    }
    return [];
  }
}
