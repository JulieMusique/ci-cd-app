import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/home/landing_screen.dart';
import 'package:flutter_ui_food_delivery_app/login/forgot_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_input.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_text.dart';

import '../model/User.dart';

class LoginInputScreen extends StatefulWidget {
  LoginInputScreen();

  @override
  _LoginInputScreenState createState() => _LoginInputScreenState();
}

class _LoginInputScreenState extends State<LoginInputScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    final String email = emailController.text;
    final String password = passwordController.text;

    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/DelivCROUS/users/login/$email/$password'),
      );
      print(response.statusCode);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        print(userData);
        final User user = User.fromJson(userData);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LandingScreen(user)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur d\'authentification'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Gestion des erreurs en cas d'exception
      print('Erreur lors de la requête HTTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 24),
        child: Column(
          children: [
            // Champ de texte pour l'e-mail
            Padding(
              padding: EdgeInsets.only(bottom: 42),
              child: AppInputText(
                controller: emailController,
                hint: "Your Email", // Invite de champ pour l'e-mail
              ),
            ),
            // Champ de texte pour le mot de passe
            Padding(
              padding: EdgeInsets.only(bottom: 42),
              child: AppInputText(
                controller: passwordController,
                hint: "Password",
                obscureText: true,
              ),
            ),
            // Texte "Forgot password?" pour réinitialiser le mot de passe
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 42),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: AppText(
                      color: vermilion,
                      size: 17,
                      weight: FontWeight.w600,
                      text: "Forgot password?",
                      textAlign: TextAlign.start,
                    ),
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: vermilion,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : loginUser, // Utilisez onPressed au lieu de onTap loginUser
              child: Text(
                isLoading ? 'Loading...' : 'Login',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: athens_gray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
