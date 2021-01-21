import 'package:alarm_test/app/colors.dart';
import 'package:alarm_test/models/alarm.dart';
import 'package:alarm_test/services/alarmRepositories.dart';
import 'package:alarm_test/utils/dateTimeUtils.dart';
import 'package:flutter/material.dart';

class AddAlarm extends StatefulWidget {
  final Alarm alarm;

  const AddAlarm({Key key, this.alarm}) : super(key: key);
  @override
  _AddAlarmState createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  int timeStamp;

  @override
  void initState() {
    setState(() {
      if (widget.alarm != null) {
        titleController.text = widget.alarm.title;
        timeStamp = widget.alarm.alarmTime;
        timeController.text = DateTimeUtils().getWholeDate(timeStamp);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        onPressed: () async {
          if (titleController.text != null &&
              titleController.text.trim().length != 0 &&
              timeStamp != null) {
            if (widget.alarm != null) {
              try {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: backgroundColor,
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.purple),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Please wait"),
                                  Text(
                                    "Editing Alarm from your list...",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ));
                Alarm alarm = Alarm(
                    id: widget.alarm.id,
                    title: titleController.text,
                    timeStamp: widget.alarm.timeStamp,
                    alarmTime: timeStamp);
                await AlarmRepositories().editAlarm(alarm);
                Navigator.pop(context);
                Navigator.pop(context);
              } catch (e) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            } else {
              try {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: backgroundColor,
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.purple),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Please wait"),
                                  Text(
                                    "Adding Alarm to your list...",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ));
                Alarm alarm = Alarm(
                    title: titleController.text,
                    timeStamp: DateTime.now().millisecondsSinceEpoch,
                    alarmTime: timeStamp);
                await AlarmRepositories().addNewAlarm(alarm);
                Navigator.pop(context);
                Navigator.pop(context);
              } catch (e) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            }
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        label: Text(widget.alarm != null ? "Edit Alarm" : "Add Alarm"),
      ),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          if (widget.alarm != null)
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () async {
                  try {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: backgroundColor,
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.purple),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Please wait"),
                                      Text(
                                        "Deleting Alarm from your list...",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ));
                    await AlarmRepositories().deleteAlarm(widget.alarm);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } catch (e) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                })
        ],
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Title',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: 3,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: surfaceColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Pick Time',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: 3,
              ),
              GestureDetector(
                onTap: () async {
                  var res = await showTimePicker(
                      initialEntryMode: TimePickerEntryMode.input,
                      context: context,
                      initialTime: TimeOfDay.now());
                  if (res != null) {
                    DateTime presentDate = DateTime.now();
                    DateTime dateTime = DateTime(
                        presentDate.year,
                        presentDate.month,
                        presentDate.day,
                        res.hour,
                        res.minute);
                    setState(() {
                      timeController.text = DateTimeUtils()
                          .getWholeDate(dateTime.millisecondsSinceEpoch);
                      timeStamp = dateTime.millisecondsSinceEpoch;
                    });
                  }
                },
                child: TextField(
                  enabled: false,
                  controller: timeController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: surfaceColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
