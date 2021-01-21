import 'package:alarm_test/app/colors.dart';
import 'package:alarm_test/models/alarm.dart';
import 'package:alarm_test/screens/addAlarm.dart';
import 'package:alarm_test/widgets/alarmWidget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:alarm_test/services/alarmRepositories.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAlarmLoaded = false;

  List<Alarm> alarmList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          "Alarm Manager",
          style: TextStyle(color: textPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream:
                        AlarmRepositories().getAllAlarms(Duration(seconds: 5)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 120,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.purple),
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        print(snapshot.data);
                        if (snapshot.data != null) {
                          alarmList = snapshot.data;
                        }
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AlarmWidget(
                              alarm: alarmList[index],
                              index: index,
                            );
                          },
                          itemCount: alarmList.length,
                        );
                      }
                      return SizedBox();
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddAlarm())),
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Icon(Icons.add_alarm, size: 40),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Add Alarm",
                                style: Theme.of(context).textTheme.headline6,
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )),
    );
  }
}
