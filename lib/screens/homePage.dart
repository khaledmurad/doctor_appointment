import 'dart:convert';

import 'package:doctor_app_appointment/components/appointment_card.dart';
import 'package:doctor_app_appointment/models/login_auth.dart';
import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/doctor_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String,dynamic> user={};
  Map<String,dynamic> doctor={};
  List<dynamic> favList = [];
  List<Map<String , dynamic>> medCat = [
    {
      "icon":FontAwesomeIcons.userDoctor,
      "category":"General"
    },
    {
      "icon":FontAwesomeIcons.heartPulse,
      "category":"Cardiology"
    },
    {
      "icon":FontAwesomeIcons.lungs,
      "category":"Respirations"
    },
    {
      "icon":FontAwesomeIcons.hand,
      "category":"Dermatology"
    },
    {
      "icon":FontAwesomeIcons.personPregnant,
      "category":"Gynecology"
    },
    {
      "icon":FontAwesomeIcons.teeth,
      "category":"Dental"
    },
  ];

  Future<void> getData() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('Token')??'';
    if(token.isNotEmpty && token != ''){
      final response = await DioProvider().getUser(token);
      if(response != null){
        setState((){
          user = json.decode(response);
        });
      }
    }

    for(var doctorData in user['doctor']){
      if(doctorData['appointments'] != null){
        doctor = doctorData;
      }
    }


  }


  @override
  void initState() {
   // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AuthModel>(context,listen: false).getUser;
    doctor = Provider.of<AuthModel>(context,listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context,listen: false).getFav;
    config().init(context);
    return Scaffold(
      body: user.isEmpty?
          Center(child: CircularProgressIndicator(),)
          :Padding(
        padding: EdgeInsets.all(15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user['name'],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/profile.png"),
                      ),
                    )
                  ],
                ),
                config.screenmedium,
                Text(
                  'Category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                config.screensmall,
                SizedBox(
                  height: config.screenHeight! * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length,
                            (index){
                      return Card(
                        margin: EdgeInsets.only(right: 20),
                        color: config.primaryColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FaIcon(medCat[index]['icon'],color: Colors.white,),
                              SizedBox(width: 20,),
                              Text(
                                medCat[index]['category'],
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      );
                            }),
                  ),
                ),
                config.screensmall,
                Text(
                  'Appointment Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                config.screensmall,
                doctor.isNotEmpty?AppointmentCard(
                  doctor: doctor,
                  color: config.primaryColor,
                ):Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)
                  ),
                child: Center(child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No Appointment Today",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                  ),
                ),),
                ),
                config.screensmall,
                Text(
                  'Top Doctors',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                config.screensmall,
                Column(
                  children: List.generate(user['doctor'].length, (index){
                    return DoctorCard(doctor: user['doctor'][index],
                      isfav: favList.contains(user['doctor'][index]['doc_id'])?true:false,);
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
