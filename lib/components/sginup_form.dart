import 'package:dio/dio.dart';
import 'package:doctor_app_appointment/main.dart';
import 'package:doctor_app_appointment/models/login_auth.dart';
import 'package:doctor_app_appointment/providers/dio_provider.dart';
import 'package:doctor_app_appointment/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottum.dart';

class SignUPForm extends StatefulWidget {
  const SignUPForm({super.key});

  @override
  State<SignUPForm> createState() => _SignUPFormState();
}

class _SignUPFormState extends State<SignUPForm> {
  final formkey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _namecontroller,
            keyboardType: TextInputType.text,
            cursorColor: config.primaryColor,
            decoration: InputDecoration(
              hintText: "Username",
              labelText: "Username",
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person),
              prefixIconColor: config.primaryColor,
            ),
          ),
          config.screensmall,
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
              title: 'Sign up',
              onPressed: () async {

                final registerUser = await DioProvider().
                registerUser(_namecontroller.text, _emailcontroller.text, _passwordcontroller.text);
                print(registerUser);
                if(registerUser) {
                  final Token = await DioProvider()
                      .getToken(
                      _emailcontroller.text, _passwordcontroller.text);

                  if (Token) {
                    auth.LoginSuccess({},{});
                    MyApp.navigatorKey.currentState!.pushNamed('main');


                  }
                }else{
                  print('Register not successful');
                }

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
