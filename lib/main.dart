import 'package:coronaupdate/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: SplashScreen(),
  theme: ThemeData(
      primaryColor: Colors.lightBlue,
      primaryTextTheme:
      TextTheme(title: TextStyle(color: Colors.white, fontSize: 26))),
));
