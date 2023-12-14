import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/home/main_screen.dart';
import 'package:flutter_ui_food_delivery_app/home/navigation_screen.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';

class LandingScreen extends StatefulWidget {
  final User user; // Ajoutez le paramètre user ici

  LandingScreen(this.user);
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>{
   
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   

    return Scaffold(
      body: Stack(
        children: [mainScreen()],
      ),
    );
  }

  Widget mainScreen() {
    return  MainScreen(
            user: widget.user,
            onTap: () {
 
            },
          );
  }
}