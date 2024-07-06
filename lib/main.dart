import 'dart:convert';
import 'dart:ffi';

import 'package:doctor_app_appointment/main_layout.dart';
import 'package:doctor_app_appointment/models/login_auth.dart';
import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/screens/authPage.dart';
import 'package:doctor_app_appointment/screens/booking_page.dart';
import 'package:doctor_app_appointment/screens/successed_booking.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Doctor Appointment',
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            focusColor: config.primaryColor,
            border: config.outLineBorder,
            focusedBorder: config.focusBorder,
            errorBorder: config.errorBorder,
            enabledBorder: config.outLineBorder,
            floatingLabelStyle: TextStyle(color: config.primaryColor),
            prefixIconColor: Colors.black38
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: config.primaryColor,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed
          )
        ),
        initialRoute: '/',
        routes:{
          '/': (context)=>const AuthPage(),
          'main': (context)=> const MainLayout(),
          'booking_page': (context)=> const BookingPage(),
          'success_booked': (context)=> const AppointmentBooked(),
        },
      ),
    );
  }
}
