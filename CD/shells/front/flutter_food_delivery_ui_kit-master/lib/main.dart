import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/login/login_screen.dart';
import 'package:flutter_ui_food_delivery_app/login/onboardingScreen.dart';
import 'package:flutter_ui_food_delivery_app/utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App - Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Rounded',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnboardScreen(),
      routes: {
        Routes.login: (context) => LoginScreen(),
        Routes.intro: (context) => OnboardScreen(),
      },
    );
  }
}
