import 'package:doctor_app_appointment/main.dart';
import 'package:doctor_app_appointment/screens/doctor_details.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';


class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor,required this.isfav});

  final Map<String,dynamic> doctor;
  final bool isfav;
  @override
  Widget build(BuildContext context) {
    config().init(context);
    return Container(
      padding: EdgeInsets.all(10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: config.screenWidth! *  0.33,
                child: Image.network("http://127.0.0.1:8000${doctor['doctor_profile']}", fit: BoxFit.fill,),
              ),
              Flexible(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dr ${doctor['doctor_name']}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    Text("${doctor['category']}",style: TextStyle(fontSize: 14,),),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.star_border,color: Colors.yellow,size: 16,),
                        Spacer(flex: 1,),
                        Text('4.5'),
                        Spacer(flex: 1,),
                        Text('Reviews'),
                        Spacer(flex: 1,),
                        Text('(22)'),
                        Spacer(flex: 7,),
                      ],
                    )

                  ],
                ),
              ))
            ],
          ),
        ),
        onTap: (){
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(builder: (_)=>DoctorDetails(
            doctor: doctor,isfav: isfav,
          ) ));
        } // Doctors Details,
      ),
    );
  }
}
