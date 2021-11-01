import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'color.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Jannah',
  primarySwatch: Colors.amber,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
  ),
  primaryColor:  Colors.black ,
  accentColor:defaultColor,
  backgroundColor:  Colors.grey.shade700 ,
  scaffoldBackgroundColor: Colors.black,
  indicatorColor:  Color(0xff0E1D36) ,
  buttonColor: Color(0xff3B3B3B) ,
  hintColor: Colors.grey.shade300 ,
  highlightColor: Color(0xff372901) ,
  hoverColor: Color(0xff3A3A3B) ,
  focusColor:  Color(0xff0B2512),
  disabledColor: Colors.grey,
  textSelectionColor:  Colors.white ,
  cardColor:  Color(0xFF151515) ,
  canvasColor:  Colors.black ,
  brightness: Brightness.dark ,
  textTheme: TextTheme(
    subtitle1: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.white),
    bodyText2: TextStyle(
      color: Colors.grey,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    subtitle2: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      height: 1.3,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      /*shadows: [
                      Shadow(
                        offset: Offset(0.0,15),
                        color:Colors.black,
                        blurRadius: 40,
                      ),
                    ],*/
    ),
    headline6: TextStyle(
      height: 1.5,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
  ),
);
ThemeData lightTheme = ThemeData(
  fontFamily: 'Jannah',
  scaffoldBackgroundColor: Colors.grey.shade300,
  primarySwatch: Colors.amber,
  primaryColor: Colors.grey.shade300,
  accentColor: defaultColor,
  backgroundColor: Colors.white,
  indicatorColor:  Color(0xffCBDCF8),
  buttonColor:  Color(0xffF1F5FB),
  hintColor: Colors.grey.shade800,
  highlightColor:  Color(0xffFCE192),
  hoverColor:  Color(0xff4285F4),
  focusColor: Color(0xffA8DAB5),
  disabledColor: Colors.grey,
  textSelectionColor:  Colors.black,
  cardColor: Colors.white,
  canvasColor: Colors.grey[50],
  brightness:  Brightness.light,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black),
    bodyText2: TextStyle(
      color: Colors.grey,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    subtitle2: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Colors.black,
    ),
    bodyText1: TextStyle(
      height: 1.3,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      /*shadows: [
                      Shadow(
                        offset: Offset(0.0,15),
                        color:Colors.black,
                        blurRadius: 40,
                      ),
                    ],*/
    ),
    headline6: TextStyle(
      height: 1.5,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
  ),

);