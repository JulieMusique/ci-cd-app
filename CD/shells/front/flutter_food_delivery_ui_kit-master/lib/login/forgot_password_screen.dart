import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_input.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen();

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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

  bool isPasswordValid(String password) {
    // Utilisation d'une expression régulière pour valider le mot de passe
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*\d)(?!.*[&%$#@!])[A-Za-z\d&%$#@!]{8,12}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> changePassword() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (!isPasswordValid(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Le mot de passe n\'est pas valide. Le nombre de caractères doit être compris entre 8 et 12 avec une lettre maj minimum.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8080/DelivCROUS/users/forgotPassword/$email/$password'),
      );
      print(response.statusCode);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 204) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de modification du mot de passe'),
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
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
                // Champ de texte pour nouveau mot de passe
                Padding(
                  padding: EdgeInsets.only(bottom: 42),
                  child: AppInputText(
                    controller: passwordController,
                    hint: "Your new password",
                    obscureText: true,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: vermilion,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isLoading ? null : changePassword,
                  child: Text(
                    isLoading ? 'Loading...' : 'Change password',
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
        ));
  }
}
