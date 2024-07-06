import 'package:doctor_app_appointment/components/doctor_card.dart';
import 'package:doctor_app_appointment/models/login_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Text('My Favorite Doctors',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Expanded(
                child: Consumer<AuthModel>(
                  builder: (context,auth,child){
                    return ListView.builder(
                        itemCount: auth.getFavDoc.length,
                        itemBuilder: (context, index){
                          return DoctorCard(
                              doctor: auth.getFavDoc[index],isfav: true,);
                        });
                  },
                ))
          ],
        ),
        ));
  }
}
