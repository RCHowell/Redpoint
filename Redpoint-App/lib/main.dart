import 'package:flutter/material.dart';
import 'package:red_point/theme.dart';
import 'package:red_point/pages/home.dart';

void main() {

  String title = 'RED Point';

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: theme,
    home: Home(),
  ));

}
