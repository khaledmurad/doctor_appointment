import 'package:doctor_app_appointment/components/custom_appbar.dart';
import 'package:doctor_app_appointment/models/login_auth.dart';
import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/bottum.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key,required this.doctor, required this.isfav});
  final Map<String, dynamic> doctor;
  final bool isfav;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Map<String, dynamic> doctor = {};
  bool isFav = false;


  @override
  void initState() {
    doctor = widget.doctor;
    isFav = widget.isfav;
    super.initState();
  }

  @override
  Widget build(BuildContext context)  {
    //final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppbar(
          title: "Doctor Details",
          icon: FaIcon(Icons.arrow_back_ios_new),
          actions: [
            IconButton(
                onPressed: () {
                  setState(()async {
                    final list= Provider.of<AuthModel>(context, listen: false).getFav;

                    if(list.contains(doctor['doc_id'])){
                      list.removeWhere((id) => id ==  doctor['doc_id']);
                    }else{
                      list.add(doctor['doc_id']);
                    }

                    Provider.of<AuthModel>(context,listen: false).setFavList(list);

                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('Token') ?? '';

                    if(token.isNotEmpty && token != ''){
                      final response = await DioProvider().storeFavDoc(list, token);
                      if(response == 200){
                        setState((){
                          isFav = !isFav;
                        });
                      }
                    }


                  });
                },
                icon: FaIcon(
                  isFav ? Icons.favorite : Icons.favorite_border_outlined,
                  color: Colors.red,
                ))
          ]),
      body: SafeArea(
        child: Column(
          children: [
            DocDet(doctor: doctor),
            AboutDoc(doctor: doctor),
            Spacer(),
            Padding(padding: EdgeInsets.all(20),
            child: Button(
              width: double.infinity,
              onPressed: (){
                Navigator.of(context).pushNamed("booking_page", arguments: {"doctor_id" : doctor['doc_id']});
              },
              title: "Book Appointment",
              disable: false,
            ),)
          ],
        ),
      ),
    );
  }
}

class DocDet extends StatelessWidget {
  const DocDet({super.key,required this.doctor});

  final Map<dynamic,dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage("http://127.0.0.1:8000${doctor['doctor_profile']}"),
          ),
          config.screensmall,
          Text(
            "Dr ${doctor['doctor_name']}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          config.screensmall,
          SizedBox(
            width: config.screenWidth! * 0.75,
            child: Text(
              "MBBS (International Medical University, Malaysia) MRCP (Royal Collage Of Physicians, United Kingdom)",
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          config.screensmall,
          SizedBox(
            width: config.screenWidth! * 0.75,
            child: Text(
              "Sarawak General Hospital",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class AboutDoc extends StatelessWidget {
  const AboutDoc({super.key, required this.doctor});

  final Map<dynamic, dynamic> doctor ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          config.screensmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoCard(label: "Patients", i: "${doctor['patients']}"),
              SizedBox(width: 15,),
              InfoCard(label: "Experiences", i: "${doctor['experience']}"),
              SizedBox(width: 15,),
              InfoCard(label: "Rating", i: "4.6"),
            ],
          ),
          config.screenmedium,
          Text("About Doctor",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
          config.screensmall,
          Text("Dr ${doctor['doctor_name']} is an experience ${doctor['category']} at Sarawak. He/She is graduated since 2008, and completed his training at Sungai Buloh General Hospital",
          style: TextStyle(
            fontWeight: FontWeight.w500,height: 1.5,
          ),softWrap: true,textAlign: TextAlign.justify,)
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.i});

  final String label;
  final String i;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: config.primaryColor
        ),
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        child: Column(
          children: [
            Text(label, style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white
            ),),
            SizedBox(height: 10,),
            Text(i, style: TextStyle(
              fontSize: 13,fontWeight: FontWeight.bold,color: Colors.white
            ),),
          ],
        )
      ),
    );
  }
}
