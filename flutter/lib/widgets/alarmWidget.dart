import 'package:alarm_test/app/colors.dart';
import 'package:alarm_test/models/alarm.dart';
import 'package:alarm_test/screens/addAlarm.dart';
import 'package:alarm_test/utils/dateTimeUtils.dart';
import 'package:flutter/material.dart';

class AlarmWidget extends StatefulWidget {
  final Alarm alarm;
  final int index;

  const AlarmWidget({Key key, this.alarm, this.index}) : super(key: key);

  @override
  _AlarmWidgetState createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  int index = 0;
  var gradientColor;

  @override
  void initState() {
    setIndex();
    super.initState();
  }

  setIndex() {
    setState(() {
      index = widget.index % 5;
      gradientColor = GradientTemplate.gradientTemplate[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            leading: Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            title: Text(
              widget.alarm.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddAlarm(
                              alarm: widget.alarm,
                            )));
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            dense: true,
            title:
                Text("${DateTimeUtils().getWholeDate(widget.alarm.alarmTime)}"),
            leading: Icon(
              Icons.timelapse,
              color: Colors.white,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: double.infinity,
            child: Text(
                "Created ${DateTimeUtils().timeAgoSinceDate(widget.alarm.timeStamp)}"),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor.colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColor.colors.last.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(4, 4),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    );
  }
}
