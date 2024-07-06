import 'package:doctor_app_appointment/models/conver_datetime.dart';
import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/bottum.dart';
import '../components/custom_appbar.dart';
import '../main.dart';


class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  CalendarFormat _format = CalendarFormat.month;
  DateTime _foucseDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool isWeekend = false;
  bool selectedDate = false;
  bool selectedTime = false;
  String? token;

  Future<void> getToken() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('Token')?? '';
  }


  @override
  void initState() {
    getToken();
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppbar(title: "Appointment",icon: FaIcon(Icons.arrow_back_ios_new)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _tableCalendar(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Consultation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          isWeekend
              ? SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 30),
              alignment: Alignment.center,
              child: const Text(
                'Weekend is not available, please select another date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          )
              : SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      selectedTime = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index
                          ? config.primaryColor
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                        _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          //Spacer(),
          // SliverToBoxAdapter(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
          //     child: Button(
          //       width: double.infinity,
          //       title: 'Make Appointment',
          //       onPressed: ()  {
          //         //convert date/day/time into string first
          //         // final getDate = DateConverted.getDate(_currentDay);
          //         // final getDay = DateConverted.getDay(_currentDay.weekday);
          //         // final getTime = DateConverted.getTime(_currentIndex!);
          //         //
          //         // final booking = await DioProvider().bookAppointment(
          //         //     getDate, getDay, getTime, doctor['doctor_id'], token!);
          //         //
          //         // //if booking return status code 200, then redirect to success booking page
          //         //
          //         // if (booking == 200) {
          //         //   MyApp.navigatorKey.currentState!
          //         //       .pushNamed('success_booking');
          //         // }
          //       },
          //       disable: selectedTime && selectedDate ? false : true,
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Button(
                title: "Make Appointment",
                onPressed: () async{
                  final getDate = DateConvert.getDate(_currentDay);
                  final getDay = DateConvert.getDay(_currentDay.weekday);
                  final getTime = DateConvert.getTime(_currentIndex!);

                  final booking= await DioProvider().bookAppointment(getDate, getDay, getTime, doctor['doctor_id'], token!);

                  if(booking == 200) {
                    MyApp.navigatorKey.currentState!.pushNamed("success_booked");
                  }
                },
                width: double.infinity,
                disable: selectedDate && selectedTime ? false : true,
              ),
            ),
          )
        ],
      ),

    );
  }

  Widget _tableCalendar(){
    return TableCalendar(
        focusedDay: _foucseDay,
        firstDay: DateTime.now(),
        lastDay: DateTime(2024,12,31),
        calendarFormat: _format,
        currentDay: _currentDay,
        rowHeight: 48,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: config.primaryColor,shape: BoxShape.circle),
      ),
      availableCalendarFormats: {
          CalendarFormat.month : 'Month'
      },
      onFormatChanged: (Format){
          setState((){
            _format = Format ;
          });
      },
      onDaySelected: ((SelectedDay, Foucseday){
        setState((){
          _currentDay = SelectedDay;
          _foucseDay = Foucseday;
          selectedDate = true;
          if(SelectedDay.weekday == 6 || SelectedDay.weekday ==7){
            isWeekend = true;
            selectedTime = false;
            _currentIndex = null;
          }else{
            isWeekend = false;
          }
        });
      }),
    );
  }

}
