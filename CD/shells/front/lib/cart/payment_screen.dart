import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/cart/order_confirmed.dart';
import 'package:flutter_ui_food_delivery_app/cart/order_error.dart';
import 'package:flutter_ui_food_delivery_app/http/HttpServiceCart.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'sign_in_form.dart';

bool isSufficientBalance(User user, double totalAmount) {
  //Verifie si le solde est superieur au prix de la commande
  return user.soldeCarteCrous >= totalAmount;
}

void showCustomDialog(BuildContext context,
    {required ValueChanged onValue, required User user, required command}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 620,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const Text(
                      "Please fill in this form ",
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                    ),
                    SignInModel(
                        screen: "Address", user: user, command: command),
                    AppButton(
                      bgColor: vermilion,
                      borderRadius: 30,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      onTap: () async {
                        if (isSufficientBalance(
                            user, command.totalAmount as double)) {
                          final response = await http.put(Uri.parse(
                              'http://localhost:8080/DelivCROUS/users/payment/${user.id}/${command.totalAmount}'));
                          if (response.statusCode == 204) {
                            final reponse = await http.get(Uri.parse(
                                "http://localhost:8080/DelivCROUS/users?identifiant=${user.id}"));
                            List<dynamic> userDataList =
                                json.decode(reponse.body);
                            Map<String, dynamic> userData = userDataList[0];
                            User updatedUser = User.fromJson(userData);
                            print(updatedUser.soldeCarteCrous);
                            confirmCommand(command);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderConfirmed(
                                      user: reponse.statusCode == 200
                                          ? updatedUser
                                          : user)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Solde insuffisant pour passer la commande.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderError(user: user)),
                          );
                        }
                      },
                      text: "Confirm order",
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: -48,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  ).then(onValue);
}
