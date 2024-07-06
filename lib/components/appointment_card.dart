import 'package:dio/dio.dart';
import 'package:doctor_app_appointment/main.dart';
import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key, required this.doctor, required this.color});

  final Map<dynamic, dynamic> doctor;
  final Color color;
  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    config().init(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "http://127.0.0.1:8000${widget.doctor['doctor_profile']}"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr ${widget.doctor['doctor_name']}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.doctor['category'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              config.screensmall,
              ScheduleCard(appointments: widget.doctor['appointments']),
              config.screensmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text("Completed"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return RatingDialog(
                                initialRating: 1.0,
                                title: Text(
                                  "Rate the Doctor",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                submitButtonText: 'submit',
                                onSubmitted: (response) async {
                                  final SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  final token = pref.getString('Token') ?? '';

                                  final rating = await DioProvider()
                                      .storeReviews(
                                          response.comment,
                                          response.rating,
                                          widget.doctor['appointments']['id'],
                                          widget.doctor['doc_id'],
                                          token);

                                  if (rating == 200 && rating != '') {
                                    MyApp.navigatorKey.currentState!
                                        .pushNamed('main');
                                  }
                                });
                          });
                    },
                  )),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text("Cancel"),
                    onPressed: () {},
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.appointments});

  final Map<String, dynamic> appointments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined, color: Colors.white),
          SizedBox(
            width: 5,
          ),
          Text(
            "${appointments['day']}, ${appointments['date']}",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.alarm, color: Colors.white),
          SizedBox(
            width: 5,
          ),
          Text(
            "${appointments['time']}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
