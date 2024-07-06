import 'package:flutter/material.dart';

class config {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  //define screen height
  static const screensmall = SizedBox(
    height: 25,
  );
  static final screenmedium = SizedBox(
    height: screenHeight! * 0.05,
  );
  static final screenbig = SizedBox(
    height: screenHeight! * 0.08,
  );

  //text form field border
  static const outLineBorder =
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)));
  static const focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.blueGrey));
  static const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.red));

  static final primaryColor = Colors.blueGrey;
}
