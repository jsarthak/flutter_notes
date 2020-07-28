import 'package:flutter/material.dart';

//rgb(255, 214, 51)

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  primaryColorLight: Color.fromARGB(255, 245, 245, 245),
  primarySwatch: Colors.grey,
  accentColor: Color.fromARGB(255, 78, 51, 255),
  brightness: Brightness.light,
  canvasColor: Colors.transparent,
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.white,
  primarySwatch: Colors.grey,
  accentColor: Color.fromARGB(255, 78, 51, 255),
  brightness: Brightness.light,
  canvasColor: Colors.transparent,
);
