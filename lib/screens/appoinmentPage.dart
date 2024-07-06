import 'dart:convert';

import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppoinmentPage extends StatefulWidget {
  const AppoinmentPage({super.key});

  @override
  State<AppoinmentPage> createState() => _AppoinmentPageState();
}

enum FilterStatus { upcoming, completed, cancel }

class _AppoinmentPageState extends State<AppoinmentPage> {
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;

  List<dynamic> schedules = [];

  Future<void> getAppointments() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('Token');
    final appointments = await DioProvider().getAppointments(token!);

    if(appointments != 'error'){
      setState((){
        schedules = json.decode(appointments);
      });
    }

  }


  @override
  void initState() {
    getAppointments();
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    config().init(context);
    List<dynamic> FilterSchedule = schedules.where((element) {
      switch(element['status']){
        case 'upcoming':
        element['status'] = FilterStatus.upcoming;
        break;
        case 'complete':
        element['status'] = FilterStatus.completed;
        break;
        case 'cancel':
        element['status'] = FilterStatus.cancel;
        break;
      }
      return element['status'] == status;
    }).toList();

    return SafeArea(
      child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Appointment Schedule",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              config.screensmall,
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (FilterStatus filterStatus in FilterStatus.values)
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.upcoming) {
                                  status = FilterStatus.upcoming;
                                  _alignment = Alignment.centerLeft;
                                } else if (filterStatus ==
                                    FilterStatus.completed) {
                                  status = FilterStatus.completed;
                                  _alignment = Alignment.center;
                                } else if (filterStatus ==
                                    FilterStatus.cancel) {
                                  status = FilterStatus.cancel;
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(filterStatus.name),
                            ),
                          ))
                      ],
                    ),
                  ),
                  AnimatedAlign(
                    alignment: _alignment,
                    duration: Duration(milliseconds: 200),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          color: config.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          status.name,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              config.screensmall,
              Expanded(
                  child: ListView.builder(
                      itemCount: FilterSchedule.length,
                      itemBuilder: ((context, index) {
                        var _schedule = FilterSchedule[index];
                        bool isLastItem = FilterSchedule.length + 1 == index;
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: !isLastItem
                              ? EdgeInsets.only(bottom: 20)
                              : EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "http://127.0.0.1:8000${_schedule['doctor_profile']}"),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _schedule['doctor_name'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(_schedule['category'],
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12))
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 15,),
                                ScheduleCard(
                                  date: _schedule['date'],
                                  day: _schedule['day'],
                                  time: _schedule['time'],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: config.primaryColor
                                        ),
                                          onPressed: (){},
                                          child: Text("Reschedule",
                                          style: TextStyle(
                                            color: Colors.white
                                          ),)
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: OutlinedButton(
                                          onPressed: (){},
                                          child: Text("Cancel",
                                            style: TextStyle(
                                                color: config.primaryColor
                                            ),)
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })))
            ],
          )),
    );
  }
}



class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.date,required this.day, required this.time});

  final String date;
  final String day;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10)
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined,color: config.primaryColor),
          SizedBox(width: 5,),
          Text("$day, $date",style: TextStyle(color: config.primaryColor),),
          SizedBox(width: 20,),
          Icon(Icons.alarm,color: config.primaryColor),
          SizedBox(width: 5,),
          Text("$time",style: TextStyle(color: config.primaryColor),),
        ],
      ),
    );
  }
}
