import 'dart:convert';

import 'package:doctor_app_appointment/main.dart';
import 'package:doctor_app_appointment/models/login_auth.dart';
import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottum.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final formkey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailcontroller,
            keyboardType: TextInputType.emailAddress,
            cursorColor: config.primaryColor,
            decoration: InputDecoration(
              hintText: "Email address",
              labelText: "Email",
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email),
              prefixIconColor: config.primaryColor,
            ),
          ),
          config.screensmall,
          TextFormField(
            controller: _passwordcontroller,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: config.primaryColor,
            obscureText: obscure,
            decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: config.primaryColor,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: obscure
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.black38,
                        )
                      : Icon(
                          Icons.visibility_outlined,
                          color: Colors.black38,
                        ),
                )),
          ),
          config.screensmall,
          Consumer<AuthModel>(builder: (context, auth , child){
            return Button(
              width: double.infinity,
              title: 'Log in',
              onPressed: () async {
                final Token = await DioProvider()
                    .getToken(_emailcontroller.text, _passwordcontroller.text);

                if(Token){
                  final SharedPreferences preferences = await SharedPreferences.getInstance();
                  final token = preferences.getString('Token')??'';
                  print("token $token");
                  if(token.isNotEmpty && token != ''){
                    final response = await DioProvider().getUser(token);
                    print("before $response");
                    if(response != null){
                      setState((){
                        print("after $response");
                        Map<String,dynamic> appointment = {};
                        final user = json.decode(response);

                        for(var doctorData in user['doctor']){
                          if(doctorData['appointments'] != null){
                            appointment = doctorData;
                          }
                        }

                        print("user is $user");
                        auth.LoginSuccess(user, appointment);
                        MyApp.navigatorKey.currentState!.pushNamed('main');
                      });
                    }
                  }
                }
                print(Token);
                //final user = await DioProvider().getUser(Token);

                // Navigator.of(context).pushNamed('main');
              },
              disable: false,
            );
          }),
        ],
      ),
    );
  }
}
