import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_button.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_input.dart';

class SignUpInputScreen extends StatefulWidget {
  SignUpInputScreen();

  @override
  _SignUpInputScreenState createState() => _SignUpInputScreenState();
}

class _SignUpInputScreenState extends State<SignUpInputScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) {
    // Utilisation d'une expression régulière pour valider l'e-mail
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    // Utilisation d'une expression régulière pour valider le mot de passe
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*\d)(?!.*[&%$#@!])[A-Za-z\d&%$#@!]{8,12}$');
    return passwordRegex.hasMatch(password);
  }

  bool isPhoneValid(String phone) {
    // Utilisation d'une expression régulière pour valider le numéro de téléphone
    final phoneRegex =
        RegExp(r'^\d{10}$'); // Valide un numéro de téléphone de 10 chiffres
    return phoneRegex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Champ de texte pour le nom complet
              AppInputText(
                controller: firstNameController,
                hint: "FirstName", // Invite de champ pour le nom complet
              ),
              SizedBox(height: 20),
              AppInputText(
                controller: lastNameController,
                hint: "LastName", // Invite de champ pour le nom complet
              ),
              SizedBox(height: 20),
              // Champ de texte pour l'e-mail
              AppInputText(
                controller: emailController,
                hint: "Email", // Invite de champ pour l'e-mail
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              AppInputText(
                controller: phoneController,
                hint: "Téléphone",
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              AppInputText(
                controller: addressController,
                hint: "Adresse",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              AppInputText(
                controller: loginController,
                hint: "Login",
              ),
              SizedBox(height: 20),
              // Champ de texte pour le mot de passe
              AppInputText(
                controller: passwordController,
                hint: "Password", // Invite de champ pour le mot de passe
                obscureText: true, // Le texte est masqué pour les mots de passe
              ),
              SizedBox(height: 20),
              SizedBox(height: 30),
              // Bouton "SignUp" pour s'inscrire
              AppButton(
                bgColor: vermilion,
                borderRadius: 30,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                onTap: () async {
                  final firstName = firstNameController.text;
                  final lastName = lastNameController.text;
                  final email = emailController.text;
                  final address = addressController.text;
                  final phone = phoneController.text;
                  final login = loginController.text;
                  final password = passwordController.text;

                  if (!isEmailValid(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('L\'adresse e-mail n\'est pas valide.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
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

                  if (!isPhoneValid(phone)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Le numéro de téléphone n\'est pas valide.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final user = User(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      address: addressController.text,
                      phone: phoneController.text,
                      login: loginController.text,
                      password: passwordController.text,
                      soldeCarteCrous: Random().nextDouble() * 150 + 20);
                  final response = await http.post(
                    Uri.parse('http://localhost:8080/DelivCROUS/users'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(
                        user.toJson()), // Convertir l'utilisateur en JSON
                  );
                  print(user.toJson());
                  print(response.statusCode);
                  // Passez l'instance de User à ProfileScreen
                  if (response.statusCode == 201) {
                    // L'inscription a réussi, redirigez l'utilisateur vers le profil
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  } else if (response.statusCode == 409) {
                    // L'email existe déjà, affichez un message d'erreur
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'L\'email existe déjà dans la base de données.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Gestion d'autres erreurs
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur lors de l\'inscription.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                text: "SignUp", // Texte du bouton d'inscription
                textColor: athens_gray, // Couleur du texte du bouton
              ),
            ],
          ),
        ),
      ),
    );
  }
}
