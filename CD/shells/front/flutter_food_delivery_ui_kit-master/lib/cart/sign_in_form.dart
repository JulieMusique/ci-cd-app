import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ui_food_delivery_app/cart/cart_screen.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';

import '../model/Command.dart';
import '../utils/metrics.dart';

bool isShowSignInDialog = false;

class SignInModel extends StatelessWidget {
  final String screen;
  final User user;
  final Command command;

  const SignInModel(
      {super.key,
      required this.screen,
      required this.user,
      required this.command});

  @override
  Widget build(BuildContext context) {
    String currentAddress = '';
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(blurRadius: 10, color: AppColor.lighterGray)],
            color: AppColor.white,
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                'images/address.svg', // Remplacez par le chemin vers votre image SVG pour l'adresse
                width: 30, // Ajustez la largeur selon vos besoins
                height: 30, // Ajustez la hauteur selon vos besoins
              ),
              SizedBox(width: 8),
              Text(
                "Adresse",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return listItems.where((String item) {
                    return item
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String item) {
                  print('The $item was selected');
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: (_) => onFieldSubmitted(),
                    decoration: InputDecoration(
                      hintText: 'Num de Voie, Rue/Bd/av, nom, CP Ville, Pays ',
                      suffixIcon: IconButton(
                        icon: Icon(Icons
                            .save), // Utilisez l'icône d'enregistrement ou un autre de votre choix
                        onPressed: () {
                          if (!listItems.contains(currentAddress)) {
                            listItems.add(
                                currentAddress); // Ajoutez l'adresse si elle n'est pas dans la liste
                          }
                          // Réinitialisez l'adresse actuelle après l'avoir ajoutée
                          currentAddress = '';
                        },
                      ),
                    ),
                    onChanged: (value) {
                      currentAddress = value; // Mettre à jour l'adresse saisie
                    },
                  );
                },
              ),

              SizedBox(width: 20), // Espacement entre l'image et le TextField
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      totalAmount(command),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Solde:",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              "\$${user.soldeCarteCrous}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 28),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
