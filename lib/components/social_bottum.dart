import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';

class SocialBottun extends StatelessWidget {
  const SocialBottun({super.key, required this.social});

  final String social;
  @override
  Widget build(BuildContext context) {
    config().init(context);
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 15),
            side: BorderSide(color: Colors.black, width: .75)),
        onPressed: () {},
        child: SizedBox(
          width: config.screenWidth! * 0.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/$social.png",
                  width: 40,
                  height: 40,
                ),
              ),
              Text(
                '$social'.toUpperCase(),
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ));
  }
}
