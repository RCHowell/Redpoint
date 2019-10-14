import 'package:flutter/material.dart';

const textDark = const Color.fromRGBO(160, 160, 160, 1.0);
const red = const Color.fromRGBO(227, 83, 84, 1.0);
const darkRed = const Color.fromRGBO(207, 76, 77, 1.0);

ThemeData theme = ThemeData(
  primaryColor: red,
  primaryColorDark: darkRed,
  disabledColor: darkRed,
  accentColor: red,
  splashColor: darkRed,
  // canvasColor: Colors.blueGrey[800],
  // cardColor: Colors.blueGrey[800],
  scaffoldBackgroundColor: Colors.blueGrey[50],
  primaryTextTheme: TextTheme(
      title: TextStyle(
          color: Colors.white,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
          fontSize: 20.0),
      headline: TextStyle(),
      subhead: TextStyle(),
      body1: TextStyle(),
      body2: TextStyle(),
      button: TextStyle(),
      caption: TextStyle(),
      display1: TextStyle(),
      display2: TextStyle(),
      display3: TextStyle(),
      display4: TextStyle()),
  textTheme: TextTheme(
    title: TextStyle(
        color: red,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: 20.0),
    headline: TextStyle(
        color: Colors.blueGrey[800],
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: 18.0),
    subhead: TextStyle(
        color: Colors.blueGrey[800],
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        fontSize: 16.0),
    body1: TextStyle(
        color: textDark,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: 14.0),
    body2: TextStyle(
        color: Color.fromRGBO(111, 111, 111, 1.0),
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w600,
        fontSize: 14.0),
    button: TextStyle(
        color: Colors.white,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w600,
        fontSize: 14.0),
    caption: TextStyle(
        color: Colors.blueGrey[800],
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w300,
        fontSize: 10.0),
    display1: TextStyle(
      color: red,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      fontSize: 60.0,
      height: 0.85,
    ),
    display2: TextStyle(),
    display3: TextStyle(),
    display4: TextStyle(
      // color: Color.fromRGBO(111, 111, 111, 0.7),
      color: Colors.white,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),
  ),
  accentTextTheme: TextTheme(
      title: TextStyle(
          color: red,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 20.0),
      headline: TextStyle(),
      subhead: TextStyle(),
      body1: TextStyle(
          color: Color.fromRGBO(111, 111, 111, 1.0),
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w300),
      body2: TextStyle(),
      button: TextStyle(),
      caption: TextStyle(),
      display1: TextStyle(),
      display2: TextStyle(),
      display3: TextStyle(),
      display4: TextStyle()),
  primaryIconTheme: IconThemeData(
    color: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: textDark,
  ),
  textSelectionColor: Colors.white,
  hintColor: Colors.white,
);
