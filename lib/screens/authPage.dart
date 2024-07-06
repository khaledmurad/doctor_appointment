import 'package:doctor_app_appointment/components/social_bottum.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';

import '../components/login_form.dart';
import '../components/sginup_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignin = true;
  @override
  Widget build(BuildContext context) {
    config().init(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              config.screensmall,
              Text(
                _isSignin?
                "Log in to your account":
                "You can easily signup and connect to the doctors nearby you",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              config.screensmall,
              _isSignin?
              LogInForm():
              SignUPForm(),
              config.screensmall,
              _isSignin?
              Center(
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forget your password!",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ):Container(),
              Spacer(),
              Center(
                child: Text(
                  "Or continue with soical account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:
                  Colors.grey.shade500),
                ),
              ),
              config.screensmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialBottun(social: 'facebook'),
                  SocialBottun(social: 'google'),
                ],
              ),
              config.screensmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isSignin?
                    "Don\'t have an account?":
                    "Already have an account?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:
                    Colors.grey.shade500),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState((){
                        _isSignin = !_isSignin;
                      });
                    },
                    child: Text(
                      _isSignin?
                      "Sign Up":
                      "Log in",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:
                      Colors.black),
                    ),
                  ),
                ],
              ),
              config.screensmall,
            ],
          ),
        ),
      ),
    );
  }
}
