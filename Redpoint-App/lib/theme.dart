import 'package:flutter/material.dart';

const textDark = const Color.fromRGBO(160, 160, 160, 1.0);
const red = const Color.fromRGBO(227, 83, 84, 1.0);
const darkRed = const Color.fromRGBO(207, 76, 77, 1.0);

ThemeData theme = ThemeData(
  primaryColor: red,
  primaryColorDark: darkRed,
  disabledColor: darkRed,
  splashColor: darkRed,
  // canvasColor: Colors.blueGrey[800],
  // cardColor: Colors.blueGrey[800],
  scaffoldBackgroundColor: Colors.blueGrey[50],
  colorScheme: ColorScheme.light(
    primary: red,
    primaryVariant: darkRed,
    secondary: red,
    secondaryVariant: darkRed,
  ),
  primaryTextTheme: TextTheme(
    headline1: TextStyle(
        color: Colors.white,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: 20.0),
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
        color: Colors.blueGrey[800],
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        fontSize: 16.0),
    bodyText1: TextStyle(
        color: textDark,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: 14.0),
    bodyText2: TextStyle(
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
    headline1: TextStyle(
      color: red,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      fontSize: 60.0,
      height: 0.85,
    ),
    headline2: TextStyle(
        color: Colors.blueGrey[800],
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: 18.0),
    headline4: TextStyle(
      // color: Color.fromRGBO(111, 111, 111, 0.7),
      color: Colors.white,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),
  ),
  primaryIconTheme: IconThemeData(
    color: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: textDark,
  ),
  textSelectionColor: Colors.white,
  hintColor: Colors.white,
);
