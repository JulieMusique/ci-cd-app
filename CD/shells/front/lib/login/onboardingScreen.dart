import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/utils/routes.dart';
import 'package:lottie/lottie.dart';

class OnboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Food Express",
            style: TextStyle(
              color: Colors.black,
             fontFamily: 'Comic Sans MS, Arial', 
            ), // Couleur du texte de l'app bar
          ),
          backgroundColor: Color(0xFFD2F5AF), // Couleur de l'app bar
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lottie Animation
              Lottie.asset(
                '/anim/onboard_anim.json', // Assurez-vous que le chemin est correct
                fit: BoxFit.contain,
                height: 300,
                width: 300,
              ),
              const SizedBox(
                  height: 20), // Espacement entre l'animation et le message

              // Message
              const Text(
                "Welcome to Food Express",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                  height: 20), // Espacement entre le message et le bouton

              // Bouton "Get Food"
              ElevatedButton(
                onPressed: () {
                Navigator.pushNamed(context, Routes.login);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2F5AF), // Couleur du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Arrondi des coins
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical:
                          16.0), 
                  child: Text(
                    "Get Food",
                    style: TextStyle(fontSize: 18, color : Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
